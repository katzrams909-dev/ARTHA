# ARTHA P17.27.14.2 — Signal flow diagnostics

## Status
Created after user reported P17.27.14.1 compiles but no NORMAL POI or OTE trade signals. **P17.27.14.2 has not yet been compiled or chart-tested.** Previous .14/.14.1 sources preserved.

## Scope
No changes to trading/admission logic, thresholds, state machines, repainting behavior, structural risk or OTE rules. Temporarily swaps setup-dashboard TP3/TP4 rows for diagnostics when 'Show signal-flow diagnostics' is enabled (default ON). Disable it to restore those rows.

Dashboard counters are cumulative over loaded history:
- POI / ELIGIBLE: currently active unified native POI count / cumulative NORMAL eligible events (REV and CONT split).
- SIGNAL FLOW: S = emitted native and reaction signals after arbitration (approximate surviving historical count; signal counters don't guarantee accepted plans); Rx = reaction events emitted before same-bar arbitration; Q = rejected NORMAL quality; D = rejected NORMAL duplicate; C = rejected NORMAL conflict incl same-bar direction conflicts; R = risk admission rejections; P = accepted risk plans.

## Interpretation
- POI = 0: investigate native POI creation/lifecycle/filters, not OTE.
- POI > 0, ELIGIBLE = 0: investigate native setup progression, retests, 50% cumulative depth, reclaim windows and structure/trend requirements.
- ELIGIBLE > 0, S = 0: quality, duplicate and conflict gates.
- Rx = 0, eligible = 0: investigate reaction context and EARLY/MISS confirmation rules.
- S > 0 and P = 0: risk plan admission; R and setup/state dashboard indicate likely rejections. Test OTE mode Off to distinguish OTE admission from structural-stop and target filters.
- P > 0 but no visible plans: display settings, plan lifecycle/visual cleanup.
- OTE production is **confluence-based**, not an independent entry generator. Confirmed OTE drawing alone does not produce a plan.

## Verification
1. Compile the .14.2 source on the same chart as .14.1.
2. Set Production OTE confluence = Off. Keep setup dashboard visible and signal-flow diagnostics ON.
3. Report POI / ELIGIBLE and SIGNAL FLOW dashboard rows, plus SETUP / STATE.
4. Recheck with OTE Annotate then Require if native entry pipeline is working.
5. Never alter the 3 ATR max stop filter merely to create signals.

## Constraints
TradingView Pine token count is compiler-specific; this instrumented build may encounter CE10117 and has not been compiled. If so, optimize or replace visual-only code; do not remove protective admission rules.
