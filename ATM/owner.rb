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
   
   def create_account
       
   end
end