# frozen_string_literal: true

require 'i18n'
require 'pastel'
require 'tty-prompt'
require 'tty-table'

module RepoTemplater
  # License selection and creation
  class License
    # List of available licenses and their properties
    LICENSES = [
      ['GNU General Public License v3+', 'GPL-3.0-or-later', 1, 1, 1, 0, 'a32d3f', 'https://www.gnu.org/licenses/gpl-3.0.en.html'],
      ['Mozilla Public License 2.0', 'MPL-2.0', 1, 1, 1, 0, '00d230', 'https://www.mozilla.org/en-US/MPL/2.0/'],
      ['MIT License', 'MIT', 1, 1, 0, 0, 'aa0000', 'https://opensource.org/license/mit'],
      ['The Unlicense', 'Unlicense', 1, 1, 0, 0, '3e63dd', 'https://unlicense.org/'],
      ['WTF Public License', 'WTFPL', 1, 1, 0, 0, 'f77f00', 'https://www.wtfpl.net/'],
      ['Hippocratic License v3', 'HL3-CORE', 0, 0, 1, 0, 'bc8c3d', 'https://firstdonoharm.dev/version/3/0/core.html'],
      ['Hippocratic License Full v3', 'HL3-FULL', 0, 0, 1, 0, 'bc8c3d', 'https://firstdonoharm.dev/version/3/0/full.html'],
      ['Creative Commons BY-NC-SA 4.0 International', 'CC-BY-NC-SA-4.0', 0, 0, 1, 1, 'd3d3d3', 'https://creativecommons.org/licenses/by-nc-sa/4.0/'],
      ['Creative Commons CC0 1.0 Universal', 'CC0-1.0', 1, 0, 0, 1, 'd3d3d3', 'https://creativecommons.org/publicdomain/zero/1.0/']
    ].freeze

    attr_accessor :license, :spdx, :color, :uri, :text

    # Select the license and save it to a file
    def initialize(i18n, author_name, year)
      # Initialize components
      @pastel = Pastel.new
      @prompt = TTY::Prompt.new
      # Fetch given data
      @i18n = i18n
      @author_name = author_name
      @year = year
      # Nullify unset values
      @license = nil
      @spdx = nil
      @uri = nil
      @headers = build_headers
      # License selection
      license_known?
      @license, @spdx, @color, @uri = select
      @text = build_text
    end

    private

    # Build the headers for the license table
    def build_headers
      [
        @i18n.t('license.table.header.name'),
        @i18n.t('license.table.header.spdx'),
        @i18n.t('license.table.header.free'),
        @i18n.t('license.table.header.commercial'),
        @i18n.t('license.table.header.share_alike'),
        @i18n.t('license.table.header.non_code')
      ]
    end

    # Create the license table
    def licenses_table
      TTY::Table.new(
        header: @headers,
        rows: LICENSES.map do |elem|
          elem.pop(2)
          elem
        end
      ).render(:unicode) do |ren|
        ren.resize       = true
        ren.multiline    = true
        ren.border.style = :blue
        ren.filter       = lambda do |value, row, col|
          if row.zero?
            @pastel.bold.on_blue value
          elsif col.even?
            @pastel.on_bright_black value
          else
            value
          end
        end
        ren.filter = lambda do |value, row, col|
          if row.positive? && (2..5).include?(col)
            value.to_i.positive? ? @pastel.green("\u2713") : @pastel.red("\u2717")
          else
            value
          end
        end
      end
    end

    def license_known?
      if @prompt.yes?(@i18n.t('question.license.known')) do |q|
        q.positive %w[y yes]
        q.negative %w[n no]
      end
        puts @i18n.t('license.table.instruction')
        puts licenses_table
      end
    end

    # License selection prompt
    def select
      license_map = LICENSES.map.with_index do |elem, index|
        { name: "#{elem[0]} (#{elem[1]})", value: index }
      end
      index = @prompt.select('question.license.which') do |menu|
        menu.cycle   true
        menu.filter  true
        menu.choices license_map
      end
      yield LICENSES[index][0], LICENSES[index][1], LICENSES[index][6], LICENSES[index][7]
    end

    def build_text
      nil
    end
  end
end
