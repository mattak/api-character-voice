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
      # : [[声優|声]] - [[柿原徹也]]、[[MAKO]]（少年時代）
      # : 声 - [[平野綾]]
      # :: 声 - [[平野綾]]
      actor_candinates_raw = nil
      if lines[index] =~ /^[\s:]{1,}\s*声\s*\-\s*(.+)/
        actor_candinates_raw = $1
      elsif lines[index] =~ /^[\s:]{1,}\s*\[{2}[^\|\]]*\|?声\]{2}\s*\-\s*(.+)/
        actor_candinates_raw = $1
      else
        next
      end

      # [[柿原徹也]]、[[MAKO]]（少年時代）
      actor_candinates = []
      if actor_candinates_raw !~ /\[{2}[^\]]+\]{2}/
        actor_candinates_raw.gsub!(/[\(（][^）\)]+[\)）]/, '')
        actor_candinates = actor_candinates_raw.split(/[\/、]/)
      else
        actor_candinates_raw.gsub(/\[{2}([^\|\]]*\|)?([^\]]+)\]{2}/) do |matched|
          actor_candinates.push($2)
        end
      end

      # finalize
      actor_candinates = actor_candinates.collect do |actor|
        actor.gsub(/[\s　]+/,'')
      end

      if actor_candinates.size() > 0 && index > 0
        p actor_candinates
        character = nil
        # :; ヒビキ・レイティス
        if lines[index-1] =~ /^[:\s]{0,};\s*(.+)/
          character = $1
        elsif lines[index-1] =~ /^\={2,6}\s*([^\=]+)\s*\={2,6}/
          character = $1
        end

        if character != nil
          character.gsub!(/[\(（][^）\)]+[\)）]/, '')
          character.gsub!(/[\s　]+/, '')
          actor_candinates.each do |actor|
            result.push({character: character, actor: actor})
          end
        end
      end
    end

    @result = result
    return self
  end

  def parseLine(lines, index)
    result = parseLineDL(lines, index)
    return result if result != nil
    result = parseLineH5(lines, index)
    return result if result != nil
  end

  def parseLineDL(lines, index)
    line = lines[index]
    # ex "; 東 兎角（あずま とかく）"
    # ex "; 河合 住子（かわい すみこ）<ref group="注">アニメ1話より。原作での姓は表記されず。</ref>"
    if /^;\s*(.+)\s*$/ =~ line
      character = $1
      character = character \
        .gsub(/\s+/,'') \
        .gsub(/[\(（][^\)）]+[\)）].*/, '') \
        .gsub(/\[{2}([^\]]+\|)?([^\]]+)\]{2}/, '\2')
      if index < lines.size
        # ex ": 声 - [[花澤香菜]]<ref character="ours201403" />"
        if lines[index+1] =~ /^\s*:\s*声\s+\-\s+\[{2}([^\]]+\|)?([^\]]+)\]{2}/
          actor = $2.gsub(/\s+/,'')
          puts "#{character} -- #{actor}"
          return {character: character, actor: actor}
        end
      end
    end

    return nil
  end

  def parseLineH5(lines, index)
    line = lines[index]
    # ex "===== 矢澤 にこ（やざわ にこ） ====="
    if /^={5}\s+(.+)\s*={5}$/ =~ line
      character = $1
      character = character.gsub(/\s+/,'').gsub(/[\(（].+[\)）]/, '')
      if index < lines.size
        # ": 声 - [[徳井青空]]"
        if lines[index+1] =~ /^\s*:.+\[{2}([^\]]+)\]{2}/
          actor = $1.gsub(/\s+/,'')
          puts "#{character} -- #{actor}"
          return {character: character, actor: actor}
        end
      end
    end

    return nil
  end
end
