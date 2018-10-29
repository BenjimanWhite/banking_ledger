class Transaction

  attr_reader :amount, :starting_balance, :balance, :type, :date, :time

  def initialize(amount, starting_balance, type)
    @amount = amount
    @starting_balance = starting_balance
    @type = type
    @balance = @type == :withdrawal ? (starting_balance - amount) : (starting_balance + amount)
    @date = Time.now.to_s.split(' ')[0]
    @time = Time.now.to_s.split(' ')[1]
  end

  def to_s
  	puts "~" * 50
    puts "Date: #{@date}"
    puts "Time: #{@time}"
    puts "Type: #{@type}"
    puts "Amount: #{@amount}"
    puts "Starting Balance: #{@starting_balance}"
    puts "Final Balance: #{@balance}"
    puts "~" * 50
  end
  
end