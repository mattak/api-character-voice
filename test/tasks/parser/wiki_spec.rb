require './lib/tasks/parser/wiki'

describe WikiParser do
  before do
  end

  after do
  end

  it "should parse content" do
    content = <<-__CONTENT__
; 竜神翔悟（りゅうじん しょうご）
: 声 - [[KENN]]
; ダーク[[カブトムシ|ビートル]]
: ダークボーンの一人。
; ダーク[[クモ|スパイダー]]
: 声 - [[楠大典]]
    __CONTENT__
    wiki = WikiParser.new(content)
    result = wiki.parse().result
    expect(result.size).to eq(2)
    expect(result[0]).to eq({:character=>"竜神翔悟", :actor=>"KENN"})
    expect(result[1]).to eq({:character=>"ダークスパイダー", :actor=>"楠大典"})
  end

  example 'should be parse h5 content' do
    content = <<-__CONTENT__
===== 西木野 真姫（にしきの まき） =====
: 声 - [[Pile]]

===== 矢澤 にこ（やざわ にこ） =====
: 声 - [[徳井青空]]

; 絢瀬 亜里沙（あやせ ありさ）
: 声 - [[佐倉綾音]]
    __CONTENT__

    result = WikiParser.new(content).parse().result
    expect(result.size).to eq(3)

    expect(result[0]).to eq({:character=>"西木野真姫", :actor=>"Pile"})
    expect(result[1]).to eq({:character=>"矢澤にこ", :actor=>"徳井青空"})
    expect(result[2]).to eq({:character=>"絢瀬亜里沙", :actor=>"佐倉綾音"})
  end

  it "should parse multiple actor" do
    content = <<-__CONTENT__
; カタムシビ姉妹
: 声 - [[山口繭]]（姉）、[[日比愛子]]（妹）
    __CONTENT__

    result = WikiParser.new(content).parse().result
    expect(result.size).to eq(2)
    expect(result.include?({:character=>"カタムシビ姉妹", :actor=>"山口繭"})).to be_true
    expect(result.include?({:character=>"カタムシビ姉妹", :actor=>"日比愛子"})).to be_true
  end

  it "should parse described quated actor" do
    content = <<-__CONTENT__
; 丸尾ミカ子
: 声 - [[金井美樹 (1996年生)|金井美樹]]
    __CONTENT__

    result = WikiParser.new(content).parse().result
    expect(result.size).to eq(1)
    expect(result.include?({:character=>"丸尾ミカ子", :actor=>"金井美樹"})).to be_true
  end

  example "should ignore ref" do
    content = <<-__CONTENT__
; 渡辺 彩花（わたなべ さやか）
: 声 - [[金元寿子]]<ref name="ours201403"/>
; 河合 住子（かわい すみこ）<ref group="注">アニメ1話より。原作での姓は表記されず。</ref>
: 声 - [[小林沙苗]]<ref name="ours201403"/>
    __CONTENT__

    result = WikiParser.new(content).parse().result
    expect(result.size).to eq(2)
    expect(result[0]).to eq({:character=>"渡辺彩花", :actor=>"金元寿子"})
    expect(result[1]).to eq({:character=>"河合住子", :actor=>"小林沙苗"})
  end

  it "should parse non quated voice actor" do
    content = <<-__CONTENT__
; レディ・ジュエル
: 声 - 平野綾
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size()).to eq(1)
    expect(result[0]).to eq({character: 'レディ・ジュエル', actor: '平野綾'})
  end

  it "should parse title with no space" do
    content = <<-__CONTENT__
; ルビー
: [[声|声]] - [[齋藤彩夏]]
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size()).to eq(1)
    expect(result[0]).to eq({character: 'ルビー', actor: '齋藤彩夏'})
  end

  it "should parse non spaced content" do
    content = <<-__CONTENT__
;春音あいら
:声 - [[阿澄佳奈]]
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size).to eq(1)
    expect(result[0]).to eq({character: '春音あいら', actor: '阿澄佳奈'})
  end

  it "can parse ref quated statement" do
    content = <<-__CONTENT__
; オーブラ 
: 声 - 下山吉光<ref>{{Cite web|publisher=あにてれ：FAIRY TAIL|url=http://www.tv-tokyo.co.jp/anime/fairytail/chara/enbu/ert/index.html|title=キャラクター 大鴉の尻尾（レイヴンテイル）|accessdate=2013-06-07}}</ref>
; ロキ<ref>アニメではレオとして登場する場合、エンディングクレジットも「レオ」表記になる。</ref>
: 声 - [[岸尾だいすけ]]
; ミラジェーン・ストラウス<ref name="comic30">単行本30巻より。</ref>
: 声 - [[小野涼子]]
; エルフマン・ストラウス<ref name="comic30"/>
: 声 - [[安元洋貴]]
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size).to eq(4)
    expect(result[0]).to eq({character: 'オーブラ', actor: '下山吉光'})
    expect(result[1]).to eq({character: 'ロキ', actor: '岸尾だいすけ'})
    expect(result[2]).to eq({character: 'ミラジェーン・ストラウス', actor: '小野涼子'})
    expect(result[3]).to eq({character: 'エルフマン・ストラウス', actor: '安元洋貴'})
  end

  it "can parse quated actor and ignore unquated" do
    content = <<-__CONTENT__
; バニッシュブラザーズ
: 声 - [[金野潤 (声優)|金野潤]]（兄）、遠藤大輔（弟）
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size).to eq(1)
    expect(result[0]).to eq({character: 'バニッシュブラザーズ', actor: '金野潤'})
  end

  it "can parse double character and double actor" do
    content = <<-__CONTENT__
