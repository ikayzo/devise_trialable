module Devise
  module Models

    # Trialable is responsible to verify if an account is already enrolled to
    # sign in.
    #
    # == Options
    #
    # Trialable adds the following options to devise_for:
    #
    #   * +trial_period+: the time you want to allow the user to access his account
    #     before enrolling. After this period, the user access is denied. You can
    #     use this to let your user access some features of your application without
    #     enrolling, but blocking it after a certain period (ie 7 days).
    #     By default trial_period is 60 days, meaning that users can use your site
    #     without providing sign-up (billing) information for 60 days
    #
    # == Examples
    #
    #   User.find(1).enroll!      # returns true unless it's already enrolled
    #   User.find(1).enrolled?    # true/false
    #
    module Trialable
      extend ActiveSupport::Concern

      def self.required_fields(klass)
        required_methods = [:enrolled_at]
        required_methods
      end

      # Enroll a user by setting it's enrolled_at to actual time. If the user
      # is already enrolled, add an error to email field. If the user is invalid
      # add errors
      def enroll!
        pending_any_enrollment do
          self.update_attribute(:enrolled_at, Time.now.utc)
        end
      end

      # Verifies whether a user is confirmed or not
      def enrolled?
        !!enrolled_at
      end

      # Overwrites active_for_authentication? for trial period
      # by verifying whether a user is active to sign in or not. If the user
      # is already enrolled, it should never be blocked. Otherwise we need to
      # calculate if the trial period time has not expired for this user.
      def active_for_authentication?
        super && (!enrollment_required? || enrolled? || trial_period_valid?)
      end

      # The message to be shown if the account is inactive.
      def inactive_message
        !enrolled? && !trial_period_valid? ? :unenrolled : super
      end

      def trial_days_left
        (self.class.trial_period.to_i - (DateTime.now.utc.to_time - self.created_at.utc.to_time).to_i)/1.day
      end

      def trial_days_left_words
        I18n.t('trial.days_left') % [self.trial_days_left, Rails.application.class.parent_name]
      end
      protected

        # Callback to overwrite if confirmation is required or not.
        def enrollment_required?
          !enrolled?
        end

        # Checks if the confirmation for the user is within the limit time.
        # We do this by calculating if the difference between today and the
        # confirmation sent date does not exceed the confirm in time configured.
        # Confirm_within is a model configuration, must always be an integer value.
        #
        # Example:
        #
        #   # trial_period = 1.day and created_at = today
        #   trial_period_valid?   # returns true
        #
        #   # trial_period = 5.days and created_at = 4.days.ago
        #   trial_period_valid?   # returns true
        #
        #   # trial_period = 5.days and created_at = 5.days.ago
        #   trial_period_valid?   # returns false
        #
        #   # trial_period = 0.days
        #   trial_period_valid?   # will always return false
        #
        def trial_period_valid?
          self.created_at >= self.class.trial_period.ago
        end

        # Checks whether the record requires any confirmation.
        #noinspection RubyControlFlowConversionInspection
      def pending_any_enrollment
          if !enrolled?
            yield
          else
            self.errors.add(:email, :already_enrolled)
            false
          end
        end

      module ClassMethods
        Devise::Models.config(self, :trial_period)
      end
    end
  end
end
