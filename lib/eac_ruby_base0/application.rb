# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRubyBase0
  class Application
    enable_simple_cache
    enable_listable
    lists.add_symbol :option, :name

    common_constructor :gemspec_dir, :options, default: [{}] do
      self.gemspec_dir = gemspec_dir.to_pathname
      self.options = options.symbolize_keys.assert_valid_keys(self.class.lists.option.values).freeze
    end

    delegate :version, to: :self_gem

    def all_gems
      vendor_gems + [self_gem]
    end

    def name
      options[OPTION_NAME] || self_gem.name
    end

    def vendor_dir
      gemspec_dir.join('vendor')
    end

    private

    def self_gem_uncached
      ::EacRubyGemsUtils::Gem.new(gemspec_dir)
    end

    def vendor_gems_uncached
      r = []
      vendor_dir.children.each do |c|
        vgem = ::EacRubyGemsUtils::Gem.new(c)
        r << vgem if vgem.gemfile_path.exist?
      end
      r
    end
  end
end
