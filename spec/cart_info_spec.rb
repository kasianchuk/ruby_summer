require 'guide'
require 'cart_info'
require 'yaml'
require 'pry'

describe CartInfo do

  let(:test_file) { 'spec/fixtures/config.yml' }
  let(:config) { YAML.load_file(test_file) }
  subject { CartInfo.new(config) }

  let (:valid_account) {subject.accounts[3321]}

  describe "validation atm card" do
    it "user enter valid account_id and password" do
      expect(valid_account["password"]).to eq("mypass")
    end

    it "user enter valid account_id and wrong password" do
      expect(valid_account["password"]).not_to eq("mypass2")
    end

    it "user enter invalid account_id" do
      expect(subject.accounts).not_to include(777)
    end
  end
end
