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

  def ratio
    chainring / cog.to_f
  end
end

puts Gear.new(52, 11).ratio # -> 4.72727272727273
puts Gear.new(30, 27).ratio # -> 1.11111111111111
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
