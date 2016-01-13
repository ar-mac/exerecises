require 'forwardable'
require 'digest'

class Atm
  extend Forwardable

  attr_reader :cash, :current_card, :event_tracker
  def_delegators :@event_tracker, :show_logs

  def initialize(cash, security_num)
    @cash = cash
    @event_tracker = BankEvent.new
    @current_card = nil
    @security_num = Digest::MD5.digest security_num.to_s
  end

  def transaction(card)
    set_current_card(card)
    event_tracker.new_transaction
    catch(:authentication_error) do
      check_card_status
      event_tracker.show('Type your PIN')
      pin_digest = Digest::MD5.digest(STDIN.gets.chomp)
      authenticate_pin(pin_digest)
      catch(:action_failure) do
        proceed_action
      end
    end
    event_tracker.show('Please take out your card')
    STDIN.gets
    reset_current_card
  end

  def authority_transaction(key)
    event_tracker.new_transaction(:authority)
    catch(:authentication_error) do
      authorize_key(key)
      catch(:action_failure) do
        proceed_authority_action
      end
    end
    event_tracker.show('Please take out your key')
    STDIN.gets
  end

  private

  def authorize_key(key)
    if key.security_num.rand(10_000_000_000) == @security_num.rand(10_000_000_000)
      event_tracker.show("Key autenticated.\nAccess granted.")
    else
      event_tracker.run(WrongKeyError)
      throw(:authentication_error)
    end
  end

  def proceed_action
    event_tracker.show("-d- To display your balance\n-w- To withdraw money\n-i- To insert money")
    action = STDIN.gets
    event_tracker.save("action chosed #{action}")
    case action
      when /(d|display)/i then
        display
      when /(w|withdraw)/i then
        withdraw
      when /(i|insert)/i then
        add
    end
  end

  def proceed_authority_action
    event_tracker.show("-f- To fill cash\n-t- To take out cash\n-l- To show logs")
    action = STDIN.gets
    event_tracker.save("action chosed #{action}")
    case action
      when /(f|fill)/i then
        fill
      when /(t|take)/i then
        take_out
      when /(l|log)/i then
        show_logs
    end
  end

  def fill
    event_tracker.show("Fill ATM cash reserve.")
    amount = STDIN.gets.chomp.to_i
    check_if_correct_funds(amount)
    event_tracker.show(add_funds(amount))
  end

  def take_out
    event_tracker.show("Take cash")
    amount = STDIN.gets.chomp.to_i
    check_if_sufficient_funds(amount, :authority)
    event_tracker.show(remove_funds(amount))
    event_tracker.show(current_card.account.withdraw(amount))
  end

  def check_card_status
    return if current_card.enabled?
    event_tracker.run(DisabledCardError)
    throw(:authentication_error)
  end

  def authenticate_pin(pin_digest)
    if current_card.account.validate_pin(pin_digest)
      event_tracker.show("PIN correct\nAccess granted.")
    else
      current_card.lock
      event_tracker.run(WrongPinError)
      throw(:authentication_error)
    end
  end

  def display
    event_tracker.show(current_card.account.show_balance)
  end

  def withdraw
    event_tracker.show("Type amount you would like to withdraw")
    amount = STDIN.gets.chomp.to_i
    event_tracker.save("amount chosen #{amount}")
    check_if_sufficient_funds(amount)
    event_tracker.show(remove_funds(amount))
  end

  def add
    event_tracker.show("Insert money")
    amount = STDIN.gets.chomp.to_i
    check_if_correct_funds(amount)
    event_tracker.show(add_funds(amount))
    event_tracker.show(current_card.account.add(amount))
  end

  def check_if_sufficient_funds(amount, operation_type = :civil)
    if amount <= 0
      event_tracker.run(ISeeWhatYouDidThereError)
      throw(:action_failure)
    elsif amount > cash
      event_tracker.run(NoEnoughCashInAtmError)
      throw(:action_failure)
    elsif operation_type == :civil && amount > current_card.account.balance
      event_tracker.run(NoEnoughCashInAccountError)
      throw(:action_failure)
    end
  end

  def check_if_correct_funds(amount)
    if amount <= 0
      event_tracker.run(ImpossibleSituationError)
      throw(:action_failure)
    elsif amount > current_card.owner.cash
      event_tracker.run(NotEnoughCashInPocketError)
      throw(:action_failure)
    end
  end
  
  def remove_funds(amount)
    @cash -= amount
    current_card.owner.cash += amount
    "#{amount}$ taken. ATM now holds #{cash}$"
  end

  def add_funds(amount)
    current_card.owner.cash -= amount
    @cash += amount
    "#{amount}$ added. ATM now holds #{cash}$"
  end

  def set_current_card(card)
    @current_card = card
  end

  def reset_current_card
    @current_card = nil
  end
end
