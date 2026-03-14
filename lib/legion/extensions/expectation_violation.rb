# frozen_string_literal: true

require_relative 'expectation_violation/version'
require_relative 'expectation_violation/helpers/constants'
require_relative 'expectation_violation/helpers/expectation'
require_relative 'expectation_violation/helpers/violation_engine'
require_relative 'expectation_violation/runners/expectation_violation'
require_relative 'expectation_violation/helpers/client'

module Legion
  module Extensions
    module ExpectationViolation
      extend Legion::Extensions::Core if Legion::Extensions.const_defined?(:Core)
    end
  end
end
