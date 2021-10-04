#!/usr/bin/ruby
table_name = ARGV[0]
column_name = ARGV[1]

def `(command)
  puts '$ '+command
  result = Kernel.`(command)
  raise 'FAILED! $'+ command if not $?.success?
  result
end



migration_name = "remove_#{column_name}_from_#{table_name}"
camel_migration_name = migration_name.split('_').collect(&:capitalize).join
#`rm -f db/migrate/*#{migration_name}.rb`
file_name = `rails generate migration #{migration_name}`.split("\n")[1].split(" ")[1]
puts 'Migration file name: '+file_name
open(file_name, 'w') do |f|

  contents = "
    class #{camel_migration_name} < ActiveRecord::Migration[5.0]
      def change
        remove_column :#{table_name}, :#{column_name}
      end
    end
    "

  f.puts contents
end

puts 'Migration contents'
puts `cat #{file_name}`



#`rake db:migrate`
`git add #{file_name}`
`git commit -m "#{migration_name} script-generate migration"`
`staging deploy`
`staging migrate`
puts `find ./app -type f -exec grep -w -l '#{column_name}' {} \\;`


