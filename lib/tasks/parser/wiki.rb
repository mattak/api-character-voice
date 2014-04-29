# -*- encoding: utf-8 -*-
require 'nokogiri'
require 'json'

class WikiParser
  attr_accessor :content, :result

  def initialize(content)
    @content = content
  end

  def self.fromUrl(url)
    charset = nil
    json_str = open(url) do |f|
      charset = f.charset
      f.read
    end
    self.fromJson(json_str, charset)
  end

  def self.fromJson(raw, charset)
    json = JSON.parse(raw)
    xml = json['query']['export']['*']
    self.fromXml(xml, charset)
  end

  def self.fromXml(xml, charset)
    doc = Nokogiri::HTML.parse(xml, nil, charset)
    content = doc.xpath('//revision/text').text
    return WikiParser.new(content)
  end

  def toJson(pretty=false)
    if pretty
      return JSON.pretty_generate(@result)
    else
      return JSON.generate(@result)
    end
  end

  def parse()
    result = []
    lines = content.split(/\n/)

    lines.each_with_index do |line, index|
      # parse actor
      actors = parseActors(line)

      # parse character
      if actors.size() > 0 && index > 0
        character = parseCharacter(lines[index-1])

        # join
        if actors.size() > 0 && character != nil
          actors.each do |actor|
            result.push({character: character, actor: actor})
          end
        end
      end
    end

    @result = result
    return self
  end

  def parseActors(line)
    # pre-processing
    line = removeSpan(line)
    line = removeVisibleAnchor(line)
    line = removeRefs(line)
    line = removeParenthesis(line)
    line = removeComment(line)

    # : 声 - [[平野綾]]
    # :: 声 - [[平野綾]]
    # : [[声優|声]] - [[柿原徹也]]、[[MAKO]]
    actors_raw = nil
    if line =~ /^[\s:]{1,}\s*声\s*\-\s*(.+)/
      actors_raw = $1
    elsif line =~ /^[\s:]{1,}\s*\[{2}[^\|\]]*\|?声\]{2}\s*\-\s*(.+)/
      actors_raw = $1
    else
      return []
    end

    # [[柿原徹也]]、[[MAKO]]
    actors = []
    if actors_raw !~ /\[{2}[^\]]+\]{2}/
      actors = actors_raw.split(/[\/、]/)
    else
      actors_raw.gsub(/\[{2}([^\|\]]*\|)?([^\]]+)\]{2}/) do |matched|
        actors.push($2)
      end
    end

    # post-processing
    actors = removeSpaces(actors)
    return actors
  end

  def parseCharacter(line)
    # pre-processing
    line = removeSpan(line)
    line = removeVisibleAnchor(line)
    line = removeRefs(line)
    line = removeParenthesis(line)
    line = removeComment(line)
    line = removeSquareBracket(line)

    character = nil
    # :; ヒビキ・レイティス
    if line =~ /^[:\s]{0,};\s*(.+)/
      character = $1
    elsif line =~ /^\={2,6}\s*([^\=]+)\s*\={2,6}/
      character = $1
    end

    # post-processing
    if character != nil
      character = removeSpace(character)
    end

    return character
  end

  def removeRefs(line)
    # remove <ref />
    line = line.gsub(/<[^>]+\/>/, '')
    # remove <ref >...</ref>
    line = line.gsub(/<[^>]+>[^<]*<\/[^>]*>/, '')
  end

  def removeSpan(line)
    line = line.gsub(/<span[^>]*>([^<]*)<\/span[^>]*>/, '\1')
  end

  def removeVisibleAnchor(line)
    line = line.gsub(/\{{2}([^\|\}]*\|)?([^\}]+)\}{2}/, '\2')
  end

  def removeParenthesis(line)
    # remove (...)
    line = line.gsub(/[\(（][^）\)]*[\)）]/, '')
  end

  def removeSquareBracket(line)
    line = line.gsub(/\[{2}([^\|\]]*\|)?([^\]]+)\]{2}/, '\2')
  end

  def removeSpace(e)
    e.gsub(/[\s　]+/, '')
  end

  def removeSpaces(arrays)
    arrays.collect do |e|
      removeSpace(e)
    end
  end

  def removeComment(line)
    line.gsub(/<\!\-\-\s*[^>]*\s*\-\->/, '')
  end
end
