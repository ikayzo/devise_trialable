require 'devise'

module Devise
  # Public: length of trial period
  #
  #   config.trial_period = 2.weeks # => Will not allow access after 2 weeks unless user is enrolled
  mattr_accessor :trial_period
  @@trial_period = 60.days

end

Devise.add_module :trialable, :model => 'devise_trialable/trialable'


