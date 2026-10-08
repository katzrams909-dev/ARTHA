# ARTHA v2 — P03 FVG/IFVG + POI Provenance

## Objective

Introduce imbalance POIs without reverting to feature stacking.

An FVG is a geometric imbalance. A high-quality ARTHA POI is an imbalance with provenance.

P03 therefore tracks both geometry and causality.

## FVG geometry

Bullish FVG:

```text
current low > high[2]
```

Bearish FVG:

```text
current high < low[2]
```

Minimum size is configurable in ATR units.

## Creation modes

### All
Track any geometrically valid FVG.

### Displacement-linked — default
Track only FVGs that can be associated with a same-direction active or recently completed displacement episode.

### Structural
Track only displacement-linked FVGs whose parent episode also produced a structure break.

## Provenance

Each FVG stores:

- originating displacement episode ID;
- displacement episode peak score;
- whether structure broke during the episode;
- structure scope;
- structure kind;
- quality class.

Quality classes:

```text
ORDINARY
DISPLACEMENT
STRUCTURAL
```

These are provenance classes, not trade scores.

## Episode association

A new FVG first attempts to link to the active same-direction episode.

If no suitable active episode exists, P03 searches the most recent completed same-direction episode whose end bar is within the configured provenance window.

Default provenance window: 2 bars.

## Lifecycle

```text
ACTIVE FVG
    ├── confirmed failure beyond far boundary → ACTIVE IFVG
    └── optional full wick traversal → RETIRED

ACTIVE IFVG
    └── invalidation / full traversal → RETIRED
```

The IFVG is the same POI object with an inverted lifecycle state. It is not a separately invented zone.

## Mitigation

Maximum overlap depth is tracked as metadata. Mitigation does not itself create a signal.

## Future contract

REV and CONT engines should consume POI provenance fields rather than select “any recent FVG.”

Examples:

- REV may prefer a STRUCTURAL FVG created by the post-sweep reversal episode.
- CONT may accept a DISPLACEMENT FVG from the established trend's expansion episode.
- IFVG remains a POI lifecycle state, not an independent strategy family.

## Explicit exclusions

P03 adds no:

- Order Block
- Breaker Block
- REV/CONT setup engine
- signal scoring
- risk projection
- trade signal
