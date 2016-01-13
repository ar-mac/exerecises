class Person

  attr_reader :name
  attr_accessor :card, :account, :security_key

  def initialize(name, cash)
    @name = name
    @card = nil
    @account = nil
    @security_key = nil
    @cash = cash
  end

  def create_account_with(amount, pin)
    @account = Account.new(self, amount, pin)
    @card = account.card
  end

  def hire_for_bank(secret)
    @security_key = Key.new(secret)
  end

  def use_atm(atm)
    atm.transaction(card)
  end

  def use_atm_as_authority(atm)
    atm.authority_transaction(security_key)
  end
end