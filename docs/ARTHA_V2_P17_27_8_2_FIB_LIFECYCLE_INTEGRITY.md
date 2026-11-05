# ARTHA P17.27.8.2 — Fibonacci Lifecycle Integrity

## Status
New versioned Pine v6 source committed to branch `artha-v2-p17-presets`. **TradingView compilation and visual validation pending**. P17.27.8 is the last user-confirmed compile checkpoint; P17.27.8.1 was a status consistency patch and has not yet been separately compile-confirmed.

## Report and design
User reports some Fib ranges remain after price invalidates their 100% origin, or fail to adjust when price extends beyond 0%. Previous behavior defaulted to confirmed-close tests, and a new confirmed swing Fib could be created after its origin was already violated *while waiting for pivot confirmation*. Fix both without editing native entry engines.

## Changes
1. **Default `100% origin invalidation` changed from Close to Wick**, retaining `Close` as a user option. Bullish: after the candidate's confirmation, a closed candle with `low < origin` removes it; bearish: `high > origin`. When the mode is Close, use `close < origin` or `close > origin`. Equality is not a strict breach. No intrabar state mutation on the still-forming candle.
2. **New `0% pre-touch extension trigger`**: `Wick` (default) or `Close`. On a confirmed candle, a bullish `high > extreme` (or `close > extreme` in Close mode) updates the extreme to the completed candle's high; bearish equivalent updates to the low. The 62%, 70.5%, 79%, 50% and 0% derived prices are redrawn using the fixed 100% origin. The original first-touch priority stays: any band intersection freezes the range and prevents a same-bar extension because the intrabar ordering is ambiguous.
3. **Confirmed pivot backfill audit:** New Minor and Major Fib archive records scan completed candles after the extreme pivot bar, up to and including the actual confirmation bar. For Minor this is the `xLen` right-confirmation interval; for Major it is `oteMajorBars`. If any of these candles strictly violates the 100% origin under the selected Wick/Close policy, the candidate **is not introduced**. This prevents a late-confirmed swing from resurrecting a range already invalidated during pivot confirmation.
4. **Historical OTE contact:** If the 62–79% band was reached during those preconfirmation candles, the record is initialized with `touched=true` and the earliest observed `touchBar`. Thus its Fib geometry won't subsequently extend despite a preconfirmation touch. Crucially `qualifiedTouch=false` and no aggressive/confirmed/retest event is backdated: historical POI availability cannot be safely recreated from the current live POI registry.
5. Bounded archives still contain at most 15 records/source, drawing limits and latest/historical selectors remain unchanged.
6. The structural-break source is still created on its confirmed break candle (no pivot-right-window backfill); the common ongoing archive maintenance handles its wick/close invalidation and pre-touch extension on subsequent closed bars.

## Existing deliberate behavior
- A **post-touch** valid Fib does not adjust to newer highs/lows. This is intentional: geometry is frozen. A new confirmed impulse can create a *separate* range. All active Fib candidates remain subject to 100% invalidation even after first OTE touch.
- The indicator cannot remove **manually drawn TradingView Fib objects**; only its own line/box/label drawings are managed.
- The current form of backfill scans after the *last extreme pivot* until confirmation, not the entire interval from the older origin pivot through that extreme. A still older-origin invalidation would need a separate origin-to-confirmation audit.
- On an unconfirmed live candle the plotted range remains until confirmation, even if the wick has temporarily crossed origin. This is intentional and prevents intrabar instability/repainting.
- Fib lifecycle improvements do **not** make an OTE setup executable and do not relax production displacement requirements; that separate proposal remains for P17.27.8.3.

## Unchanged
- Native FVG/IFVG/OB/BB qualification, lifecycle and visualization.
- OTE POI confluence, first-touch gating and rejection/confirmation/retest observations.
- REV/CONT/EARLY/MISS logic, normal entry admission and classification, structural stops, TP1–TP4, independent managed plans.
- No new OTE orders, labels or live risk plans.

## Validation plan
1. Compile P17.27.8.2 in Pine v6. Report first compile error code and line, or the CE10117 token count if present.
2. Test NAS100, DE30, EURUSD and BTCUSD with identical history and settings. Confirm old ARTHA Fib ranges disappear on completed-candle origin wicks in default Wick mode, in both Latest and Historical modes.
3. Compare Wick vs Close origin invalidation on a completed candle with beyond-origin wick but return close. Wick removes; Close retains.
4. Test a fresh confirmed pivot where an intervening confirmation-period candle violated its origin: it should never appear in the archive.
5. Test an intervening confirmation-period OTE touch without origin invalidation: an archived range may appear, but marked touched, not entry qualified, with frozen anchor.
6. Test extension beyond 0% on a closed candle before OTE touch. In Wick mode the new high/low moves the 0% extreme even if candle closes within; in Close mode only a close beyond 0% qualifies. On the first OTE touch, freeze.
7. Verify that existing POI states, original signals, stops and TP1–TP4 match the baseline on closed bars.
8. If a user still sees a stale Fib, identify whether it is manual vs ARTHA drawing, its source (Minor/Major/Break), whether the relevant candle is closed, and the selected invalidation mode.
