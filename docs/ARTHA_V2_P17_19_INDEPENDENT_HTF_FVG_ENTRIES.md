# ARTHA v2 P17.19 — Independent HTF FVG Reaction Entries

## Status
Committed engineering draft; **not compiled or run in TradingView yet**. P17.18.1 remains the latest user-confirmed working baseline and has not been modified.

## What this release implements
- `03A Multi-Timeframe Context` now has `Allow independent HTF FVG reaction entries` (default On), `Keep native REV / CONT entries` (default On), and an editable directional reaction close-strength threshold (0.60 default).
- A separately admitted HTF-derived entry requires: (a) prior-completed selected HTF FVG data with `lookahead_on`, (b) confirmed chart-timeframe candle overlapping the FVG, (c) directional LTF close with the required close location and the appropriate side of the HTF zone, (d) a valid HTF zone not already accepted. No native episode ID or native same-bar signal arbitration is required.
- HTF entry provenance: `source=HTF_POI`, `poiEngine=HTF_FVG`, `poiId=HTF origin time`, chart-timeframe entry price is the signal candle close. A successfully accepted HTF FVG origin is consumed once, independent of native signal history.
- HTF entries get a structural stop at the opposite HTF FVG boundary plus existing ATR buffer; wrong-side stops and stops exceeding configured ATR maximum are rejected. Fixed-R TP1/TP2 and eligible liquidity-based managed TP3/TP4 reuse the P17.18.1 risk plan lifecycle. No broker orders are placed; this is the same indicator-internal outcome model.
- Native and HTF entries run in two separate event slots. Native signal arbitration remains unchanged; simultaneous HTF/native events create two independent risk-plan records. `Draw only newest active plan` is now OFF by default so concurrent plans remain visible, although TradingView drawing resource limits still apply.
- Additional `REV_HTF_POI` and `CONT_HTF_POI` performance-source buckets, and `ARTHA v2 HTF FVG Entry` alert condition.

## Important limitations
- **FVG reaction only**, from the single selected POI timeframe. HTF IFVG, OB and BB are **not** independently reconstructed or used to generate HTF entries in this release. P17.19 is a functional first stage, not completion of the full HTF source-registry roadmap.
- The HTF `CONT` versus `REV` family assigned here reflects the FVG direction matching or opposing the local external trend. It does **not** claim native REV sweep/MSS or CONT impulse-episode predicates have been met. HTF reaction scoring is a dedicated rough 70–100 scale, not comparable to native quality grades until calibration is implemented.
- Source-zone identification is by HTF FVG origin timestamp and the latest remembered FVG per HTF. This is not a multi-zone/OB registry. HTF FVG zone boxes continue to be display-only back-anchored to formation; entry admission is non-retroactive and receives confirmed HTF data.
- `Keep native REV / CONT entries` disables native risk-plan *creation* when off; native signal detection still runs. Leave it on for the agreed parallel-entry architecture.
- Existing `showOnlyLatestActivePlan=false` may increase object count substantially on long intraday histories. Test especially on XAUUSD 1m/5m.

## Required tests
1. Compile in TradingView Pine v6, including full-history runtime replay and old historical-buffer bar 5805.
2. On 5m XAUUSD with POI source 1H, verify independent `HTF_POI` entry when a confirmed 1H FVG is revisited and directionally confirmed on 5m. It must not be generated at the historic formation bar.
3. Confirm a same-bar native and HTF entry can co-exist, retain separate stops/targets and resolve independently; setting show-only-latest false should preserve both drawings.
4. Disable `Allow independent HTF FVG reaction entries` and compare native entries/outcomes to P17.18.1 on otherwise matching data/settings.
5. Verify TP1=1R, TP2=2R, managed TP3/TP4 allocation and stop-first fills for both paths.
6. Change POI source 15m/1H while entry chart remains 5m, and check no unfinished HTF data is used.
7. Review REV/CONT contextual classification and 70–100 score before comparing HTF to native performance.
8. Check max lines/labels/boxes on several weeks of 1m/5m candles; if overloaded, toggle latest-only drawing temporarily without altering plan state.

## Next stage
Add source-accurate confirmed HTF IFVG, OB and BB registries with stable IDs and invalidation/mitigation lifecycle, followed by proper native-quality cross-timeframe setup scoring. Do not approximate those sources by relabeling FVG zones.
