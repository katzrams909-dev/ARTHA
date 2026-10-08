# ARTHA v2 P05 — Unified POI Engine

## Objective

Provide one downstream interface for all validated POI families without duplicating source-engine logic.

P05 does not detect new zones.

It normalizes the current state of:

- FVG
- IFVG
- OB
- BB

into one read-only registry.

## Source ownership

Native engines remain authoritative:

```text
Imbalance engine
    FVG ↔ IFVG lifecycle

Order Block engine
    OB ↔ BB lifecycle

Unified POI engine
    read-only normalized view
```

A lifecycle transition in the native engine automatically changes the POI type and actionable direction exposed by P05.

## UnifiedPOI schema

Each active POI exposes:

- source engine
- stable native source ID
- current POI type
- current actionable direction
- top
- bottom
- birth bar
- episode ID
- parent FVG ID where applicable
- primary flag
- displacement score
- structure-linked flag
- structure scope
- structure kind
- mitigation percentage

## Direction normalization

The current actionable direction is normalized after inversion:

```text
Bull FVG  -> +1
Bear FVG  -> -1
Bear FVG converted to bull IFVG -> +1
Bull FVG converted to bear IFVG -> -1

Bull OB   -> +1
Bear OB   -> -1
Bear OB converted to bull BB -> +1
Bull OB converted to bear BB -> -1
```

Downstream engines therefore do not need type-specific inversion logic.

## Registry lifecycle

The registry is rebuilt from active native objects after source engines update each bar.

This avoids synchronization bugs and duplicate lifecycle ownership.

Native source IDs remain stable across rebuilds.

## Family policy

By default, secondary FVG family members are excluded.

Input:

`Include secondary FVG family members`

allows diagnostics but future REV/CONT engines should consume primary POIs by default.

## Lookup helper

P05 introduces a nearest-directional-POI lookup.

It is diagnostic infrastructure only and does not create setup eligibility.

## Architectural contract

REV/CONT should consume `UnifiedPOI` objects rather than separately querying:

- imbalanceZones
- orderBlocks

This is the API boundary between POI detection and setup construction.
