class Unsubscribe < ApplicationRecord
  OPT_OUT_REASONS = [
    'I no longer want to recieve these emails',
    'I want to manage my email compains myself',
    'The emails are unappropriate',
    'There are too many emails',
    'other'
  ]
end
