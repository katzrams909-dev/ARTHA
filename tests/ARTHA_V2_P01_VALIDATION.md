# ARTHA v2 P01 — Validation Checklist

Target file: `pine/v2/ARTHA_V2_P01_StructureLiquidity_Core.pine`

## A. Compile gate

- [ ] Pine Script v6 compiles with zero errors.
- [ ] No warnings indicating illegal global mutation.
- [ ] Script loads within TradingView object limits on a normal intraday chart.

## B. Structure validation

Test on at least:
- FX intraday
- index intraday
- crypto intraday

For each:
- [ ] Internal pivots confirm only after `iLen` right bars.
- [ ] External pivots confirm only after `xLen` right bars.
- [ ] HH/HL/LH/LL classifications are stable after reload.
- [ ] BOS occurs only in current trend direction.
- [ ] CHoCH occurs on the first opposing break without qualified displacement.
- [ ] MSS occurs on an opposing break with qualified displacement.
- [ ] Protected low updates after bullish structure.
- [ ] Protected high updates after bearish structure.
- [ ] Structure event lines terminate on the confirmation bar and do not extend indefinitely.
- [ ] Internal/external display toggles do not alter engine behavior.

## C. Previous-period liquidity

- [ ] PDH/PDL = immediately previous completed day.
- [ ] PWH/PWL = immediately previous completed week.
- [ ] PMH/PML = immediately previous completed month.
- [ ] On a new period, the older same-source level becomes SUPERSEDED.
- [ ] Superseded lines stop at the period transition.
- [ ] No vertical joining artifacts occur between successive reference levels.

## D. Swing liquidity

- [ ] Confirmed external swing highs create Tier-2 buy-side liquidity.
- [ ] Confirmed external swing lows create Tier-2 sell-side liquidity.
- [ ] Confirmed internal swings create Tier-4 liquidity when enabled.
- [ ] Internal and external swings at nearly the same price do not create overlapping duplicate lines.
- [ ] A stronger external swing may upgrade a nearby weaker swing record.
- [ ] Duplicate suppression counter increments when a nearby swing is merged.

## E. EQH/EQL clustering

- [ ] Two confirmed nearby highs within ATR tolerance increment cluster count.
- [ ] Two confirmed nearby lows within ATR tolerance increment cluster count.
- [ ] EQH/EQL counts update in diagnostics.
- [ ] Clustered swing labels display the multiplicity (for example `x2`).
- [ ] Clustering does not move previously committed liquidity prices retroactively.

## F. Liquidity lifecycle

### Sweep

Buy-side:
- [ ] Price trades above the level and closes back below.
- [ ] State becomes SWEPT.
- [ ] Line terminates on sweep confirmation bar.
- [ ] Bearish sweep event fires once.

Sell-side:
- [ ] Price trades below the level and closes back above.
- [ ] State becomes SWEPT.
- [ ] Line terminates on sweep confirmation bar.
- [ ] Bullish sweep event fires once.

### Resolution

- [ ] Close above buy-side liquidity = RESOLVED, not SWEPT.
- [ ] Close below sell-side liquidity = RESOLVED, not SWEPT.
- [ ] Resolution line terminates on confirmation bar.

### Expiry

- [ ] Internal swing liquidity expires after configured max age.
- [ ] External swing liquidity expires after configured max age.
- [ ] Reference D/W/M liquidity does not expire by age; it is superseded by the next period.

## G. Non-repainting / reload

For several historical events:
1. note BOS/CHoCH/MSS bar;
2. note liquidity source and terminal bar;
3. reload chart;
4. compare.

- [ ] Structure events remain on same bars.
- [ ] Sweep/resolution bars remain identical.
- [ ] Cluster counts remain identical.
- [ ] Previous-period levels remain identical.
- [ ] No event disappears or changes classification after reload.

## H. Phase 1 exclusion gate

The P01 prototype must contain no:
- [ ] FVG/IFVG engine
- [ ] OB/BB engine
- [ ] VWAP
- [ ] divergence
- [ ] setup score
- [ ] trade signal
- [ ] risk/TP/BE engine

## Exit condition

P01 does not advance until all compile, lifecycle, and reload checks pass.
