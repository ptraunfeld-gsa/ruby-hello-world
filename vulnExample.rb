require 'bundler'
Bundler.require

require 'sinatra'
require 'sqlite3'

# Setting up the database
DB = SQLite3::Database.new "test.db"
DB.execute "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username TEXT, password TEXT);"

get '/' do
  erb :index
end

# Vulnerable to SQL Injection
post '/login' do
  username = params[:username]
  password = params[:password]
  query = "SELECT * FROM users WHERE username = '#{username}' AND password = '#{password}'"
  @user = DB.execute(query).first
  if @user
    "Welcome, #{username}!"
  else
    "Login failed."
  end
end

# Vulnerable to Command Injection
post '/echo' do
  input = params[:input]
  `echo #{input}`
end

__END__

@@index
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Login</title>
</head>
<body>
  <form action="/login" method="post">
    Username: <input type="text" name="username"><br>
    Password: <input type="password" name="password"><br>
    <input type="submit" value="Login">
  </form>
  <form action="/echo" method="post">
    Input: <input type="text" name="input"><br>
    <input type="submit" value="Echo">
  </form>
</body>
</html>
