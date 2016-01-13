Dir['lib/*.rb', 'ATM/lib/*.rb'].each { |file| require_relative file }
require 'pry'

secret = 42712945
atm = Atm.new(10_000, secret)
person = Person.new('Bob', 2000)
person2 = Person.new('Mark', 30_000)
worker = Person.new('Tom', 10_000)

person.create_account_with(2000, 1234)
person2.create_account_with(15_000, 8392)
person2.create_account_with(5000, 9292)
worker.hire_for_bank(secret)

binding.pry