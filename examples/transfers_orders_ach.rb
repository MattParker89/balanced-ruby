cwd = File.dirname(File.dirname(File.absolute_path(__FILE__)))
$:.unshift(cwd + "/lib")
require 'balanced'

host = ENV.fetch('BALANCED_HOST') { nil }
options = {}
if host
  options[:scheme] = 'http'
  options[:host] = host
  options[:port] = 5000
end

Balanced.configure(nil, options)

# create a new marketplace
api_key = Balanced::ApiKey.new.save
Balanced.configure(api_key.secret)
marketplace = Balanced::Marketplace.new.save

# create a customer
customer = Balanced::Customer.new(
  :name      => 'Henry Ford',
  :dob_month => 7,
  :dob_year  => 1963,
  :address => {
    :postal_code => '48120'
  }
).save

# create a bank account
bank_account = Balanced::BankAccount.new(
  :name => 'Henry Ford',
  :routing_number => '021000021',
  :account_number => '9900000002',
  :type => 'checking'
)

# associate the bank account to the customer
bank_account.associate_to_customer(customer)

# create a buyer
buyer = Balanced::Customer.new(
  :name => 'John Buyer'
).save

# create a bank account
buyer_bank_account = Balanced::BankAccount.new(
  :name => 'John Buyer',
  :routing_number => '321174851',
  :account_number => '9900000003',
  :type => 'checking'
).save

# associate the bank account to the customer
buyer_bank_account.associate_to_customer(buyer)

# verify the buyer's bank account
bv = buyer_bank_account.verify # micro deposits are sent to bank account

# time elapses in the real world so fetch the verification when ready to verify
verification = Balanced::BankAccountVerification.fetch(bv.href)

# buyer enters deposit amounts as shown on bank statement. in test marketplaces these amounts are 1
verification.confirm(
  amount_1 = 1,
  amount_2 = 1
)

puts "Customer : #{customer.href}"
puts "Customer bank account : #{bank_account.href}"
puts "Buyer : #{buyer.href}"
puts "Buyer bank account : #{buyer_bank_account.href}"

# get the customer's deposit account
account = customer.deposit_account

puts "Account : #{account.href}"

amount = 1240

# create an order
order = customer.create_order(
  :description => 'Example order',
  :meta => {
    'item_url' => 'https://neatitems.com/12342134123'
  }
)

puts "Order : #{order.href}"

# debit the buyer's card into the order
debit = order.debit_from(
  :source => buyer_bank_account,
  :amount => amount
)

puts "Buyer bank account debit : #{debit.href}"

order.reload

# check the order balance
order_in_escrow = order.amount_escrowed
raise "Order should have #{amount} in escrow" if order_in_escrow != amount
puts "In order escrow : #{order_in_escrow}"

account.reload

puts "Account balance : #{account.balance}"

# move funds to the account where it accrues a balance
credit = order.credit_to(:destination => account, :amount => amount)

puts "Credit to account : #{credit.href}"

order.reload

# check the order balance
order_in_escrow = order.amount_escrowed
raise "Order should have 0 in escrow" if order_in_escrow != 0
puts "In order escrow : #{order_in_escrow}"

account.reload

puts "Account balance : #{account.balance}"

# Withdraw from Balanced to a bank account
withdrawal = account.transfer_to(
  :destination => bank_account,
  :amount => amount
)

raise "Withdrawal amount should be #{amount} but was #{withdrawal.amount}" if withdrawal.amount != amount

puts "Transfer to bank account : #{withdrawal.href}"

account.reload
raise "Account balanced should be #{amount} but was #{account.balanced}" if account.balance != 0
puts "Account balance : #{account.balance}"