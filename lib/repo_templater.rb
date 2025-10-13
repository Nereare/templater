# frozen_string_literal: true

require 'i18n'
require 'open3'
require 'pastel'
require 'tty-prompt'
require_relative 'repo_templater/meta'

# Main module
module RepoTemplater
  # Actions for the CLI
  class Actions
    # Display info about the gem
    def self.info
      pastel = Pastel.new
      puts "#{pastel.cyan(RepoTemplater::NAME)} by #{pastel.blue(RepoTemplater::AUTHOR)}"
      puts "(c) #{RepoTemplater::YEAR}"
      puts "Version #{pastel.bright_blue(RepoTemplater::VERSION)}"
      puts "Available under the #{pastel.green(RepoTemplater::LICENSE)}."
    end

    # Initialize the class
    def initialize
      # Gem elements
      @pastel = Pastel.new
      @prompt = TTY::Prompt.new
      # Git data
      @author_name = git_name
      @author_email = git_email
      # Initialize I18n
      I18n.load_path += Dir["#{File.expand_path('config/locales')}/*.yml"]
    end

    # Get the language of the project
    def lang
      I18n.locale = @prompt.select(I18n.t(:locale_question)) do |menu|
        menu.choice name: 'English', value: :en
        menu.choice name: 'Brasileiro', value: :pt
        menu.default :en
      end
    end

    # Get author metadata from the repository's author
    def author_metadata
      @author_name = @prompt.ask(I18n.t('question.author.name')) do |q|
        q.required true
        q.modify   :strip
        q.default  @author_name unless @author_name.empty?
      end
      @author_email = @prompt.ask(I18n.t(:question_author_email)) do |q|
        q.required true
        q.validate :email, I18n.t(:error_invalid_email)
        q.default  @author_email unless @author_email.empty?
      end
    end

    # Get repository informations
    def self.repo_metadata
      @name = @prompt.ask(I18n.t(:question_repo_name)) do |q|
        q.required true
        q.modify   :strip
      end
      @slug = @prompt.ask(I18n.t(:question_repo_slug)) do |q|
        q.required true
        q.modify   :strip
      end
    end

    # Run the main functionality
    def run
      lang # Get language
      author_metadata # Get author metadata
      repo_metadata # Get repository metadata
    end

    private

    # Retrieve name from git config
    def git_name
      stdout, status = Open3.capture2('git config user.name')
      if status.success? && !stdout.strip.empty?
        stdout.strip
      else
        ''
      end
    end

    # Retrieve email from git config
    def git_email
      stdout, status = Open3.capture2('git config user.email')
      if status.success? && !stdout.strip.empty?
        stdout.strip
      else
        ''
      end
    end
  end
end
