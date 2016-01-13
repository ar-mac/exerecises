class WrongKeyError
  def self.message
    "Inserted key is in unauthorized.\nTransaction aborted"
  end
end

class ImpossibleSituationError
  def self.message
    "It's impossible to put negative amount of cash into ATM\nTransaction aborted"
  end
end

class ISeeWhatYouDidThereError
  def self.message
    "You tried to withdraw negative amount of money, you naughty person.\nTransaction aborted"
  end
end

class NoEnoughCashInAccountError
  def self.message
    "No sufficient funds on your account\nTransaction aborted"
  end
end

class NoEnoughCashInPocketError
  def self.message
    "No sufficient funds in your pocket\nTransaction aborted"
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
