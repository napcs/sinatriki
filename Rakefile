namespace :mongo do
  desc "Start the Mongodb service and use the db folder as the source"
  task :start do
    `mkdir db` unless File.exist?("db")
    `mongod --dbpath db/`
  end
end

namespace :app do
  desc "Start the application"
  task :start do
    `shotgun app.rb`
  end
end

multitask :start => [ 'mongo:start', 'app:start' ]
