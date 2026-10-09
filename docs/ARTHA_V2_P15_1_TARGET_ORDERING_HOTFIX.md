# ARTHA v2 P15.1 — Target Ordering Hotfix

## Scope

P15.1 is a narrow production hotfix built from `ARTHA_V2_Production.pine`.

It changes only:

1. T1/T2 liquidity-target selection;
2. guaranteed T2 ordering;
3. recent-entry input wording.

No setup, signal, stop, score, conflict, reaction or outcome logic is changed.

## Issue 1 — fallback T2 could be behind T1

Example:

```text
liquidity T1 = 4.0R
configured fallback T2 = 2.5R
```

The previous implementation detected that 2.5R was not beyond T1, but then reassigned the same 2.5R fallback.

P15.1 constructs fallback T2 as:

```text
bull:
max(configured fallback T2,
    T1 + minimum separation)

bear:
min(configured fallback T2,
    T1 - minimum separation)
```

Minimum separation is at least one tick and normally the configured ATR separation.

Therefore T2 is always beyond T1.

## Issue 2 — invalid second liquidity could hide a valid third level

Previous flow selected the nearest two target candidates, then validated T2 afterward.

Example:

```text
L1 = 1.2R → valid T1
L2 = 1.4R → invalid T2
L3 = 2.2R → valid T2
```

The old engine could discard L2 and fall back to fixed R without considering L3.

P15.1 uses two passes:

```text
Pass 1:
find nearest valid T1

finalize actual T1

Pass 2:
search all active liquidity
for nearest valid T2 beyond actual T1
```

The T2 pass requires:

- active liquidity;
- acceptable tier;
- correct side;
- minimum T2 R;
- maximum liquidity R;
- minimum separation beyond finalized T1.

## Input wording

Changed:

```text
Show recent completed entries
→ Show recent entries / results

Recent completed entries to keep
→ Recent entries / results to keep
```

This matches the actual lifecycle because cards exist while ACTIVE and are later updated with outcomes.

## Production-file policy

`ARTHA_V2_Production.pine` is intentionally unchanged until P15.1 is compile- and visually validated.
