# ARTHA v2 P17.19.1 — Session H/L line visibility

## Status
Draft committed, not yet compiled or runtime-verified in TradingView. User confirmed P17.19 compiles.

## Finding
Session high/low records for Asian, London, New York are registered on first confirmed chart candle outside each configured session. They share the generic liquidity lifecycle: a sweep, close-through resolution or next session supersession makes their `state` nonzero, and normal rendering hides them unless the global terminal display is enabled. Execution mode also suppresses tiers above 2. Consequently session lines may appear missing even though registration occurred.

## Change
- New `Show completed Asian / London / NY H/L lines` input defaults true.
- New `Keep swept / resolved session lines visible` input defaults true.
- Session lines and source labels have their own visibility path, independent of general `showTerminalLiquidity`, Tier filters, `showLiquidityLabels` and Execution/Analysis display mode.
- Separate configurable session line colors: Asian aqua, London orange, New York fuchsia; width 2, dashed after termination.
- Terminal lines retain their existing terminal timestamps (don't falsely extend old swept/superseded levels into the future). Trade-eligibility still requires `q.state==0`; display does not resurrect inactive liquidity.
- Native REV/CONT and HTF FVG event admission, structural stops, fixed 1R/2R targets, staged liquidity exits are unchanged.

## Limits
- Session lines only appear **after their session closes**, not during the developing session, consistent with the confirmed-session design.
- Records are still bounded by the shared `maxLiquidity` cap. Very old session lines may be trimmed, so this is not a permanent all-history archive.
- The configured session windows are custom market windows in America/New_York by default, not exhaustive exchange calendars.

## Validation
1. Compile P17.19.1 Pine v6 and fully replay.
2. On 5m XAUUSD, after 05:00 New York time verify LDH/LDL; after 12:00 New York time verify NYH/NYL. Inspect chart around completion rather than during session.
3. Confirm terminal dashed lines are visible when `Keep swept / resolved session lines visible` is ON, and hidden when OFF.
4. Verify Session H/L visual switches do not affect actual liquidity-state/TP3/TP4 calculations.
5. Confirm no change to native entries, independent HTF entries, structural stops, risk model or stage accounting.