; カプリコ / ゾルディオ
: 声 - [[黒田崇矢]]（カプリコ） / [[安元洋貴]]（ゾルディオ）
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size).to eq(2)
    expect(result[0]).to eq({character: 'カプリコ/ゾルディオ', actor: '黒田崇矢'})
    expect(result[1]).to eq({character: 'カプリコ/ゾルディオ', actor: '安元洋貴'})
  end

  it "may ignore double character when single one is unquated" do
    content = <<-__CONTENT__
; アルザック&ビスカ
: 声 - 下山吉光（アルザック）、[[新井里美]]（ビスカ）
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size).to eq(1)
    expect(result[0]).to eq({character: 'アルザック&ビスカ', actor: '新井里美'})
  end

  it "may ignore when triple character" do
    content = <<-__CONTENT__
; ケツプリ団
: 声 - 一条和矢（アニキ）、[[矢部雅史]]（子分A）、稲田徹（子分B）
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size).to eq(1)
    expect(result[0]).to eq({character: 'ケツプリ団', actor: '矢部雅史'})
  end

  it "can parse actor without parentthesis" do
    content = <<-__CONTENT__
; 鳳凰役
: 声 - FROGMAN（友情出演）
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size).to eq(1)
    expect(result[0]).to eq({character: '鳳凰役', actor: 'FROGMAN'})
  end

  it "may ignore general word actor" do
    pending("not implement")
    content = <<-__CONTENT__
; オフィウクス
: 声 - サウンドエフェクト
    __CONTENT__
  end

  it "can parse jojo character" do
    # pending("not implement")
    content = <<-__CONTENT__
; [[空条承太郎|空条 承太郎]]（くうじょう じょうたろう）
: 声 - [[梁田清之]] / [[小杉十郎太]] / 梁田清之 / [[小野大輔]] / 同左（小学生時代 - [[高森奈津美]]）
; [[ジョセフ・ジョースター]]
: 声 - [[内海賢二]]（1巻・3巻）、[[納谷悟朗]]（2巻） / [[大塚周夫]] / [[大川透]] / [[杉田智和]] / [[石塚運昇]]
; イギー
: 声 - なし / 同左 / 真殿光昭 / [[千葉繁]]
; エンヤ婆（エンヤ・ガイル）
: 声 - なし / [[深見梨加]] / [[高木早苗]] / [[三輪勝恵]] / [[鈴木れい子]]
; ヴァニラ・アイス
: 声 - なし / [[青野武]] / 岸祐二（第1作）、速水奨（第2作<ref group="注">ただし一部の技を使用したときのみ岸祐二の声になる。</ref>） / [[吉野裕行]]
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size).to eq(16)
    expect(result[0]).to eq({character: '空条承太郎', actor: '梁田清之'})
    expect(result[1]).to eq({character: '空条承太郎', actor: '小杉十郎太'})
    expect(result[2]).to eq({character: '空条承太郎', actor: '小野大輔'})
    # expect(result[3]).to eq({character: '空条承太郎', actor: '高森奈津美'})
    expect(result[3]).to eq({character: 'ジョセフ・ジョースター', actor: '内海賢二'})
    expect(result[4]).to eq({character: 'ジョセフ・ジョースター', actor: '納谷悟朗'})
    expect(result[5]).to eq({character: 'ジョセフ・ジョースター', actor: '大塚周夫'})
    expect(result[6]).to eq({character: 'ジョセフ・ジョースター', actor: '大川透'})
    expect(result[7]).to eq({character: 'ジョセフ・ジョースター', actor: '杉田智和'})
    expect(result[8]).to eq({character: 'ジョセフ・ジョースター', actor: '石塚運昇'})
    expect(result[9]).to eq({character: 'イギー', actor: '千葉繁'})
    expect(result[10]).to eq({character: 'エンヤ婆', actor: '深見梨加'})
    expect(result[11]).to eq({character: 'エンヤ婆', actor: '高木早苗'})
    expect(result[12]).to eq({character: 'エンヤ婆', actor: '三輪勝恵'})
    expect(result[13]).to eq({character: 'エンヤ婆', actor: '鈴木れい子'})
    expect(result[14]).to eq({character: 'ヴァニラ・アイス', actor: '青野武'})
    expect(result[15]).to eq({character: 'ヴァニラ・アイス', actor: '吉野裕行'})
  end

  it "should ignore comment" do
    content = <<-__CONTENT__
; 英雄崎凜（えいゆうざき りん）<!-- りんの字は『凜』（示ではなく禾）です -->
: 声 - [[日笠陽子]]
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size).to eq(1)
    expect(result[0]).to eq({character: '英雄崎凜', actor: '日笠陽子'})
  end
end

