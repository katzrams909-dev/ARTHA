# ARTHA v2 P17.10 — Structural Stop and Target Risk Controls

## Purpose

Add a hard cap for structural stop distance, make T1/T2 fallback targets respect a consistent maximum-R envelope, and align the default partial-T1 outcome model with actual breakeven stop management.

## Stop logic

- Adds `Maximum structural stop distance / ATR`, default **3.00 ATR**, configurable from 0.50 to 10.00 ATR.
- The structural stop itself is not pulled inward to satisfy the cap.
- If the selected structural stop is farther than the cap, the plan is rejected. Its signal marker is removed, its execution alert is gated off, and the last-signal/plan status records the risk filter reason.
- The existing active-plan drawings are not cleared when a new signal fails the risk filter.
- Stop models remain `Causal`, `POI edge`, and `Protected swing`; the existing ATR stop buffer remains 0.10 ATR by default.

## Target logic

- T1 liquidity candidates must meet the minimum T1 R threshold and leave enough room for T2's minimum separation within the maximum target-R bound.
- Fallback T1 is clamped to the configured minimum T1 R and the maximum feasible T1 R that leaves room for T2.
- T2 liquidity targets continue to require valid direction, minimum T2 R, separation beyond T1, and the maximum target-R bound.
- Fallback T2 is forced beyond T1 by the configured ATR/tick separation and capped at the same maximum target-R bound.
- If the configured maximum R and minimum separation cannot support valid T1/T2 geometry, the risk plan is rejected rather than drawing contradictory targets.

## Trade management and outcomes

- With `50% T1 + BE remainder`, after T1 is reached the actual remaining stop moves to entry. The stop line and stop label update to breakeven.
- If that breakeven stop is hit, realized R remains 50% of T1's R-multiple, matching the partial-exit model.
- If the plan expires after T1 under the partial model, it records the same partial T1 return with the remainder treated as breakeven.
- `No partial` keeps the original stop and existing full-position outcome behavior.
- Conservative same-bar stop precedence remains unchanged.

## Unchanged

- P17.9 remains intact.
- POI fill trigger selection, five-bar reaction confirmation, EARLY delay, normal REV/CONT signal logic, and structural stop placement models are otherwise unchanged.
- TradingView compilation and chart validation are pending.
