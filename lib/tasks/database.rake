# encoding: utf-8
require 'active_record/fixtures'
namespace :hydra do
  
  namespace :db do 
    
    desc "Loading db/sample for hydra"
    task :sample => :environment do   
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      Dir.glob(File.join(RAILS_ROOT, "db", 'sample', '*.{yml,csv}')).each do |fixture_file|
        Fixtures.create_fixtures("#{RAILS_ROOT}/db/sample",
                                 File.basename(fixture_file, '.*'))
      end      
      puts "Sample data has been loaded"
    end
    
    desc "Loading db/default for hydra"
    task :default => :environment do   
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      Dir.glob(File.join(RAILS_ROOT, "db", 'default', '*.{yml,csv}')).each do |fixture_file|
        Fixtures.create_fixtures("#{RAILS_ROOT}/db/default",
                                 File.basename(fixture_file, '.*'))
      end      
      puts "Default data has been loaded"
    end
    
  end
  
end
