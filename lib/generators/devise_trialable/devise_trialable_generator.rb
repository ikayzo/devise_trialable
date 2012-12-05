module DeviseTrialable
  module Generators
    class DeviseTrialableGenerator < Rails::Generators::NamedBase
      namespace "devise_trialable"

      desc "Add :trialable directive in the given model. Also generate migration for ActiveRecord"

      # def devise_generate_model
      #   invoke "devise", [name]
      # end

      def inject_devise_trialable_content
        path = File.join("app", "models", "#{file_path}.rb")
        inject_into_file(path, "trialable, :", :after => "devise :") if File.exists?(path)
      end

      hook_for :orm
    end
  end
end