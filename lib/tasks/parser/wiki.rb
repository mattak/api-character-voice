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

  def parse()
    result = []
    level = nil
    start = false
    lines = content.split(/\n/)
    lines.each_with_index do |line, index|
      if /^(={2,5})\s+登場人物\s+={2,5}/ =~ line
        level = $1.length
        p "-----START------ #{start}"
        start = true
        next
      elsif level != nil && /^(={2,5})\s+[^=]+\s+={2,5}/ =~ line
        level_end = $1.length
        if start == true && level == level_end
          p "-----END------ #{start}"
          start = false
          next
        end
      end

      if start == true
        character_actor = parseLine(lines,index)
        result.push(character_actor) if character_actor != nil
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
    p line
    # ex "; 東 兎角（あずま とかく）"
    if /^;\s+(.+)\s*$/ =~ line
      character = $1
      character = character.gsub(/\s+/,'').gsub(/[\(（].+[\)）]/, '')
      if index < lines.size
        # ex ": 声 - [[花澤香菜]]<ref character="ours201403" />"
        if lines[index+1] =~ /^\s*:.+\[{2}([^\]]+)\]{2}/
          actor = $1.gsub(/\s+/,'')
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

  def toJson(pretty=false)
    if pretty
      return JSON.pretty_generate(@result)
    else
      return JSON.generate(@result)
    end
  end
end
