##### 2.1 単一責任のクラスを設計する #####

# オブジェクト指向設計のシステムの基礎は「メッセージ」です。

# しかし、その組織の構造で最も目立つのは「クラス」です。。。

# クラスに属するものをどのように決めるかについて、集中的に取り扱います。

# 現段階で第一にやるべきことは、深呼吸をして「シンプルであれと主張すること」です。
# 目標はアプリケーションをモデル化することです。
# クラスを使い、「いますぐに」求められる動作を行い、かつ「あとにも」かんたんに変更できるようにモデル化する。




##### クラスに属するものを決める  #####

# 問題は技術的知識に関することではなく、構造に関することなのです。コードの書き方は知っているけれど、どこに置けばよいのかわからない、そんな段階を考えてみましょう。


### メソッドをグループに分けクラスにまとめる ###

# Rubyのようなクラスベースのオブジェクト指向言語では、メソッドはクラス内に定義されます。
# どんなクラスをつくるかによって、そのアプリケーションに対する考え方が永久に変わります。
# クラスはソフトウェアにおける仮想の世界を定義します。

# メソッドを正しくグループ分けし、クラスにまとめることはとても重要です。にもかかわらず、現在のようなプロジェクトの初期段階では、正しくグループ分けすることは到底できません。初期段階での知識量は、プロジェクト全体で言えば一番少ないのです。

# 設計とはアプリケーションの可変性を保つために技巧を凝らすことであり、完璧を目指すための行為ではありません。



### 変更がかんたんなようにコードを組成する ###

# 「変更がかんたんである」ことの定義
# ・変更は副作用をもたらさない
# ・要件の変更が小さければ、コードの変更も相応にして小さい
# ・既存のコードはかんたんに再利用できる
# ・最もかんたんな変更方法はコードの追加である。ただし追加するコードはそれ自体変更が容易なものとする

# 上記のように定義するとすれば、自身の書くコードには次の性質が伴うべきです。
# コードは次のようであるべきでしょう。

# ・見通しが良い（Transparent）：変更するコードにおいても、そのコードに依存する別の場所のコードにおいても、変更がもたらす影響が明白である
# ・合理的（Reasonable）：どんな変更であっても、かかるコストは変更がもたらす利益にふさわしい
# ・利用性が高い（Usable）：新しい環境、予期していなかった環境でも再利用できる
# ・模範的（Exemplary）：コードに変更を加える人が、上記の品質を自然と保つようなコードになっている
#
# 見通しが良く、合理的で、利用性が高く、模範的（それぞれの英単語の頭文字をとってTRUE）なコードはいま現在のニーズを満たすだけではなく、
# 将来的なニーズを満たすように変更を加えることもできます。
# TRUEなコードを書くための最初の一歩は、それぞれのクラスが、明確に定義された単一の責任を持つよう徹底することです。





##### 2.2 単一責任のクラスをつくる #####
# クラスはできる限り最小で有用なことをするべき。
# つまり、単一の責任を持つべき



########################################
chainring = 52 # 歯数
cog = 11
ratio = chainring / cog.to_f
puts ratio # -> 4.72727272727273

chainring = 30
cog = 27
ratio = chainring / cog.to_f
puts ratio # -> 1.11111111111111

puts "########################################"

class Gear
  attr_reader :chainring, :cog

  def initialize(chainring, cog)
    @chainring = chainring
    @cog = cog
  end

  def ratio # 比率
    chainring / cog.to_f
  end
end

puts Gear.new(52, 11).ratio # -> 4.7272727272727275
puts Gear.new(30, 27).ratio # -> 1.1111111111111112

puts "########################################"

class Gear
  attr_reader :chainring, :cog, :rim, :tire

  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @rim = rim
    @tire = tire
  end

  def ratio # 比率
    chainring / cog.to_f
  end

  def gear_inches
    # タイヤはリムの周りを囲むので、直径を計算するためには２倍にする
    ratio * (rim + (tire * 2))
  end

end

puts Gear.new(52, 11, 26, 1.5).gear_inches
puts Gear.new(52, 11, 26, 1.25).gear_inches

puts "########################################"

# これはバグる
# puts Gear.new(52, 11).ratio
# 2.rb:35:in `initialize': wrong number of arguments (given 2, expected 4) (ArgumentError)

puts "########################################"

# インスタンス変数の隠蔽
# インスタンス変数は常にアクセサメソッドで包み、直接参照しないようにします。
# 以下に示すratioメソッドのようにします
class Gear
  def initialize(chainring, cog)
    @chainring = chainring
    @cog = cog
  end

  def ratio
    @chainring / @cog  # ← 破滅への道
  end
