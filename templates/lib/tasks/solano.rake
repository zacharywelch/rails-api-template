namespace :solano do
  desc "Link config files to samples"
  task :link_config_files do
    system("cd config && ln -s database.yml.sample database.yml")
    system("cd config && ln -s secrets.yml.sample secrets.yml")
  end

  desc 'Run post-build script'
  task :post_build_hook do
    puts 'Run post-build script'

    if solano? && build_passed?
      case current_branch
      when 'master'
        #puts 'Build passed, deploying master to production...'
        #%x[bundle exec cap production deploy]
        puts 'No deploy triggered'
      when 'develop'
        puts 'Build passed, deploying develop to staging...'
        %x[bundle exec cap staging deploy]
      else
        puts 'No deploy triggered'
      end
    else
      puts 'No deploy triggered'
    end
  end

  private

  def solano?
    ENV.member?('TDDIUM')
  end

  def build_passed?
    ENV['TDDIUM_BUILD_STATUS'] == 'passed'
  end

  def current_branch
    `git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-`.strip
  end
end
