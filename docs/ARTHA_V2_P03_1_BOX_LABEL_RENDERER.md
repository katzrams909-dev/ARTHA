# ARTHA v2 P03.1 — FVG/IFVG Box Label Renderer

## Issue

P03 used one separate Pine `label` object per imbalance zone. ARTHA already uses labels for:

- liquidity records;
- structure events;
- DSP markers;
- displacement episode markers.

That made FVG text unnecessarily dependent on the global label-object budget and visually detached the text from the POI zone.

## Repair

P03.1 removes the separate imbalance label object.

FVG/IFVG text is now rendered directly inside its `box` using box text properties.

Examples:

```text
FVG
FVG · DISPLACEMENT · EP42
FVG · STRUCTURAL · EP57
IFVG · STRUCTURAL · EP57
```

when provenance display is enabled.

## What does not change

- FVG geometry
- creation mode
- episode provenance
- quality class
- IFVG transition logic
- mitigation lifecycle
- retirement logic
- counts and diagnostics

This is a renderer-only repair.
