# ARTHA v2 P03.2 — Primary FVG Families

## Purpose

A single displacement episode can create several geometrically valid FVGs. Those gaps are related evidence from one impulse, not several independent institutional setups.

P03.2 groups episode-linked FVGs into a family and designates one canonical Primary FVG.

## Family key

A family is defined by:

- displacement episode ID;
- FVG direction.

Ordinary FVGs without an episode ID are not grouped.

## Primary selection

When a new FVG joins an episode family:

1. Prefer the FVG born closest to the episode's peak displacement bar.
2. If equally close, prefer the larger gap relative to ATR.

All family members share the same episode-level structural provenance, so structure class is not used to distinguish siblings inside the same family.

## Lifecycle

Primary/secondary designation is metadata only.

Every family member still maintains its own:

- FVG geometry;
- mitigation;
- FVG → IFVG transition;
- retirement state.

If the primary later retires, P03.2 does not automatically promote a secondary. Promotion policy will be evaluated separately because automatic promotion could reintroduce stale POIs.

## Display

Default:

- Primary FVG/IFVG: visible.
- Secondary FVG/IFVG: hidden.
- All secondary objects remain tracked internally.

Input:

`Show secondary FVGs`

enables family inspection.

With provenance enabled labels show:

```text
FVG · DISPLACEMENT · EP727 · PRIMARY
FVG · DISPLACEMENT · EP727 · SECONDARY
```

## Downstream contract

Future setup engines should consume only `primary=true` imbalance POIs by default.

Secondary family members may later contribute quality metadata but should not independently create setup candidates.
