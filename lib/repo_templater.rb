# frozen_string_literal: true

require 'pastel'
require_relative 'repo_templater/meta'

module RepoTemplater
  class Actions
    def self.info
      pastel = Pastel.new
      puts "#{pastel.cyan(RepoTemplater::NAME)} by #{pastel.blue(RepoTemplater::AUTHOR)}"
      puts "(c) #{RepoTemplater::YEAR}"
      puts "Version #{pastel.bright_blue(RepoTemplater::VERSION)}"
      puts "Available under the #{pastel.green(RepoTemplater::LICENSE)}."
    end

    def self.run
      # TODO: implement main functionality
    end
  end
end
