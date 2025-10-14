# frozen_string_literal: true

require 'i18n'
require 'open3'
require 'pastel'
require 'tty-prompt'
require_relative 'repo_templater/meta'
require_relative 'repo_templater/license'

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
      @prompt = TTY::Prompt.new
      # Git data
      @author_name = git_name
      @author_username = git_username
      @author_email = git_email
      # Current year
      @year = Time.now.year
      # Initialize I18n
      I18n.load_path += Dir['config/locales/*.yml']
    end

    # Get the language of the project
    def lang
      I18n.locale = @prompt.select(I18n.t('question.locale')) do |menu|
        menu.choice name: 'English', value: :en
        menu.choice name: 'Brasileiro', value: :pt, disabled: '(em breve)'
        menu.default 'English'
      end
    end

    # Get author informations
    def author_metadata
      @author_name = @prompt.ask(I18n.t('question.author.name')) do |q|
        q.required true
        q.modify   :strip
        q.default  @author_name unless @author_name.empty?
      end
      @author_username = @prompt.ask(I18n.t('question.author.username')) do |q|
        q.required true
        q.modify   :strip
        q.default  @author_username unless @author_username.empty?
      end
      @author_email = @prompt.ask(I18n.t('question.author.email')) do |q|
        q.required true
        q.validate :email, I18n.t('error.invalid.email')
        q.default  @author_email unless @author_email.empty?
      end
      @author_uri = @prompt.ask(I18n.t('question.author.uri')) do |q|
        q.required true
        q.default  I18n.t('help.author_uri')
      end
    end

    # Get repository informations
    def repo_metadata
      @name = @prompt.ask(I18n.t('question.repo.name')) do |q|
        q.required true
        q.modify   :strip
      end
      @slug = @prompt.ask(I18n.t('question.repo.slug')) do |q|
        q.required true
        q.modify   :strip
        q.default  slugify(@name)
      end
      @long_desc = @prompt.multiline(I18n.t('question.repo.description.long')) do |q|
        q.required true
        q.help     I18n.t('help.repo_description')
      end
      @short_desc = @prompt.ask(I18n.t('question.repo.description.short')) do |q|
        q.required true
        q.modify   :strip
        q.default  @long_desc.first.strip
      end
      @version = @prompt.ask(I18n.t('question.repo.version')) do |q|
        q.required true
        q.default  '0.1.0'
        q.validate(/^\d+\.\d+\.\d+(-[0-9A-Za-z\-.]+)?(\+[0-9A-Za-z\-.]+)?/, I18n.t('error.invalid.version'))
      end
    end

    # Run the main functionality
    def run
      # Gets:
      lang # Language
      author_metadata # Author metadata
      repo_metadata # Repository metadata
      # Sets:
      RepoTemplater::License.new I18n, @author_name, @year # License
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

    # Retrieve Github username from git config
    def git_username
      stdout, status = Open3.capture2('git config github.user')
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

    # Slugify a string
    def slugify(string)
      string = I18n.transliterate(string)
      string.gsub(/^-|-$/i, '')
            .gsub(/[^[A-Za-z0-9]]+/, '_')
            .downcase
    end
  end
end
