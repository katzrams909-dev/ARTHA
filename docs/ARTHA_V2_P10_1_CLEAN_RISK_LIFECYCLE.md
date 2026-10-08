# ARTHA v2 P10.1 — Clean Risk Lifecycle

## Problem

P10 created risk lines with identical start/end coordinates and `extend.right`.
That produced excessive persistent horizontal objects and could render vertical artifacts.

## Fix

Risk plans now use finite `xloc.bar_time` segments with `extend.none`.

The right edge is updated only while the plan remains active.

Default maximum tracked plans is reduced from 12 to 4.

Terminal plans are hidden by default.

## Lifecycle

```text
ACTIVE
├─ T1 hit → T1_HIT
├─ T2 hit → T2_HIT / terminal
├─ stop hit → STOPPED / terminal
└─ max age → EXPIRED / terminal
```

After T1, the plan remains active for stop/T2 tracking.

When a plan becomes terminal, its right edge is frozen at `terminalTime`.
With terminal visibility disabled, its line/label objects are deleted immediately.

## Conservative same-bar precedence

When stop and target are both touched within the same bar:

```text
STOP takes precedence
```

This avoids optimistic outcome assumptions without intrabar sequencing data.

## Visual policy

Default:

- active plans only
- maximum tracked plans: 4
- no infinite extensions
- no zero-length extended lines
- one compact plan label
- historical terminal plans hidden

P10.1 changes presentation/lifecycle only. It does not change P09 signals or the P10 stop/target calculation model.
