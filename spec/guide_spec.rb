require 'guide'
require 'yaml'
require 'pry'

describe Guide do

  let(:test_file) { 'spec/fixtures/config.yml' }
  let(:config) { YAML.load_file(test_file) }
  subject { Guide.new(config["banknotes"], config["accounts"][3321], 3321) }

  let(:banknotes) do
    {500=>0, 200=>0, 100=>2, 50=>1, 20=>2, 10=>4, 5=>1, 2=>0, 1=>2}
  end

  let(:account_num) do
    {"name"=>"Volodymyr", "password"=>"mypass", "balance"=>422}
  end

  let(:account_id) do
    3321
  end

  describe '#initialize' do

    it 'check_params' do
      expect(subject.balance).to eq(banknotes)
      expect(subject.account_num).to eq(account_num)
      expect(subject.account_id).to eq(account_id)
    end

  end

  describe '#launch!' do

    it 'outputs a introductory message' do
      setup_fake_input('3')
      expect { subject.launch! }.to output(/Welcome to the ATM/).to_stdout
    end

  end

  describe 'get_acton - сhecking the entered values' do

    context "invalid action" do
      it 'enter invalid action and exit' do
        setup_fake_input('invalid action', '3')
        expect { subject.launch! }.to output(/Action not recognized./).to_stdout
      end
    end

    context "show user balance" do
      it 'enter show_balance action and exit' do
        setup_fake_input('1', '3')
        expect { subject.launch! }.to output(/Your Current Balance is ₴422/).to_stdout
      end
    end

    context "withdraw" do

      it "withdraw money" do
        setup_fake_input('2', '200', '3')
        expect { subject.launch! }.to output(/Your New Balance is ₴222/).to_stdout
      end

      it "withdraw money more that user have in balance " do
        skip('after increase balance in the atm')
        setup_fake_input('2', '500', '3')
        expect { subject.launch! }.to output(/ERROR: Your balance at the moment ₴422/).to_stdout
      end

      it "withdraw money more that atm have " do
        setup_fake_input('2', '500000', '3')
        expect { subject.launch! }.to output(/ERROR: There is not enough money at the moment ₴337/).to_stdout
      end

      it "withdraw banknotes that not present in atm" do
        setup_fake_input('2', '3', '3')
        expect { subject.launch! }.to output(/ERROR: Amount cannot be withdrawn. Please specify another amount./).to_stdout
      end

    end

    context "exit from program" do
      it 'outputs concluding message and exit' do
        setup_fake_input('3')
        expect { subject.launch! }.to output(/Goodbye/).to_stdout
      end
    end

  end



end
