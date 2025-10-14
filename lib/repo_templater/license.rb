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
      ['GNU GPL v3+', 'GPL-3.0-or-later', true, true, true, false, 'a32d3f', 'https://www.gnu.org/licenses/gpl-3.0.en.html'],
      ['Mozilla Public License 2.0', 'MPL-2.0', true, true, true, false, '00d230', 'https://www.mozilla.org/en-US/MPL/2.0/'],
      ['MIT License', 'MIT', true, true, false, false, 'aa0000', 'https://opensource.org/license/mit'],
      ['The Unlicense', 'Unlicense', true, true, false, false, '3e63dd', 'https://unlicense.org/'],
      ['WTF Public License', 'WTFPL', true, true, false, false, 'f77f00', 'https://www.wtfpl.net/'],
      ['Hippocratic License v3', 'HL3-CORE', false, false, true, false, 'bc8c3d', 'https://firstdonoharm.dev/version/3/0/core.html'],
      ['Hippocratic License Full v3', 'HL3-FULL', false, false, true, false, 'bc8c3d', 'https://firstdonoharm.dev/version/3/0/full.html'],
      ['Creative Commons BY-NC-SA 4.0 International', 'CC-BY-NC-SA-4.0', false, false, true, true, 'd3d3d3', 'https://creativecommons.org/licenses/by-nc-sa/4.0/'],
      ['Creative Commons CC0 1.0 Universal', 'CC0-1.0', true, false, false, true, 'd3d3d3', 'https://creativecommons.org/publicdomain/zero/1.0/']
    ].freeze

    attr_accessor :license, :spdx, :uri

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
      @headers = [
        @i18n.t('license_table.header.name'),
        @i18n.t('license_table.header.spdx'),
        @i18n.t('license_table.header.free'),
        @i18n.t('license_table.header.commercial'),
        @i18n.t('license_table.header.share_alike'),
        @i18n.t('license_table.header.non_code')
      ]
      # Begin license selection
      puts licenses_table
      select
    end

    private

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
        ren.alignments   = [:center] * @headers.size
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
            value ? @pastel.green("\u2713") : @pastel.red("\u2717")
          else
            value
          end
        end
      end
    end

    def select
      nil
    end
  end
end
