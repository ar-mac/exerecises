require 'digest'

class Account

  attr_reader :owner, :card
  attr_accessor :balance

  def initialize(owner, balance, pin)
    @owner = owner
    @balance = balance
    @card = Card.new(owner, self)
    @pin_hash = Digest::MD5.digest pin.to_s
  end

  def validate_pin(pin)
    Digest::MD5.digest(pin.to_s) == @pin_hash
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