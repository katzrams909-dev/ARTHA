# ARTHA v2 P11.6 — Direction-Aware Entry Audit

## Problem

P11.5 could still show EARLY markers in the wrong direction because a currently actionable POI direction was allowed to combine with stale directional context.

## Fix

### TRUE MISS

Unchanged.

A true miss still requires an active same-direction ARTHA REV/CONT candidate at interaction time.

### EARLY REV

Now requires a recent same-direction structural reversal event:

- CHoCH or MSS;
- within the audit context window;
- more recent than the opposite-direction CHoCH/MSS context.

A liquidity sweep by itself is no longer enough to create EARLY REV attribution.

### EARLY CONT

Now requires:

- external trend aligned with the interaction direction;
- recent same-direction displacement or BOS context;
- that directional context must be more recent than the opposite-direction displacement/BOS context.

This prevents a stale bullish expansion from producing bullish audit markers after bearish order flow has become more recent, and vice versa.

### RAW

Any POI reaction whose direction does not satisfy the candidate/recent-context hierarchy remains RAW:

- counted diagnostically;
- no chart marker.

## Priority

```text
active same-direction candidate
→ recent same-direction REV shift
→ trend + freshest same-direction CONT expansion
→ RAW
```

No ARTHA setup, signal, risk, or outcome logic is changed.
