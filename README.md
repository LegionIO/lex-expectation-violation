# lex-expectation-violation

Expectation violation modeling for the LegionIO brain-modeled cognitive architecture.

## What It Does

Detects and processes mismatches between what the agent predicts and what actually happens. Computes violation magnitude, classifies violations as positive surprise, negative surprise, schema mismatch, or neutral, and selects adaptive responses: belief updating, heightened attention, or curiosity-driven exploration. The attention boost from significant violations ensures unexpected events receive more processing.

Based on predictive processing theory (Clark, Friston) and violation of expectation research.

## Usage

```ruby
client = Legion::Extensions::ExpectationViolation::Client.new

# Register an expectation before acting
client.register_expectation(
  domain: :networking,
  predicted: :success,
  confidence: 0.85
)
# => { success: true, expectation_id: "...", domain: :networking }

# Check the expectation after observing the outcome
client.check_expectation(expectation_id: '...', actual: :timeout)
# => { success: true, violation_detected: true, magnitude: 0.85,
#      violation_type: :negative_surprise, response_mode: :update_belief,
#      surprise_label: :surprising }

# Process the violation (executes the response mode)
client.process_violation(violation_id: '...')
# => { processed: true, belief_updated: true, attention_boost: 0.25, exploration_triggered: false }

# Check current attention level
client.attention_level
# => { attention: 0.7, attention_label: :alert, heightened: true }

# Expectation accuracy over a domain
client.expectation_accuracy(domain: :networking)
# => { accuracy_rate: 0.72, total_checked: 25, violations_count: 7 }

# Periodic maintenance
client.update_expectation_violation
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
