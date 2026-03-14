# frozen_string_literal: true

require_relative 'lib/legion/extensions/expectation_violation/version'

Gem::Specification.new do |spec|
  spec.name    = 'lex-expectation-violation'
  spec.version = Legion::Extensions::ExpectationViolation::VERSION
  spec.authors = ['Esity']
  spec.email   = ['matthewdiverson@gmail.com']

  spec.summary     = 'Expectancy violation theory for LegionIO'
  spec.description = 'Models expectations with tolerance bands and detects violations. ' \
                     'Positive violations strengthen trust, negative violations damage it. ' \
                     'Based on Burgoon (1978) Expectancy Violations Theory.'
  spec.homepage    = 'https://github.com/LegionIO/lex-expectation-violation'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/LegionIO/lex-expectation-violation'
  spec.metadata['documentation_uri'] = 'https://github.com/LegionIO/lex-expectation-violation'
  spec.metadata['changelog_uri']     = 'https://github.com/LegionIO/lex-expectation-violation/blob/master/CHANGELOG.md'
  spec.metadata['bug_tracker_uri']   = 'https://github.com/LegionIO/lex-expectation-violation/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*', 'LICENSE', 'README.md']
  spec.require_paths = ['lib']
end
