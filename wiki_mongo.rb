require 'rubygems'
require 'sinatra'
require 'active_record'

use_in_file_templates!

configure do
  ActiveRecord::Base.establish_connection(
    :adapter   => 'sqlite3',
    :database    => 'sinatriki.sqlite3'
  )
  
  # create the db if not found
  unless File.exist?("sinatriki.sqlite3")
    ActiveRecord::Schema.define do
      create_table :pages do |t|
        t.string :name
        t.text :body
        t.string :ip
        t.timestamps
      end
    end
  end
end

class Page < ActiveRecord::Base
end

get "/" do
  "Hello Sinatra"
end


get '/:page' do
  
  @page = Page.find_or_create_by_name(params[:page])
  erb :show
  
end

get '/:page/edit' do
  
  @page = Page.find_or_create_by_name(params[:page])
  erb :edit
  
  
end

post '/:page' do
  @page = Page.find_by_name(params[:page])
  @page.body = params[:body]
  @page.ip = @env['REMOTE_ADDR']
  @page.save
  redirect "/#{@page.name}"
end

  
__END__

@@ show
<h2><%= @page.name %></h2>

<%= @page.body unless @page.body.nil? %>

<hr />
<p>Last updated <%= @page.updated_at %></p>

<p>
  <a href="/<%=@page.name %>/edit">Edit this page</a>
</p>

@@ edit
<h2>Editing "<%=@page.name %>"</h2>

<form action='/<%= @page.name %>' method='POST'>
  <label for='body'>Body</label>
  <br />
  <textarea rows="6" cols="40" id='body' name='body'></textarea>
  <hr />
  <input type='submit' value='Save' />
</form>

@@ layout
<html>
  <head>
    <title>Wiki</title>
    <link rel="stylesheet" href="/stylesheets/style.css" type="text/css" charset="utf-8">
  </head>
  <body>
    <h1>Our Wiki</h1>
    <%= yield %>
    <hr />
    <p>Your IP address is <%= @env['REMOTE_ADDR'] %></p>
  </body>
</html>

