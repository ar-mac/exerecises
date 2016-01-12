class Atm

  attr_reader :cash, :current_card, :event_tracker
  def initialize(cash)
    @cash = cash
    @event_tracker = BankEvent.new
    @current_card = nil
  end

  def transaction(card)
    set_current_card(card)
    event_tracker.new_transaction
    event_tracker.show('Type your PIN')
    pin = gets.chomp
    catch(:authentication_error) do
        authenticate(pin)
      catch(:action_failure) do
        proceed_action
      end
    end
    event_tracker.show('Please take out your card')
    gets
    reset_current_card
  end

  private

  def set_current_card(card)
    @current_card = card
  end

  def reset_current_card
    @current_card = nil
  end

  def authenticate(pin)
    check_card_status
    authenticate_pin(pin)
    true
  end

  def proceed_action
    event_tracker.show("PIN correct.\n-d- To display your balance\n-w- To withdraw money\n-i- To insert money")
    action = gets.chomp
    event_tracker.save("action chosed #{action}")
    case action
      when /(d|display)/ then display
      when /(w|withdraw)/ then withdraw
      when /(i|insert)/ then add
    end
  end

  def display
    event_tracker.show(card.account.show_balance)
  end

  def withdraw
    event_tracker.show("Type amount you would like to withdraw")
    amount = gets.chomp.to_i
    event_tracker.save("amount chosen #{amount}")
    check_if_sufficient_funds(amount)
    event_tracker.show(current_card.account.withdraw(amount))
  end

  def add
    event_tracker.show("Insert money")
    amount = gets.chomp.to_i
    event_tracker.save("amount inserted #{amount}")
    event_tracker.show(current_card.account.add(amount))
  end

  def check_if_sufficient_funds(amount)
    if amount > cash
      event_tracker.run(NoEnoughCashInAtmError)
      throw(:action_failure)
    elsif amount > current_card.account.balance
      event_tracker.run(NoEnoughCashInAccountError)
      throw(:action_failure)
    else
      true
    end
  end

  def check_card_status
    return true if current_card.enabled?
    event_tracker.run(DisabledCardError)
    throw(:authentication_error)
  end

  def authenticate_pin(pin)
    if current_card.account.validate_pin(pin)
      return true
    else
      current_card.lock
      event_tracker.run(WrongPinError)
      false
    end
  end
end

class NoEnoughCashInAccountError
  def self.message
    "No sufficient funds on your account\nTransaction aborted"
  end
end

class NoEnoughCashInAtmError
  def self.message
    "No sufficient funds in ATM\nTransaction aborted"
  end
end

class DisabledCardError
  def self.message
    "Your card is disabled.\nTransaction aborted"
  end
end

class WrongPinError
  def self.message
    "Wrong pin provided.\nYour card is locked.\nTransaction aborted"
  end
end
