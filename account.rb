require './transaction.rb'

class Account
  
  attr_reader :username, :password, :transaction_list
  attr_accessor :balance

  def initialize(username, password, starting_balance)
    @username = username
    @password = password
    @balance = starting_balance
    @transaction_list = []
  end

  def make_deposit(amount)
  	rounded_amount = round_pennies(amount)

  	record_transaction(rounded_amount, @balance, :deposit)
    @balance += rounded_amount
  end

  def make_withdrawal(amount)
  	rounded_amount = round_pennies(amount)
    
    if valid_withdrawal?(rounded_amount)
      record_transaction(rounded_amount, @balance, :withdrawal)
      @balance -= rounded_amount
      return true
    else
      print_overdraft_attempt_error
      return false
    end
  end

  private

  def record_transaction(amount, balance, type)
  	new_transaction = Transaction.new(amount, balance, type)
    @transaction_list << new_transaction
  end
  
  def round_pennies(number)
    number.round(2)
  end

  def valid_withdrawal?(amount)
    amount < @balance
  end

  def print_overdraft_attempt_error
    puts "We're sorry, but you cannot withdraw more funds than you have available. Please try again"
  end

end