# frozen_string_literal: true

module Callable
  extend ActiveSupport::Concern

  attr_reader :errors

  class_methods do
    def call(*args)
      new(*args).tap { |instance| instance.call }
    end
  end
end
