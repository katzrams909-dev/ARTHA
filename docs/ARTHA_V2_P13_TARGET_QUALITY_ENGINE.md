# ARTHA v2 P13 — Target Quality Engine

## Scope

P13 refines target selection only.

VWAP is intentionally excluded from the ARTHA v2 roadmap. The current causal framework does not require it, and it would add complexity without solving a current execution problem.

## Problem in P12.7

The target engine selected the nearest two active opposing-liquidity levels regardless of:

- liquidity tier;
- minimum useful reward/risk;
- excessive distance;
- clustering between T1 and T2.

This could generate targets such as 7R–9R simply because no nearer active opposing-liquidity record existed.

## P13 rules

A liquidity target must now satisfy:

1. active liquidity state;
2. correct opposing side;
3. tier at or above the configured quality floor;
4. minimum usable R;
5. maximum liquidity-target R;
6. T2 must be materially separated from T1.

Defaults:

```text
Weakest target tier: 3
Minimum T1: 0.75R
Minimum T2: 1.50R
Maximum liquidity target: 5.00R
Minimum T1/T2 separation: 0.20 ATR
Fallback T1: 1.50R
Fallback T2: 2.50R
```

## Fallback

If no acceptable liquidity level exists, the existing fixed-R fallback is used.

This means distant or weak liquidity no longer forces an unrealistic target.

## T2 ordering

T2 is explicitly required to be beyond T1 in the trade direction.

If the selected T2 is not beyond T1, P13 replaces it with the normal fallback T2.

## Unchanged

- Structure
- Liquidity lifecycle
- Displacement
- FVG/IFVG
- OB/BB
- REV/CONT
- NORMAL/MISS/EARLY signal logic
- stops
- outcome calculation
- recent-entry cards
