# ARTHA P17.27.8 — OTE Reaction and Entry-Path Observations

## Status
Committed on `artha-v2-p17-presets`. **TradingView compilation and visual validation pending**. P17.27.7.1 is the user-confirmed compile baseline. This is an *observational* step: no new OTE production signals, orders, trade plans or alerts.

## Objective
Observe what occurs after a Fib first touches its 62–79% OTE band **with a qualified active, same-direction native POI**. Distinguish:
1. Aggressive-path rejection (observable setup, **not** an order);
2. Subsequent confirmed directional reaction; and
3. A later retest.

The previous P17.27.7.1 first-touch POI gate remains authoritative. A touch without an eligible POI never enters the reaction sequence, even if a POI appears later.

## State
Each `OTEShadowRange` now stores:
- `touchBar`: first OTE band touch (confirmed chart bar)
- `rejectBar` and `rejectExtreme`: first qualified directional rejection bar and its high (bullish) / low (bearish)
- `confirmBar`: first subsequently confirmed directional reaction
- `aggressiveSeen`, `confirmedSeen`, `retestSeen`: one-shot observations

All new records initialize these fields to `na` or `false`. Both source constructors have been checked to provide all 20 fields in order. State is updated only on confirmed chart bars and after the range's own confirmation bar.

## Definitions
### Eligible first touch
The first price bar crossing the 62–79% Fib zone records `qualifiedTouch` only if `f_otePOIIndex` finds an active, same-direction, positive-width overlapping FVG/IFVG/OB/BB that predates that bar. This is not retroactively changed.

### Aggressive rejection
Within `OTE reaction confirmation window` bars after the first touch (default 8):
- `qualifiedTouch` true and native POI overlap **still live**;
- candle intersects the existing frozen 62–79% OTE band;
- bullish: `close > open` and `close > 70.5% price`;
- bearish: `close < open` and `close < 70.5% price`.
Record the rejection candle's high/low and bar. It can be the original touch bar if all requirements are satisfied on its confirmed close. This flags an observation, not a live price-level limit entry.

### Confirmed reaction
On a bar strictly *after* rejection, and within the original first-touch window:
- close beyond the rejection candle's high (bullish) or low (bearish); **and**
- qualified directional displacement OR internal/external MSS, reusing production's read-only event flags.
Record the first confirmed bar. No entry is created.

### Retest
On a bar strictly *after* reaction confirmation, within `OTE retest observation window` (default 12):
- the candle intersects the frozen 62–79% band again;
- directional close still satisfies rejection conditions;
- actionable overlapping POI remains active.
Mark the first retest. Unlike a generic newly created FVG retest, this specifically tests the **original OTE band**. A distinct execution-zone retest model may be evaluated later.

### Invalidation
Origin (100%) invalidation continues to remove the range; confirmed pre-touch 0% extension and frozen post-touch geometry remain unchanged. An observation is not independent of the Fib lifecycle and does not modify any managed production trade.

## User controls and display
In section 14C:
- `Show OTE reaction observation`: ON (default)
- `OTE reaction confirmation window (bars)`: 8 (2–30)
- `OTE retest observation window (bars)`: 12 (2–40)

The existing top-center Fib panel adds a brief `OTE REACTION` status:
`WAITING`, `AWAITING POI`, `NO POI TOUCH`, `QUALIFIED TOUCH`, `REJECTION`, `CONFIRMED`, or `RETEST`.

This status reads the newest retained source range (Minor by default in Both mode) and is not a performance audit. No added drawing lines, labels or trade objects.

## Scope and restrictions
- Native POI registry eligibility and direction unchanged.
- REV/CONT, EARLY/MISS, real entry admission, structural stops, TP1–TP4, managed trades and performance attribution unchanged.
- All state is observational and confirmation-based; future candles do not backdate a model trigger to its pivot bar.
- No midpoint statistics or LTF requests reinstated.
- This stage does **not** establish a profitable strategy; it measures candidate event sequencing only.

## Validation
1. **Compile** P17.27.8. Report exact compiler error/line or CE10117 token count if any.
2. Compare native signal/POI/risk plans with P17.27.7.1 on the same market, timeframe and loaded bars.
3. Check Minor/Major/Structural Break source. No POI or opposite POI => no REJECTION / CONFIRMED / RETEST status.
4. Confirm rejection bar's direction, close relative to 70.5% and actual OTE band overlap.
5. Confirm a reaction is never tagged CONFIRMED on the same candle as REJECTION; it must close beyond the frozen rejection extreme with displacement or MSS.
6. Confirm RETEST occurs on a **later** bar intersecting the original OTE band while native POI remains eligible.
7. Confirm 100% invalidation deletes the range and no stale active candidate remains displayed.
8. Inspect cases with a POI flipping direction or retiring between OTE first touch and reaction. The observed model must not advance without current actionable confluence.

## Next
P17.27.9 can compare observational pathways against existing structural stop and TP models, then consider carefully controlled integration *only after* visual and outcome validation.
