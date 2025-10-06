# frozen_string_literal: true

require 'pastel'
require_relative "templater/meta"

module Templater
  class Actions
    def self.version
      # pastel = Pastel.new
      # puts "#{pastel.cyan(Templater::NAME.capitalize)} v.#{pastel.blue(Templater::VERSION)}"
      puts "Foo bar"
    end
  end
end
