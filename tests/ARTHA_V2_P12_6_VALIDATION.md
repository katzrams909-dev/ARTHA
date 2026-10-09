# ARTHA v2 P12.6 — Validation

Target: `pine/v2/ARTHA_V2_P12_6_Lean_Reaction_Signals.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] CE10295 does not return.
- [ ] no type/declaration-order errors.

## Normal signals
- [ ] REV signals unchanged.
- [ ] CONT signals unchanged.
- [ ] normal duplicate/cooldown logic works.
- [ ] normal signal creates risk plan and recent-entry card.

## MISS
- [ ] former TRUE_MISS is promoted to a real signal.
- [ ] card is tagged MISS.
- [ ] risk/targets are created.
- [ ] outcome tracking works.
- [ ] duplicate/cooldown gates work.

## EARLY
- [ ] former EARLY opportunity is promoted to a real signal.
- [ ] card is tagged EARLY.
- [ ] direction matches P11.6 direction-aware context.
- [ ] minimum EARLY score is respected.
- [ ] risk/targets and outcome tracking work.

## RAW
- [ ] no signal.
- [ ] no card.
- [ ] no risk plan.

## Display
- [ ] newest active plan only uses full ENTRY / SL / T1 / T2 geometry.
- [ ] last 4 recent entry/result cards remain visible.
- [ ] old cards delete cleanly.
- [ ] no duplicate terminal-result labels.

## Smoke test
- [ ] XAUUSD 5m
- [ ] EURUSD 5m
- [ ] GBPUSD 5m
- [ ] AUDUSD 5m
- [ ] NAS100
