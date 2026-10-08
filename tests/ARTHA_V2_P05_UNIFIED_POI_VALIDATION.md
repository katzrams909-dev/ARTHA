# ARTHA v2 P05 — Unified POI Validation

Target: `pine/v2/ARTHA_V2_P05_Unified_POI_Engine.pine`

## Compile

- [ ] Pine v6 compiles with zero errors.
- [ ] P01–P04 chart behavior remains unchanged.

## Registry parity

Compare native engine objects to unified diagnostics:

- [ ] active primary FVG appears as FVG POI;
- [ ] active IFVG appears as IFVG POI;
- [ ] active OB appears as OB POI;
- [ ] active BB appears as BB POI;
- [ ] retired native objects do not appear.

## Direction normalization

- [ ] bullish FVG reports +1;
- [ ] bearish FVG reports -1;
- [ ] bearish FVG -> bullish IFVG reports +1;
- [ ] bullish FVG -> bearish IFVG reports -1;
- [ ] bearish OB -> bullish BB reports +1;
- [ ] bullish OB -> bearish BB reports -1.

## Provenance

For selected POIs verify:

- [ ] source ID matches native object ID;
- [ ] episode ID matches native provenance;
- [ ] OB/BB parent FVG ID is preserved;
- [ ] structure scope/kind is preserved;
- [ ] displacement score is preserved;
- [ ] mitigation percentage mirrors native engine.

## Family policy

- [ ] secondaries are excluded by default;
- [ ] enabling secondary inclusion increases registry count without changing native lifecycle.

## Lookup helper

- [ ] nearest bullish POI identifies the closest active +1 POI;
- [ ] nearest bearish POI identifies the closest active -1 POI;
- [ ] being nearest does not generate any signal or setup.

## Non-repainting

After reload:

- [ ] active registry composition matches native engines;
- [ ] stable source IDs remain consistent;
- [ ] lifecycle-derived type/direction remains consistent.

## Exit gate

Do not begin REV/CONT setup state machines until unified POI parity is confirmed.
