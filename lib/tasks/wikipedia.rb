# ページサーチ
# http://ja.wikipedia.org/w/api.php?\
# action=query\
# &format=json\
# &titles=%E5%83%95%E3%82%89%E3%81%AF%E3%81%BF%E3%82%93%E3%81%AA%E6%B2%B3%E5%90%88%E8%8D%98

# ページ情報
# http://ja.wikipedia.org/w/api.php?\
# action=query\
# &export\
# &titles=%E5%83%95%E3%82%89%E3%81%AF%E3%81%BF%E3%82%93%E3%81%AA%E6%B2%B3%E5%90%88%E8%8D%98

require 'open-uri'
require 'uri'
require './lib/tasks/parser/wiki.rb'
require './app/models/actor.rb'
require './app/models/program.rb'
require './app/models/character.rb'

def usage
  puts <<-"__USAGE__"
usage: wikipedia.rb <query_string>
  __USAGE__
  exit 0
end

if ARGV.size > 0
  filename = ARGV[0]
else
  usage()
end

wiki = WikiParser.fromFile(filename)
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
  character = Character.find_or_initialized_by(
    name: "#{wiki[:character]}",
    actor_id: actor.id,
    program_id: program.id
  )
  character.update_attributes(updated_at: Time.now)
end

puts wiki.toJson(true)
puts wiki.result.length()
