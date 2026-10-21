# ARTHA v2 P17.12.1 — G11 Declaration Order Fix

## Scope
Compile-only correction based on P17.12. Original P17.12 remains unchanged.

## Reported TradingView error
`Undeclared identifier "G11"` (CE10272), line 220.

## Change
Move the existing `string G11="11 Signal Engine"` declaration to immediately before the signal-label-style inputs that reference `group=G11`. Keep exactly one declaration.

## Unchanged
REV/CONT setup and signal logic, adaptive MISS/EARLY logic, higher-timeframe confirmed-value behavior, structural stop and target calculations, signal arbitration, and risk/outcome processing. No new feature or preset behavior.

## Validation
**Not compiled or validated in TradingView.** User must paste P17.12.1 into Pine Editor, compile, and report the next compiler/runtime issue or confirm compilation. After compilation, follow the P17.12 validation checklist at `tests/ARTHA_V2_P17_12_VALIDATION.md`.

## Source
`pine/v2/ARTHA_V2_P17_12_1_G11_Declaration_Order_Fix.pine`
