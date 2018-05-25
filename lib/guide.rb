require 'readline'
require 'yaml'
require 'pry'

class Guide
  attr_accessor :account_num, :balance, :account_id

  @@valid_actions = {"1" => "Display Balance",
                     "2" => "Withdraw",
                     "3" => "Log Out"}

  def initialize(banknotes, account_num, account_id)
    @account_num = account_num
    @account_balance = account_num["balance"]
    @balance = banknotes
    @account_id = account_id
  end

  def launch!
    output_introduction
    result = nil
    until result == :quit
      action, args = get_action
      result = do_action(action, args)
    end
    output_conclusion
  end

  private

  def get_action
    action = nil
    until @@valid_actions.keys.include?(action)
      puts "Action not recognized." if action
      output_valid_actions
      user_response = user_input('> ')
      args = user_response.split(' ')
      action = args.shift
    end
    return action, args
  end

  def do_action(action, args=[])
    case action
    when '1'
      show_balance
    when '2'
      withdraw
    when '3'
      quit
    end
  end

  def show_balance
    puts "\n\nYour Current Balance is ₴#{@account_balance}\n\n"
  end

  def withdraw
    @atm_balance = @balance.map{|k,v| k*v}.sum

    puts "\nEnter Amount You Wish to Withdraw:"

    user_response = user_input('> ')
    user_response = user_response.to_i

    if user_response > @atm_balance
      puts "ERROR: There is not enough money at the moment ₴#{@atm_balance}"
    elsif user_response > @account_balance
      puts "ERROR: Your balance at the moment ₴#{@account_balance}"
    else
      withdrawal = fetch_notes(user_response)
      @balance.merge!(withdrawal) do |key, existing, withdrawal|
        existing - withdrawal
      end
      withdrawal
    end
  end

  def fetch_notes(amount)
    withdrawn_notes = {}
    withdrawn_amount = 0

    notes = @balance.keys.sort.reverse

    notes.each do |note|
      max_notes = (amount - withdrawn_amount) / note
      actual_notes = [@balance[note], max_notes].min
      if actual_notes > 0
        withdrawn_amount += actual_notes * note
        withdrawn_notes[note] = actual_notes
      end
    end

    if withdrawn_amount < amount
      puts 'ERROR: Amount cannot be withdrawn. Please specify another amount.'
    else
      @account_balance = @account_balance - amount
      puts "Your New Balance is ₴#{@account_balance}"
    end

    withdrawn_notes
  end


  def output_introduction
    puts "\n\n<<< Welcome to the ATM >>>\n\n"
    puts "This is an interactive guide to help you work with ATM.\n\n"
    puts "Please Choose From the Following Options:\n\n"
  end

  def output_conclusion
    puts "\n<<< Goodbye >>>\n\n\n"
  end

  def output_valid_actions
    @@valid_actions.each do |key, value|
      puts "#{key}. #{value}"
    end
  end

  def user_input(prompt=nil)
    prompt ||= '> '
    result = Readline.readline(prompt, true)
    result.strip
  end

  def quit
    config = YAML.load_file('config.yml')
    config["banknotes"] = @balance
    config["accounts"][@account_id]["balance"] = @account_balance
    File.open("config.yml", 'w') { |f| YAML.dump(config, f) }
    return :quit
  end

end
