module DeviseTrialable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc "Add DeviseTrialable config variables to the Devise initializer and copy DeviseTrialable locale files to your application."

      # def devise_install
      #   invoke "devise:install"
      # end

      def add_config_options_to_initializer
        devise_initializer_path = "config/initializers/devise.rb"
        if File.exist?(devise_initializer_path)
          old_content = File.read(devise_initializer_path)

          if old_content.match(Regexp.new(/^\s# ==> Configuration for :trialable\n/))
            false
          else
            inject_into_file(devise_initializer_path, :before => "  # ==> Configuration for :confirmable\n") do
<<-CONTENT
  # ==> Configuration for :trialable
  # The period a user can access the site without enrolling
  # config.trial_period = 60.days

CONTENT
            end
          end
        end
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/devise_trialable.en.yml"
      end

    end
  end
end
