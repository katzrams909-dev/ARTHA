# ARTHA V2 P17.27.14.10 — Lean Independent OTE

## Trigger

User tested P17.27.14.9 in TradingView and received **CE10117: 100464 compiled tokens, maximum 100256** (208 over). P17.27.14.8 was the last user-chart-validated baseline.

## Change set: visual-only compiler-budget reduction

- Removed the optional **Auto Fib numeric/text labels** and the separate label array/cleanup subsystem from the read-only Auto Fib overlay. This removes the "Show Auto Fib level labels" input and leaves existing level *lines*, OTE band shading and confirmed swing/HTF source archives available.
- Simplified optional Auto Fib styling: fixed shading opacity, regular 70.5% key-line highlight/width, non-key dotted lines; removed unused per-scale dimming and bold-weight parameters.
- Fib anchor detection, historical archives, 50/62/70.5/79/100% levels, OTE production lookups, OTE signals and native POI overlap conditions are **unchanged**. The chart's discretionary Fib readout no longer has individual percentage *text labels*.
- No changes to NORMAL/EARLY/MISS, REV/CONT, MID or independent OTE eligibility; no changes to causal HTF, scoring, duplicate/episode keys, 3 ATR structural stop limit, TP1–TP4, historical entry markers, risk-plan lifecycle or alert definitions.
- Source code is 820 characters shorter than P17.27.14.9, but Pine compiler token savings are **unknown** until TradingView compiles it. Previous versions are preserved.

## Validation

1. Compile `pine/v2/ARTHA_V2_P17_27_14_10_Lean_Independent_OTE.pine` with TradingView Pine v6.
2. If CE10117 persists, record exact new token total; if successful, note actual success and validate chart behavior.
3. With `Enable independent confirmed OTE entries (experimental)=Off`, compare to P17.27.14.8 under identical symbol, timeframe, loaded history, and settings.
4. Turn independent OTE on with production OTE confluence Off to isolate the new source; inspect labeled OTE signals and accepted risk plans.
5. Set `Production OTE scale=All` for first breadth test. Then test more selective `Major + HTF`; check whether OTE was from a *prior confirmed* Fib range and a pre-existing native POI.
6. Verify no entry markers repaint in Bar Replay, one plan per accepted POI setup, 3 ATR maximum stop, TP1/TP2 and visual TP3/TP4, historical labels, REV/CONT and MID unaffected.
7. The removed Auto Fib level labels should not be mistaken for missing **production signal** labels; the six Auto Fib level lines and the 62-79% zone overlay still exist.

## Status

P17.27.14.10 committed, not yet TradingView-compiled. Previous confirmed baseline P17.27.14.8.
