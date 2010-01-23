require 'rubygems'
require 'sqlite3'
require 'activerecord'
#require 'parsePac.rb'
#require 'rbAlpm.rb'
#require 'alpmFunc.rb'
require 'yaml' 
require "pp"

MY_DB_NAME="my.db"
#MY_DB = SQLite3::Database.new(MY_DB_NAME) 


ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => MY_DB_NAME
)



#ActiveRecord::Base.connection.create_table(:packages) do |table|
#    table.column :name, :string
#    table.column :desc, :text
#    table.column :repo, :string
#    table.column :version, :string
#    table.column :size, :long
#end

class Package < ActiveRecord::Base
    
end

pp Package.find_all_by_name("pacman")
    
#@g = Alpm_use::Alpm_method.new;
#@g.initAlpm;
#@g.getSyncPkgs do |pkgInfo|
 # pkg = Package.create(:desc => pkgInfo[:desc],:name => pkgInfo[:name],:version => pkgInfo[:version],:size => pkgInfo[:size],:repo => pkgInfo[:repo]) 
#end
#@g.close