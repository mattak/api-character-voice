#!/usr/bin/env ruby

require 'open-uri'
require 'uri'
require 'clients/wiki/parser.rb'

module Clients
  class Wiki::Program
    def self.get(title)
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
      puts json_str
    end

    def self.parse(filename)
      wiki = Wiki::Parser.fromFile(filename)
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
