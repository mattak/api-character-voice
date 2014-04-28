require './lib/tasks/parser/wiki'

describe WikiParser do
  before do
  end

  after do
  end

  example "should parse content" do
    content = <<-__CONTENT__
== 登場人物 ==
; 竜神翔悟（りゅうじん しょうご）
: 声 - [[KENN]]
: ドラゴンボーン（[[竜]]）の適合者・火のボーンファイター。
: 16歳。5月6日生まれ。ごく普通の高校生。成績も可も無く不可も無く、幼い頃から空手習う。喜怒哀楽が激しく、表情をよく変え、また年頃の少年らしい異性を意識した面もある。パーカー愛好者で、学ランのインナーにも普段着にも使う。ルークらと出会い、ドラゴンボーンの適合者として地球の運命を託されることになる。幼い頃に母親が出て行き、父の健悟、姉の智子と三人暮らし。
; ルーク
: 声 - [[立花慎之介]]
: [[オーストラリア]]出身。シャークボーン（[[鮫]]）の適合者・水のボーンファイター。22歳。7月22日生まれ。[[合気道]]の使い手。クールで、状況を的確に見極め、分析する翔悟らのリーダー的存在。だが、大の甘党だったり潮干狩りを語ったりと、まじめ一辺倒な人物ではない。

; ダーク[[カブトムシ|ビートル]]
: ダークボーンの一人。
; ダーク[[クモ|スパイダー]]
: 声 - [[楠大典]]
: ダークボーンの一人。最初にボーンクラッシュされた。ボーンクラッシュする直前に初めて喋り（言葉というより思念のようなもの）、翔悟に対し裏切り者と言い残し消滅した。
;[[ダークホース]]
: 消滅したダークスパイダーに代わり新たに現れたダークボーン。

== 用語 ==
    __CONTENT__
    wiki = WikiParser.new(content)
    result = wiki.parse().result
    expect(result.size).to eq(3)
    expect(result.include?({:character=>"竜神翔悟", :actor=>"KENN"})).to be_true
    expect(result.include?({:character=>"ルーク", :actor=>"立花慎之介"})).to be_true
    expect(result.include?({:character=>"ダークスパイダー", :actor=>"楠大典"})).to be_true
  end

  example 'should be parse h5 content' do
    content = <<-__CONTENT__
== 登場人物 ==
主に基礎設定、複数のメディアで共通する設定を記述する。各メディア固有の設定は別途記述する。付記された声優は、特記ない限り、テレビアニメ版における担当を指す。

