class Account

  attr_reader :owner
  attr_accessor :balance

  def initialize(owner, balance, pin)
    @owner = owner
    @balance = balance
    @card = Card.new(owner, self)
    @pin_hash = Random.new(pin)
  end

  def validate_pin(pin)
    Random.new(pin).rand(10_000_000_000) == @pin_hash.rand(10_000_000_000)
  end

  def show_balance
    "Your funds are #{balance}$"
  end

  def add(amount)
    @balance += amount
    "#{amount}$ added to your account"
  end

  def withdraw(amount)
    @balance -= amount
    "#{amount}$ taken from account"
  end
end