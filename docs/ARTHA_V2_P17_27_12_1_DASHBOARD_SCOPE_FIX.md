# ARTHA v2 P17.27.12.1 — Dashboard Main-Body Scope Fix

## Error and intent
P17.27.12 produced TradingView Pine Script v6 **CE10295**: `The main body of the script is too long. Try wrapping code in functions.` This is a distinct compilation limit from **CE10117** (total compiled tokens), previously encountered in ARTHA.

P17.27.12.1 derives from P17.27.12 without overwriting prior versions, and targets only the main-body size problem.

## Refactor
- Retain existing global dashboard position calculation and `var table setupDashboard` declaration.
- Move **all dashboard calculations and drawing**, from `dashTextSize` through the last `table.clear`, into a new top-level function `f_renderSetupDashboard()`.
- Invoke the function exactly once after declaration; its internal `barstate.islast` gate remains unchanged.
- The function only reads the existing global setup/risk/signal states, scans the existing `riskPlans` array to identify the newest **still-open** plan and count active plans, and calls `table.cell` or `table.clear`. It does not reassign globals, create trades, or modify `riskPlans`.

This removes approximately **4,779 characters of dashboard statements from the top-level main body**. Source bytes may increase slightly due to function indentation; that does not indicate increased main-body complexity. Neither an exact reduction in CE10295's compiler body complexity nor the compiled-token total can be verified without TradingView.

## Preserved
- Independent multi-plan accounting and ID labels introduced in P17.27.12.
- The `EARLY -> NORMAL` confirmation-only upgrade (no second trade automatically).
- Original P17.27.11.5 entry geometry, native POI identity, risk filter, `Causal` and optional `Local causal` stops, TP1–TP4, OTE study markers and rejected candidate labels.
- Main setup dashboard layout: 2 columns, 10 rows. **The previously removed OTE dashboard has not been reinstated.**
- Single winning production signal per candle, with multiple independent active plans across different candles. Same-candle multi-entry remains a separate later feature.
- Previous source files remain unchanged on branch `artha-v2-p17-presets`.

## Testing
1. Compile `pine/v2/ARTHA_V2_P17_27_12_1_Dashboard_Scope_Fix.pine` in TradingView. Report any CE10295 or CE10117 code and the exact token count if shown.
2. Use USDCHF 1h and BTCUSD 5m; confirm historical normal/early entries, rejected marker diagnostics and risk plans are unchanged from P17.27.11.5 except for intended P17.27.12 multi-plan labels and upgrades.
3. For two independently active plans, verify the dashboard shows the **newest still-active plan** and the total `OPEN` count. When it closes, ensure an older open plan becomes the displayed plan.
4. Confirm turning off the main setup dashboard clears it, and turning it on shows its 10 rows.
5. Check `P17.27.12.1` in the title and setup header, original stop distance safety gates, TP1–TP4 and OTE overlays.
6. Do not consider a successful commit proof of compilation or runtime correctness.

## Subsequent work
Once compile-confirmed and multi-plan regression-tested, continue with independent same-candle signal candidates only as a dedicated further integration change.
