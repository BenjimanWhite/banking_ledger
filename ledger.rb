require './account.rb'

class Ledger

  def initialize
    @accounts = []
  end

  def login_workflow
    print_welcome_prompt
    response = gets.chomp

	  if is_yes?(response)
	    login
	  elsif is_no?(response)
	    print_create_account_prompt
	    response = gets.chomp

	    if is_yes?(response)
	      create_account_workflow
	    else
	      print_goodbye_message
        exit
	    end

	  else
	    print_generic_error
	    login_workflow
	  end
  end

  def login
    print_username_prompt
    username = gets.chomp

    if has_account?(username)
      account = find_account_by_username(username)
      print_password_prompt
      password = gets.chomp

      if valid_password?(username, password)
      	print_account_options_welcome(account)
        account_workflow(account)
      else
        print_invalid_password_error
        login
      end

    else
      print_no_account_error
      create_account_workflow
    end
  end

  def create_account_workflow
    print_new_account_username_prompt
	  username = gets.chomp

		if has_account?(username)
      print_username_taken_error
      create_account_workflow
		end

		print_new_account_password_prompt
		password = gets.chomp

		print_initial_funds_prompt 
		response = gets.chomp

		if is_yes?(response)
	  	puts "Great! How much would you like to deposit? Please enter a valid number."
    	initial_deposit = gets.chomp.to_f.abs # Happy path only at this time
		elsif is_no?(response)
	  	initial_deposit = 0.0
		end

    new_account = Account.new(username, password, 0)
    new_account.make_deposit(initial_deposit) if initial_deposit > 0
		@accounts << new_account
		print_account_create_success

		login_workflow
  end

  def account_workflow(account)
    print_account_options_prompt

    loop do
      response = gets.chomp

      case response
      when "logout"
        logout

      when "balance"
        show_account_balance(account)

      when "deposit"
        do_the_deposit(account)
      
      when "withdrawal"
        do_the_withdrawal(account)
      

      when "history"
        show_history(account)

      else
  	    print_generic_error
      end

      prompt_for_further_action
    end
  end

  private

  def show_account_balance(account)
    puts "Your current balance is #{account.balance}\n"
  end

  def do_the_deposit(account)
    puts "Please enter the amount you would like to deposit:"
    deposit_amount = gets.chomp.to_f.abs # Next steps: validate this input as a Float
    
    account.make_deposit(deposit_amount)
    puts "Success! #{deposit_amount} has been added to your account. Your new balance is #{account.balance}\n"
  end

  def do_the_withdrawal(account)
    puts "Please enter the amount you would like to withdraw:"
    withdrawal_amount = gets.chomp.to_f.abs # Next steps: validate this input as a Float
    if account.make_withdrawal(withdrawal_amount)
      puts "Success! #{withdrawal_amount} has been withdrawn from your account. Your new balance is #{account.balance}\n"
    end
  end

  def show_history(account)
    account.transaction_list.each { |transaction| transaction.to_s }
  end

  def is_yes?(string)
    return true if string =~ /^([Yy][Ee][Ss]|[Yy])$/
	return false
  end

  def is_no?(string)
    return true if string =~ /^([Nn][Oo]|[Nn])$/
	return false
  end

  def logout
    puts "you are now logged out."
    login_workflow
  end

  def has_account?(username)
    find_account_by_username(username) != nil
  end

  def find_account_by_username(username)
    @accounts.select { |account| account.username == username }.first
  end

  def valid_password?(username, password)
    account_to_verify = find_account_by_username(username)
    account_to_verify.password == password
  end

  # --- Print helper methods ---

  def print_a_pretty_line
    puts "~*" * 40
  end

  def print_account_options_prompt
  	print_a_pretty_line
    puts "Typing [logout] will log you out of your account."
    puts "Typing [balance] will display your current account balance."
    puts "Typing [deposit] will help you deposit funds to your account."
    puts "Typing [withdrawal] will help you withdraw funds from your account."
    puts "typing [history] will display your transaction history"
    print_a_pretty_line
  end

  def prompt_for_further_action
    puts "Would you like to do anything else?"
  end

  def print_welcome_prompt
  	print_a_pretty_line
    puts "Hello! Welcome to The World's Greatest Banking Application."
    puts "\n"
    puts "Do you already have an account with us? [Y/N]"
  end

  def print_create_account_prompt
    puts "Would you like to create an account with us? [Y/N]"
  end

  def print_username_prompt
    puts "Please enter your account username:"
  end

  def print_password_prompt
    puts "Please enter your password:"
  end

  def print_account_options_welcome(account)
    puts "Hi, #{account.username}! What would you like to do with this account?"
  end

  def print_invalid_password_error
    puts "We're sorry, but the password you provided is invalid. Please try again."
  end

  def print_no_account_error
    puts "Sorry, it does not appear that you have an account. Please create one in order to use our application."
  end

  def print_new_account_username_prompt
    puts "Please enter a username for your new account:"
  end

  def print_username_taken_error
    puts "We're sorry, but that username is already taken. Please try another one."
  end

  def print_new_account_password_prompt
    puts "Thank you! Now please enter a password for your new account:"
  end

  def print_initial_funds_prompt
    puts "Thank you! Do you have any funds that you would like to deposit right now? [Y/N]"
  end

  def print_account_create_success
    puts "Everything looks good! Your account has been created. Now it's time to log in!"
  end

  def print_goodbye_message
    puts "Thanks for stopping by! See you next time."
  end

  def print_generic_error
    puts "I'm sorry, but that is not a valid response at this time. Please try again."
  end

end

