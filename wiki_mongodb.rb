require 'rubygems'
require 'sinatra'
require 'mongomapper'
require 'redcloth'

use_in_file_templates!

class Page
  include MongoMapper::Document
  database 'wiki'
  
  key :name, String
  key :body, String
  key :ip, String
  timestamps!
  
end

class String 
  def textilize 
    RedCloth.new(self).to_html 
  end 
end

get "/stylesheets/style.css" do
 sass :style
end

get "/" do
 redirect "/Home"
end

get "/:page" do
  @page = Page.find_by_name(params[:page]) || Page.create(:name => params[:page])
  erb :show
end

get "/:page/edit" do
  @page = Page.find_by_name(params[:page]) || Page.create(:name => params[:page])
 erb :edit
end

post "/:page" do
  @page = Page.find_by_name(params[:page]) || Page.create(:name => params[:page])
  @page.body = params[:body]
  @page.ip = @env["REMOTE_ADDRESS"]
  @page.save
  redirect "/" + @page.name
end


__END__

@@ show
<h2><%= @page.name %></h2>

<%= @page.body.textilize unless @page.body.nil? %>

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
  <textarea rows="6" cols="40" id='body' name='body'><%=@page.body %></textarea>
  <hr />
  <input type='submit' value='Save' />
</form>

@@ style
!measure = 18px

body 
  background: 
    color: #fff 

  font: 
    size = !measure - 4 
    family: Arial, Helvetica, sans-serif 

  line-height = !measure 

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





