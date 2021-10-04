namespace :deploy do
  desc 'Bundle install'
    task :bundle do
      on primary :app do
        within release_path do
          execute :bundle, 'install'
        end
      end
    end
  end
