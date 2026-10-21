# ARTHA v2 P17.13 — Visual Liquidity Targets and Persistent Plans

## Status
Draft committed. **TradingView Pine v6 compilation and chart validation are not yet confirmed.** The last user-confirmed compiled baseline is P17.12.1.

## Changes
- Visual TP3 and TP4 snapshot the nearest eligible active liquidity levels beyond managed TP2 (and beyond TP3), respecting the configured tier and minimum separation. They are omitted if no qualifying level exists.
- TP3/TP4 do not participate in simulated exits, breakeven changes, or realized-R accounting. Managed TP1/TP2 remain unchanged.
- Default risk fill is gray, bullish reward fill cyan (#00BCD4), bearish reward fill purple (#9C27B0). Transparency remains configurable.
- Accepted plans with risk labels enabled use a unified entry label; the provisional signal marker is deleted after plan admission. Entry text includes family, direction, signal source, quality, entry, and triggering POI/episode reference.
- Age-based risk-plan expiry removed. Unresolved plans are preserved when enforcing the history cap; the cap trims resolved records only. Display-only 'latest active plan' behavior remains.

## Important caveats
- Pine/TradingView has not compiled this draft; errors may remain.
- The entry reason is a provenance summary, not a complete audit of all signal predicates.
- Exact visual matching to the uploaded FVG Retest Entry Engine signal label style remains to be validated visually.
- An unbounded number of concurrently active plans can eventually encounter Pine memory/execution limits; this is a design tradeoff that needs stress testing.
- Existing terminal-state visual cleanup removes TP3/TP4 drawings when TP2 or SL resolves the managed plan, even though the extensions are informational.

## Validation
1. Compile Pine v6 and report first error if any.
2. Confirm only one visible entry label per accepted plan with default display settings.
3. Confirm gray risk, cyan long reward, purple short reward.
4. Confirm TP3/TP4 are beyond TP2 and derived from active liquidity; missing candidates do not create invented targets.
5. Confirm outcome statistics are unchanged by TP3/TP4.
6. Confirm active trades persist beyond 80 bars and across subsequent independent entries.
7. Stress test more than maxRiskPlans concurrently active plans and object limits.
8. Check tooltip/readability and reference-indicator label styling.
