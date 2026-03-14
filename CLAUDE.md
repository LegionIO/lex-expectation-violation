# lex-expectation-violation

**Level 3 Documentation** — Parent: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`

## Purpose

Expectation violation modeling for the LegionIO cognitive architecture. Detects and processes mismatches between what the agent expects to happen and what actually occurs. Computes violation magnitude, tags violations by type (positive or negative surprise), and triggers adaptive responses: heightened attention, belief updating, and curiosity-driven exploration. Feeds the prediction error signal used by lex-prediction's learning mechanism.

Based on predictive processing theory (Clark, Friston) and violation of expectation research.

## Gem Info

- **Gem name**: `lex-expectation-violation`
- **Version**: `0.1.0`
- **Namespace**: `Legion::Extensions::ExpectationViolation`
- **Location**: `extensions-agentic/lex-expectation-violation/`

## File Structure

```
lib/legion/extensions/expectation_violation/
  expectation_violation.rb      # Top-level requires
  version.rb                    # VERSION = '0.1.0'
  client.rb                     # Client class
  helpers/
    constants.rb                # VIOLATION_TYPES, RESPONSE_MODES, SURPRISE_LABELS, thresholds
    expectation.rb              # Expectation value object
    violation_event.rb          # ViolationEvent value object
    violation_engine.rb         # Engine: expectation registry, violation detection, adaptation
  runners/
    expectation_violation.rb    # Runner module: all public methods
```

## Key Constants

| Constant | Value | Purpose |
|---|---|---|
| `VIOLATION_THRESHOLD` | 0.3 | Minimum magnitude to register as a violation event |
| `ADAPTATION_RATE` | 0.2 | Rate at which expectations update after violations |
| `SURPRISE_BOOST` | 0.3 | Attention increase per significant violation |
| `ATTENTION_DECAY` | 0.05 | Heightened attention decays per cycle |
| `MAX_EXPECTATIONS` | 200 | Expectation registry cap |
| `MAX_VIOLATIONS` | 500 | Rolling violation log cap |
| `VIOLATION_TYPES` | `[:positive_surprise, :negative_surprise, :neutral_violation, :schema_mismatch]` | Violation categories |
| `RESPONSE_MODES` | `[:update_belief, :heighten_attention, :explore, :ignore]` | Adaptive responses |
| `SURPRISE_LABELS` | range hash | `shocking / surprising / notable / slight / within_expectation` |
| `ATTENTION_LABELS` | range hash | `highly_alert / alert / normal / low` |

## Runners

All methods in `Legion::Extensions::ExpectationViolation::Runners::ExpectationViolation`.

| Method | Key Args | Returns |
|---|---|---|
| `register_expectation` | `domain:, predicted:, confidence: 0.7, context: {}` | `{ success:, expectation_id:, domain:, predicted:, confidence: }` |
| `check_expectation` | `expectation_id:, actual:` | `{ success:, violation_detected:, magnitude:, violation_type:, response_mode:, surprise_label: }` |
| `process_violation` | `violation_id:` | `{ success:, processed:, belief_updated:, attention_boost:, exploration_triggered: }` |
| `attention_level` | — | `{ success:, attention:, attention_label:, heightened: }` |
| `recent_violations` | `limit: 10, domain: nil` | `{ success:, violations:, count: }` |
| `violation_rate` | `domain: nil` | `{ success:, rate:, rate_label:, window: }` |
| `expectation_accuracy` | `domain: nil` | `{ success:, accuracy_rate:, total_checked:, violations_count: }` |
| `update_expectation_violation` | — | `{ success:, attention_decayed:, violations_pruned:, expectations_pruned: }` |
| `expectation_violation_stats` | — | Full stats hash |

## Helpers

### `Expectation`
Value object. Attributes: `id`, `domain`, `predicted`, `confidence`, `context`, `checked`, `violated`, `created_at`. `to_h`.

### `ViolationEvent`
Value object. Attributes: `id`, `expectation_id`, `domain`, `predicted`, `actual`, `magnitude`, `violation_type`, `response_mode`, `processed`, `timestamp`. `to_h`.

### `ViolationEngine`
Central store: `@expectations` (hash by id), `@violations` (array, rolling), `@attention_level` (float 0–1). Key methods:
- `register(domain:, predicted:, confidence:, context:)`: creates Expectation
- `check(expectation_id:, actual:)`: retrieves expectation, computes magnitude from predicted vs actual mismatch and confidence, creates ViolationEvent if >= `VIOLATION_THRESHOLD`, determines violation type (positive/negative based on valence), selects response mode
- `process_violation(violation_id:)`: executes response mode — `:update_belief` updates expectation confidence via `ADAPTATION_RATE`, `:heighten_attention` boosts attention level, `:explore` flags for curiosity dispatch
- `attention_boost(magnitude:)`: adds `SURPRISE_BOOST * magnitude` to attention level, caps at ceiling
- `decay_attention`: reduces by `ATTENTION_DECAY` per cycle

## Integration Points

- `check_expectation` called from lex-tick's `post_tick_reflection` phase after each action
- `attention_level` modulates lex-tick's sensing budget (high attention = more detailed sensory processing)
- `violation_rate` feeds lex-prediction's accuracy calibration (high violation rate = lower confidence)
- `exploration_triggered` from `process_violation` dispatches to lex-epistemic-curiosity's `detect_gap`
- `belief_updated` from violation processing feeds lex-dissonance's contradiction detection
- `update_expectation_violation` maps to lex-tick's periodic maintenance cycle

## Development Notes

- Magnitude computation: absolute difference between predicted and actual values, scaled by expectation confidence
- For non-numeric predicted/actual: equality check — mismatch = full magnitude (1.0 * confidence), match = 0.0
- Violation type assignment: positive surprise if actual > predicted (or better than expected), negative surprise otherwise
- `:neutral_violation` assigned when magnitude is between threshold and 2x threshold (minor mismatch)
- `:schema_mismatch` assigned when actual value type differs from predicted (type-level surprise)
- Expectation confidence adapts after violations: `new_confidence = old_confidence - (ADAPTATION_RATE * magnitude)`
