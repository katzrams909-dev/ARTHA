# ARTHA v2 P17 — Calibration Preset Validation

Target:

`pine/v2/ARTHA_V2_P17_Calibration_Presets.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] CE10295 does not return.

## Default regression
- [ ] Default produces the same signals as P16.
- [ ] Default targets match P16.
- [ ] Default reaction behavior matches P16.
- [ ] P16 attribution results match when using Default.

## Preset switching
- [ ] Indices changes thresholds without runtime errors.
- [ ] Gold changes thresholds without runtime errors.
- [ ] FX changes thresholds without runtime errors.
- [ ] Custom uses all Custom-prefixed controls.
- [ ] changing Custom inputs while another preset is active has no effect.

## Engine invariants
- [ ] pivot logic unchanged.
- [ ] BOS/CHoCH/MSS definitions unchanged.
- [ ] FVG geometry unchanged.
- [ ] OB/BB causal logic unchanged.
- [ ] REV/CONT state definitions unchanged.
- [ ] NORMAL > MISS > EARLY unchanged.
- [ ] P15.1 T2 ordering unchanged.
- [ ] outcome model unchanged.

## Attribution
- [ ] performance table identifies active preset.
- [ ] family/source attribution still updates.
- [ ] grade attribution still updates.
- [ ] display OFF does not affect calculations.

## Market smoke test
- [ ] NAS100 5m with Indices.
- [ ] XAUUSD 5m with Gold.
- [ ] EURUSD 5m with FX.
- [ ] GBPUSD 5m with FX.
- [ ] compare each market against Default.