=== 国立音ノ木坂学院 ===
穂乃果などが通う、[[秋葉原]]と[[神田 (千代田区)|神田]]と[[神保町]]という3つの街のはざまにある[[伝統校]]<ref>{{Cite web|url=http://www.lovelive-anime.jp/prologue.html|title=ラブライブ！Official Web Site ｜ プロローグ|accessdate=2013-01-22}}</ref>。女子校であり、現在[[入学]]希望者は少なく廃校の検討が発表されている。テレビアニメ版では、1年生は1クラス、2年生は2クラス、3年生は3クラスとなっている。

==== μ's（ミューズ） ====
<!--キャラクターの順番は『僕らのLIVE 君とのLIFE』等μ’sシングルのアーティスト表記順に準じる-->
スクールアイドルグループとして活動する、本作品のヒロイン。全メディアに登場。グループ名の読み「[[ミューズ]]」は[[ムーサ]]に由来する<ref name="gs1101">{{Cite journal|和書|journal=電撃G's magazine|issue=2011年1月号|pulisher=[[アスキー・メディアワークス]]|date=2010-11-30}}</ref><ref group="注">テレビアニメ版では、しばしば[[ミューズ (薬用石鹸)|薬用石鹸の商品名]]と間違えられる。</ref>。テレビアニメ版では、アイドル研究部に所属する。

===== 西木野 真姫（にしきの まき） =====
: 声 - [[Pile]]
: 誕生日 - [[4月19日]]（牡羊座）
: 血液型 - AB型

===== 矢澤 にこ（やざわ にこ） =====
: 声 - [[徳井青空]]
: 誕生日 - [[7月22日]]（蟹座）
: 血液型 - A型

; 絢瀬 亜里沙（あやせ ありさ）
: 声 - [[佐倉綾音]]
: テレビアニメ版に登場。
: 絵里の妹で、中学3年生。ロシアの暮らしが長いため日本の生活に疎いところがある。姉を通じμ'sのことが好きになった。姉妹共々「ハラショー（[[ロシア語]]で「素晴らしい」）」が口癖。
: 自宅に招いたり、オープンキャンパスや文化祭を一緒に見学に行く等、雪穂とは親しい仲である模様。

== アイドル活動 ==
    __CONTENT__

    result = WikiParser.new(content).parse().result
    expect(result.size).to eq(3)
    expect(result.include?({:character=>"絢瀬亜里沙", :actor=>"佐倉綾音"})).to be_true
    expect(result.include?({:character=>"矢澤にこ", :actor=>"徳井青空"})).to be_true
    expect(result.include?({:character=>"西木野真姫", :actor=>"Pile"})).to be_true
  end

  example "should parse 登場キャラクター" do
    content = <<-__CONTENT__
== 登場人物 ==
=== イマドキ妖怪 ===
; だるだるくつした
: 声 - [[疋田由香里]]
: くつしたを引っ張りだるだるにする妖怪。
; カタムシビ姉妹
: 声 - [[山口繭]]（姉）、[[日比愛子]]（妹）
: 紐を固結びするのが大好きな姉妹の妖怪。自分達が結んだ紐を目の前で解かれるととてもつらい。
; 丸尾ミカ子
: 声 - [[金井美樹 (1996年生)|金井美樹]]

== 著作 ==
    __CONTENT__

    result = WikiParser.new(content).parse().result
    expect(result.size).to eq(3)
    expect(result.include?({:character=>"だるだるくつした", :actor=>"疋田由香里"})).to be_true
    expect(result.include?({:character=>"カタムシビ姉妹", :actor=>"山口繭"})).to be_true
    expect(result.include?({:character=>"丸尾ミカ子", :actor=>"金井美樹"})).to be_true
  end

  example "should ignore ref" do
    content = <<-__CONTENT__
== 登場人物 ==
; 渡辺 彩花（わたなべ さやか）
: 声 - [[金元寿子]]<ref name="ours201403"/>
; 河合 住子（かわい すみこ）<ref group="注">アニメ1話より。原作での姓は表記されず。</ref>
: 声 - [[小林沙苗]]<ref name="ours201403"/>
    __CONTENT__

    result = WikiParser.new(content).parse().result
    expect(result.size).to eq(2)
    expect(result.include?({:character=>"渡辺彩花", :actor=>"金元寿子"})).to be_true
    expect(result.include?({:character=>"河合住子", :actor=>"小林沙苗"})).to be_true
  end

  example "should parse title with no space" do
    content = <<-__CONTENT__
==登場キャラクター==
{{節スタブ}}

===ジュエルペット===
本作ではジュエルパレスに集められたレディジュエル候補生たちのパートナーとして登場する。
; ルビー
: [[声|声]] - [[齋藤彩夏]]
; ルーア
: 声 - [[井口裕香]]
; レディ・ジュエル
: 声 - 平野綾
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size()).to eq(1)
    expect(result.include?({character: 'ルーア', actor: '井口裕香'})).to be_true
  end

  example "should parse 主なキャラクター1" do
    content = <<-__CONTENT__
== 主なキャラクター ==
*このメンバー4人がプチキャラとして登場する。
;春音あいら
:声 - [[阿澄佳奈]]
:プリティーリズム・オーロラドリームの主人公。
;上葉みあ
:声 - [[大久保瑠美]]
:プリティーリズム・ディアマイフューチャーの主人公。
== スタッフ ==
    __CONTENT__

    result = WikiParser.new(content).parse.result
    expect(result.size).to eq(2)
    expect(result.include?({character: '春音あいら', actor: '阿澄佳奈'})).to be_true
    expect(result.include?({character: '上葉みあ', actor: '大久保瑠美'})).to be_true
  end
end

