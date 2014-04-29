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

def usage
  puts <<-"__USAGE__"
usage: wikipedia.rb <query_string>
  __USAGE__
  exit 0
end

if ARGV.size > 0
  title = URI.escape(ARGV[0])
  # XXX: is there any good module to escape '&'?
  title = title.gsub('&', '%26')
  url = "http://ja.wikipedia.org/w/api.php?action=query&export&format=json&titles=#{ title }"
  p url
else
  usage()
end

wiki = WikiParser.fromUrl(url)
wiki.parse()
puts wiki.toJson(true)
puts wiki.result.length()

