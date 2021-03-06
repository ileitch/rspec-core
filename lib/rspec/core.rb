require 'rspec/core/filter_manager'
require 'rspec/core/dsl'
require 'rspec/core/extensions'
require 'rspec/core/load_path'
require 'rspec/core/deprecation'
require 'rspec/core/backward_compatibility'
require 'rspec/core/reporter'

require 'rspec/core/metadata_hash_builder'
require 'rspec/core/hooks'
require 'rspec/core/subject'
require 'rspec/core/let'
require 'rspec/core/metadata'
require 'rspec/core/pending'

require 'rspec/core/world'
require 'rspec/core/configuration'
require 'rspec/core/project_initializer'
require 'rspec/core/option_parser'
require 'rspec/core/drb_options'
require 'rspec/core/configuration_options'
require 'rspec/core/command_line'
require 'rspec/core/drb_command_line'
require 'rspec/core/runner'
require 'rspec/core/example'
require 'rspec/core/shared_example_group'
require 'rspec/core/example_group'
require 'rspec/core/version'
require 'rspec/core/errors'

module RSpec
  autoload :Matchers,      'rspec/matchers'
  autoload :SharedContext, 'rspec/core/shared_context'

  # @api private
  # Used internally to determine what to do when a SIGINT is received
  def self.wants_to_quit
    world.wants_to_quit
  end

  # @api private
  # Used internally to determine what to do when a SIGINT is received
  def self.wants_to_quit=(maybe)
    world.wants_to_quit=(maybe)
  end

  # @api private
  # Internal container for global non-configuration data
  def self.world
    @world ||= RSpec::Core::World.new
  end

  # @api private
  # Used internally to ensure examples get reloaded between multiple runs in
  # the same process.
  def self.reset
    world.reset
    configuration.reset
  end

  # Returns the global [Configuration](Core/Configuration) object. While you
  # _can_ use this method to access the configuration, the more common
  # convention is to use [RSpec.configure](RSpec#configure-class_method).
  #
  # @example
  #     RSpec.configuration.drb_port = 1234
  # @see RSpec.configure
  # @see Core::Configuration
  def self.configuration
    @configuration ||= RSpec::Core::Configuration.new
  end

  # @yield [Configuration] global configuration
  #
  # @example
  #     RSpec.configure do |config|
  #       config.add_formatter 'documentation'
  #     end
  # @see Core::Configuration
  def self.configure
    yield configuration if block_given?
  end

  # @api private
  # Used internally to clear remaining groups when fail_fast is set
  def self.clear_remaining_example_groups
    world.example_groups.clear
  end

  module Core
  end
end

require 'rspec/core/backward_compatibility'
require 'rspec/monkey'
