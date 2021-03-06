module RSpec
  module Core
    module Pending
      class PendingDeclaredInExample < StandardError; end

      DEFAULT_MESSAGE = 'No reason given'

      # @overload pending()
      # @overload pending(message)
      # @overload pending(message, &block)
      #
      # Stops execution of an example, and reports it as pending. Takes an
      # optional message and block.
      #
      # @param [String] message optional message to add to the summary report.
      # @param [Block] block optional block. If it fails, the example is
      #   reported as pending. If it executes cleanly the example fails.
      #
      # @example
      #
      #     describe "an example" do
      #       # reported as "Pending: no reason given"
      #       it "is pending with no message" do
      #         pending
      #         this_does_not_get_executed
      #       end
      #
      #       # reported as "Pending: something else getting finished"
      #       it "is pending with a custom message" do
      #         pending("something else getting finished")
      #         this_does_not_get_executed
      #       end
      #
      #       # reported as "Pending: something else getting finished"
      #       it "is pending with a failing block" do
      #         pending("something else getting finished") do
      #           raise "this is the failure"
      #         end
      #       end
      #
      #       # reported as failure, saying we expected the block to fail but
      #       # it passed.
      #       it "is pending with a passing block" do
      #         pending("something else getting finished") do
      #           true.should be(true)
      #         end
      #       end
      #     end
      def pending(*args)
        return self.class.before(:each) { pending(*args) } unless example

        options = args.last.is_a?(Hash) ? args.pop : {}
        message = args.first || DEFAULT_MESSAGE

        if options[:unless] || (options.has_key?(:if) && !options[:if])
          return block_given? ? yield : nil
        end

        example.metadata[:pending] = true
        example.metadata[:execution_result][:pending_message] = message
        if block_given?
          begin
            result = begin
                       yield
                       example.example_group_instance.instance_eval { verify_mocks_for_rspec }
                     end
            example.metadata[:pending] = false
          rescue Exception => e
            example.execution_result[:exception] = e
          ensure
            teardown_mocks_for_rspec
          end
          raise RSpec::Core::PendingExampleFixedError.new if result
        end
        raise PendingDeclaredInExample.new(message)
      end
    end
  end
end
