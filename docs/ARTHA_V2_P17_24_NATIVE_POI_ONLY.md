# ARTHA P17.24 — Native POI Only

Status: source committed. TradingView compilation and runtime regression tests are pending. The last user compile-confirmed version is P17.22.2; P17.23 and P17.23.1 have not been user-confirmed compiled.

## Scope
- Removed entire 03A HTF POI configuration and display stack: simplified selected-timeframe FVG source, 15m/1H FVG rectangles, source-frame OB/BB candidate detector, multi-zone candidate registry, parity diagnostics and inversion-candidate drawings.
- Removed the independent HTF FVG reaction entry path, HTF_POI source tagging and its alert. The trade-plan admission path now processes only native chart-timeframe REV/CONT signals and their reaction variants.
- Retained native FVG/IFVG and OB/BB registries, existing first-touch/50-percent/full-fill/retirement visual endpoints, separate native inversion phase boxes and archival limits.
- Preserved native structural stop function, TP1=1R / TP2=2R under existing Fixed R option, managed TP3/TP4, independent existing risk plans and performance monitoring.
- Kept confirmed higher-timeframe SWING liquidity as an optional TP3/TP4 source. This is not HTF POI identification or entry logic. Can be disabled with Include confirmed HTF swing liquidity in TP3/TP4.
- Skipped P17.19.1 session line patch remains unmerged as requested.

## Source reduction
P17.23.1: roughly 224K characters, 4296 lines. P17.24: roughly 197K characters, 3852 lines. Removed around 27K characters and 444 lines, notably main-body HTF code.

## Validation
1. Compile P17.24 in Pine v6. Report exact line/error if one remains.
2. On NAS100USD 5m confirm zero imported 15m/1H POI rectangles and no HTF OB candidate overlay or candidate audit. Native 5m POI rectangles and successful fill stop rules should remain.
3. Replay a native FVG->IFVG and OB->BB inversion, verify phase boxes remain independent.
4. Compare native REV/CONT signal occurrences, structural stops, and T1/T2/T3/T4 on same historical segment against earlier known working native paths.
5. Verify TP3/TP4 HTF swing liquidity option ON/OFF changes only extended liquidity targets, not entries.

## Note
Removing HTF POIs is a source-level removal, not merely hiding them. Previous versions remain available in GitHub, so the architecture can be reintroduced later after native parity is established.