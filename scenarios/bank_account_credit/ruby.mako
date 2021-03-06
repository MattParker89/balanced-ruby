% if mode == 'definition':
Balanced::BankAccount.credit

% elif mode == 'request':
require 'balanced'
Balanced.configure('ak-test-22IOkhevjZlmRP2do6CZixkkDshTiOjTV')

bank_account = Balanced::BankAccount.fetch('/bank_accounts/BA3Y63fK5STwlhKNMkE3Utmd')
bank_account.credit(:amount => 5000)
% elif mode == 'response':
#<Balanced::Credit:0x007fa93ebb71c0
 @attributes=
  {"amount"=>5000,
   "appears_on_statement_as"=>"example.com",
   "created_at"=>"2014-04-25T20:18:52.480929Z",
   "currency"=>"USD",
   "description"=>nil,
   "failure_reason"=>nil,
   "failure_reason_code"=>nil,
   "href"=>"/credits/CR6nBcaGvGc4dtflEB1bjKBP",
   "id"=>"CR6nBcaGvGc4dtflEB1bjKBP",
   "links"=>
    {"customer"=>"CU3VYCUIfwngJsidJWdGw2W5",
     "destination"=>"BA3Y63fK5STwlhKNMkE3Utmd",
     "order"=>nil},
   "meta"=>{},
   "status"=>"succeeded",
   "transaction_number"=>"CR666-481-5204",
   "updated_at"=>"2014-04-25T20:18:54.380146Z"},
 @hyperlinks=
  {"customer"=>
    #<Proc:0x007fa93ebb5690/lib/balanced/resources/resource.rb:60 (lambda)>,
   "destination"=>
    #<Proc:0x007fa93ebbfcf8/lib/balanced/resources/resource.rb:60 (lambda)>,
   "events"=>
    #<Proc:0x007fa93ebbde80/lib/balanced/utils.rb:6 (lambda)>,
   "order"=>
    #<Proc:0x007fa93ebbd4a8/lib/balanced/utils.rb:6 (lambda)>,
   "reversals"=>
    #<Proc:0x007fa93ebc7610/lib/balanced/utils.rb:6 (lambda)>}>

% endif
