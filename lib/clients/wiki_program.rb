#!/usr/bin/env ruby

require 'open-uri'
require 'uri'
require 'fileutils'
require 'clients/wiki/parser.rb'

module Clients
  class WikiProgram

    def self.getwrite_by_stdin()
      STDIN.each do |line|
        line.chomp!
        next if /^\#/ =~ line

        puts line
        self.getwrite(line)
      end
    end

    def self.getwrite_by_list(listfile)

      File.open(listfile).each do |line|
        line.chomp!

        next if /^\#/ =~ line

        puts line
        self.getwrite(line)
      end
    end

    FILE_DIR = 'tmp/clients/wiki/'

    def self.getwrite(title)
      FileUtils.mkdir_p FILE_DIR
      result = self._get(title)

      wiki = Clients::Wiki::Parser.fromJson(result, 'utf-8')
      savepath = FILE_DIR + URI.escape(wiki.title)

      puts savepath

      File.open(savepath, "w") do |fo|
        fo.write result
      end
    end

    def self.get(title)
      result = self._get(title)
      puts result
    end

    def self._get(title)
      # title -> url
      title_escape = URI.escape(title)
      # XXX: is there any good module to escape '&'?
      title_escape = title_escape.gsub('&', '%26')
      url = "http://ja.wikipedia.org/w/api.php?action=query&export&format=json&titles=#{ title_escape }"

      # get
      json_str = open(url) do |f|
        charset = f.charset
        f.read
      end

      # puts
      return json_str
    end

    def self.parse_list_by_stdin()
      STDIN.each do |line|
        next if /^#/ =~ line
        line.chomp!
        puts line

        self.parse(line)
      end
    end

    def self.parse(filename)
      wiki = Clients::Wiki::Parser.fromFile(filename)
      wiki.parse()

      raise "result not found" if wiki.result == nil
      raise "content not found" if wiki.content == nil
      raise "title not found" if wiki.title == nil

      # create program
      program = Program.find_or_initialize_by(title: "#{wiki.title}")
      program.update_attributes(from: Date.new(2014, 4, 1))

      # create actor
      wiki.result.each do |chara_actor|
        character_name = chara_actor[:character]
        actor_name     = chara_actor[:actor]

        # create actor
        actor = Actor.find_or_initialize_by(name: "#{actor_name}")
        actor.update_attributes(birth: Date.new(0, 1, 1))

        # create character
        character = Character.find_or_initialize_by(
          name: "#{ character_name }",
          actor_id: actor.id,
          program_id: program.id
        )
        character.update_attributes(updated_at: Time.now)
      end

      puts wiki.toJson(true)
      puts wiki.result.length()
    end
  end
end