end
puts "########################################"
# 変数はそれらを定義しているクラスからでさえも隠蔽しましょう。
# 隠蔽するにはメソッドで包みます。
# Rubyにはカプセル化用のメソッドをつくる方法として、attr_renderが用意されている。
class Gear
  attr_reader :chainring, :cog

  def initialize(chainring, cog)
    @chainring = chainring
    @cog = cog
  end

  def ratio
    chainring / cog # ←
  end
end
puts "########################################"
# attr_renderを使うと、Rubyは自動でインスタンス変数用の単純なラッパーメソッド(包み隠すメソッド)をつくります。
# コグ(cog)を例にとると、実質以下のように定義したことになります

# attr_renderによる、デフォルトの実装
def cog
  @cog
end
# このcogメソッドは、コード内で唯一コグ（cog）が何を意味するのかをわかっている箇所です。
# 「コグ」はメッセージの戻り値となりました。このメソッドを実装することで、
# コグはデータ（どこからでも参照される）から振る舞い（1カ所で定義される）へと変わります。


puts "########################################"


class RevealingReferences
  attr_reader :wheels

  def initialize(data)
    @wheels = wheelify(data)
  end

  def diameters
    wheels.collect do |wheel|
      diameter(wheel)
    end
  end

  def diameter(wheel)
    wheel.rim + (wheel.tire * 2)
  end

  Wheel = Struct.new(:rim, :tire)
  def wheelify(data)
    data.collect do |cell|
      Wheel.new(cell[0], cell[1])
    end
  end

end

# diametersメソッドは、配列の内部構造について何も知りません。
# diametersが知っているのは、wheelsメッセージが何か列挙できるものを返し、
# その列挙されるもの1つ1つがrimとtireに応答するということだけです。
# cell[1]への参照だったものは、いまはwheel.tireに送るメッセージに姿を変えています。

# 渡されてくる配列の構造に関する知識は、すべてwheelifyメソッド内に隔離され

# wheelifyはrimとtireに応答する、小さくて軽量なオブジェクトをつくっているのです。


# クラス内の余計な責任を隔離する

# Gear を単一責任にするには、車輪のような振る舞いを取り除くことが不可欠

class Gear
  attr_reader :chainring, :cog, :wheel

  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @wheel = Wheel.new(rim, tire)
  end

  def ratio
    chainring / cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter
  end

  # 新しいクラスを作らず、Wheel Struct をブロックで拡張し、直径を計算するメソッドを追加する
  # Gearをきれいにしながらも、Wheelに関する決定は遅らせています
  Wheel = Struct.new(:rim, :tire) do
    def diameter
      rim + (tire * 2)
    end
  end

end


puts "########################################"


# WheelをGear内に埋め込むことで、WheelはGearのコンテキストにおいてのみ存在すると設計者が想定していることがわかります。
# 現実世界のことを考えてみると、一般的ではない
#
# もし、責任がありすぎて混沌としているクラスがあれば、それらの責任は別のクラスに分けましょう。
# 最も重要なクラスに集中してください。
# 責任を決定し、その決定は徹底して守ります。
# まだ取り除けない余計な責任を見つけたら、隔離しましょう。
# 本質的でない責任がクラスにじわじわ入り込んでいくのを許してはいけません。


# ついに、実際のWheelの完成

# 次に
#
# WheelクラスをGearから独立させて使いたいという明確なニーズがアプリケーションに出てきたことです。Wheelを解放し、それ自身で独立したクラスにするときがきました。先にWheelの振る舞いを注意深く分けてGearクラス内に隔離しておいたおかげで、この変更は難しくありません。単にWheelStructを独立したWheelクラスに変えて、円周を計算するcircumferenceメソッドを新たに追加するだけです。

class Gear
  attr_reader :chainring, :cog, :wheel

  def initialize(chainring, cog, wheel=nil)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end

  #  比率
  def ratio
    chainring / cog.to_f
  end

  # ギアインチ
  def gear_inches
    ratio * wheel.diameter
  end

end

class Wheel
  attr_reader :rim, :tire

  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  # 直径
  def diameter
    rim + (tire * 2)
  end

  # 円周
  def circumference
    diameter * Math::PI
  end
end

@wheel = Wheel.new(26, 1.5)
puts @wheel.circumference # 91.106186954104

puts Gear.new(52, 11, @wheel).gear_inches # 137.0909090909091

# どちらのクラスも単一責任となっています。
# このコードも決して完璧なわけではありませんが、
# いくつかの点では、より高い水準を達成しています。
# 「十分に良い」と言えるでしょう。


# まとめ
# 変更可能でメンテナンス性の高いオブジェクト指向ソフトウェアへの道のりは、単一責任のクラスからはじまります。
# 1つのことに専念するクラスは、その1つのことをアプリケーションのほかの部位から「隔離」します。
# この隔離によって、悪影響を及ぼすことのない変更と、重複のない再利用が可能となるのです。


puts "########################################"
