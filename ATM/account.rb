class Account

  attr_reader :owner
  attr_accessor :balance

  def initialize(owner, balance, pin)
    @owner = owner
    @balance = balance
    @pin_hash = Random.new(pin)
  end

  def validate_pin(pin)
    Random.new(pin).rand(10_000_000_000) == @pin_hash.rand(10_000_000_000)
  end

  #add
  #withdraw
  #display_balance
end