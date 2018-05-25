require 'readline'

class CartInfo

  attr_accessor :information, :accounts, :banknotes

  def initialize(information)
    @accounts = information["accounts"]
    @banknotes = information["banknotes"]
  end

  def start
    password = "password"
    name = "name"

    puts "Please Enter Your Account Number:"
    account_num = user_input('> ')
    account_num = account_num.to_i

    puts "Enter Your Password:"
    account_pass = user_input('> ')

    if @accounts.include? account_num
      if @accounts[account_num][password] == account_pass
        puts "Hello, #{@accounts[account_num][name]}!"
        guide = Guide.new(@banknotes, @accounts[account_num], account_num)
        guide.launch!
      else
        puts "Wrong password"
      end
    else
      puts "Account doesn't exist"
    end
  end


  def user_input(prompt=nil)
    prompt ||= '> '
    result = Readline.readline(prompt, true)
    result.strip
  end
end
