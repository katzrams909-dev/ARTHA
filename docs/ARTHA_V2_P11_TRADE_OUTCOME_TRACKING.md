# ARTHA v2 P11 — Trade Management & Outcome Tracking

## Objective

Track the lifecycle and model-based outcome of each P10.1 risk plan while keeping ARTHA as an indicator.

Pipeline:

```text
Eligible setup
→ quality
→ P09 signal
→ P10.1 risk plan
→ P11 outcome
```

## Outcome states

```text
ACTIVE
→ T1_HIT
→ T2_HIT
→ STOPPED
→ EXPIRED
```

T1 is non-terminal.
T2, STOPPED and EXPIRED are terminal.

## Conservative bar sequencing

Without intrabar order data, if stop and target are both touched on one bar, STOP takes precedence.

This deliberately avoids optimistic historical accounting.

## Outcome models

### No partial

- T2 hit: +RR2
- Stop: -1R
- Expired: excluded from realized-R statistics

### 50% T1 + break-even remainder — default

- T2 hit: 0.5 × RR1 + 0.5 × RR2
- Stop before T1: -1R
- Stop after T1: 0.5 × RR1
- Expired: excluded from realized-R statistics

This is a modeling assumption, not proof of actual fills.

## Statistics

P11 tracks:

- T1 reached
- T2 reached
- stopped
- expired
- cumulative realized R
- average realized R
- REV average R
- CONT average R
- REV win rate
- CONT win rate
- last terminal outcome

Expired plans are not included in average-R or win-rate denominators.

## Visual policy

Terminal outcome labels are OFF by default to preserve ARTHA's clean-chart policy.

The P10.1 finite-line lifecycle remains unchanged.

## Non-goals

P11 does not:

- place orders
- simulate slippage
- simulate spread
- size positions
- model partial fills beyond the selected deterministic outcome model
- claim statistically significant performance

A later strategy harness may be used to validate the engine under TradingView's order simulator.
