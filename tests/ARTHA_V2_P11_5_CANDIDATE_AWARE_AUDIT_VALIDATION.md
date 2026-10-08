# ARTHA v2 P11.5 — Candidate-Aware Audit Validation

Target: `pine/v2/ARTHA_V2_P11_5_Candidate_Aware_Entry_Audit.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] P01–P11.4 core behavior remains unchanged.

## TRUE MISS
- [ ] full miss label requires active REV or CONT state at interaction arm.
- [ ] state-at-arm is preserved for the miss reason.
- [ ] true miss does not create eligibility, signal, or risk plan.

## EARLY
- [ ] no active candidate + recent REV sweep can become EARLY REV.
- [ ] no active candidate + trend + recent displacement/BOS can become EARLY CONT.
- [ ] EARLY uses small triangle only.
- [ ] EARLY is not counted as a missed entry.

## RAW
- [ ] trend-only POI rejection without recent causal context is RAW.
- [ ] RAW produces no chart marker.
- [ ] RAW is counted diagnostically.

## Clutter
- [ ] XAUUSD no longer fills with full orange NO_ACTIVE_CONT_STATE boxes.
- [ ] visible audit markers stay bounded.
- [ ] execution labels remain readable.

## Re-check
- [ ] GBPUSD 5m
- [ ] AUDUSD 5m
- [ ] EURUSD 5m
- [ ] XAUUSD 5m
- [ ] NAS100 sample

Use repeated TRUE MISS reasons—not EARLY/RAW frequency—to decide whether permanent entry logic should be changed.
