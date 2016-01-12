class Card

  attr_reader :owner, :account, :enabled
  alias_method :enabled?, :enabled

  def initialize(owner, account)
    @owner = owner
    @account = account
    @enabled = true
  end

  def lock
    @enabled = false
  end

  def unlock
    @enabled = true
  end

  def disabled?
    !enabled
  end

end