require 'yaml'
require 'pry'

require_relative('lib/guide')
require_relative('lib/cart_info')

config = YAML.load_file(ARGV.first || 'config.yml')

checking_cart = CartInfo.new(config)

checking_cart.start
