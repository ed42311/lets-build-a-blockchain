require 'sinatra'
require 'colorize'

BALANCES = {
  'edward' => 1_000_000,
}

def print_state
  puts BALANCES.to_s.green
end

# @param user
get "/balance" do
  user = params['user'].downcase
  print_state
  "#{user} has #{BALANCES[user]}"
end

# @param name
post "/users" do
  name = params['name'].downcase
  BALANCES[name] ||= 0
  print_state
  "OK"
end

# @param from
# @param to
# @param amount
post "/transfers" do
  from, to = params.values_at('from', 'to').map(&:downcase)
  amount = params['amount'].to_i
  raise InsufficientFunds if BALANCES[from] < amount
  BALANCES[from] -= amount
  BALANCES[to] += amount
  print_state
  "OK"
end

class InsufficientFunds < StandardError; end
