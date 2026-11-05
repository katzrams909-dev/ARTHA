# ARTHA P17.27.13.1 — CE10117 Dashboard Token Compact

## Reported error
P17.27.13 failed TradingView Pine compilation: **100,994 compiled tokens**, with a maximum of **100,256** (CE10117). Excess: **738 compiled tokens**.

P17.27.13.1 is a versioned source file based on P17.27.13. **TradingView compilation is unconfirmed.** P17.27.12.2 remains the latest user-confirmed compilation and chart-validation baseline.

## Exact change
- The existing `f_renderSetupDashboard()` repeated 20 `table.cell()` calls, including repeated color, size and table-position arguments.
- The new version retains the header and uses a 9-row loop with two `table.cell()` sites. Row titles, values and text colors are constructed from fixed 9-element arrays. This preserves the displayed status, active-plan counts, newest-open plan, entry, SL and TP1–TP4; the header text changes only to P17.27.13.1.
- The table remains 2 columns × 10 rows and still clears when disabled.
- Source size decreased from 233,177 to 231,558 characters (**1,619 characters fewer**). **This is not equivalent to compiled-token reduction; TradingView must confirm the token total.**

## Intact architecture
- Confirmed HTF OTE pivot ranges, > chart timeframe guard, prior-closed HTF candle offsets with `lookahead_on`, 2.5× HTF ATR impulse filter, Major 2.0× chart ATR impulse filter, Minor/Major/HTF/All Fib choices.
- Native POI confluence and OTE A/B/C hypothetical study calculations, including study SL/TP1–TP4.
- Production REV/CONT/EARLY/NORMAL/MISS state machines, accepted-plan identity, independent risk plans, P# labels, EARLY→NORMAL confirmation-only upgrade, strict 3-ATR maximum SL, causal stop options, targets, alerts, and rejected markers.
- No OTE status dashboard or performance-attribution table has been reintroduced.

## Validate
1. Compile `pine/v2/ARTHA_V2_P17_27_13_1_HTF_Token_Compact.pine`; report CE10117 number if it persists, or other exact line/code if it fails.
2. Verify 10-row main dashboard shows correct newest-open-plan state and prices. Toggling its display should clear the table.
3. On USDCHF 1H, enable Auto Fib, Confirmed Swings, Major + HTF, HTF=240. Verify confirm-close range activation and no retroactive OTE entries.
4. On USDCAD 5m and a second instrument verify unchanged risk-plan acceptance, stop, TP1–TP4 and OTE study markers.
5. If CE10117 remains, target another non-execution visual/reporting block, rather than deleting HTF validity rules or relaxing structural risk filters.
