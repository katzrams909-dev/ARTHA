# ARTHA v2 P17.1 — Trade Label Lifecycle

## Purpose

Fixes CONT BUY/SELL execution markers that remain visible after their associated trade reaches a TP/SL outcome.

## Behavior

- Each newly created RiskPlan stores the matching execution signal marker.
- Marker association supports compact Execution labels and verbose Analysis/Full labels.
- By default, a CONT marker is removed on the first TP/SL lifecycle event:
  - T1 HIT (first partial take-profit event);
  - T2 HIT;
  - STOPPED;
  - EXPIRED.
- Marker removal is scoped to the specific RiskPlan and does not remove unrelated CONT markers.
- Removed markers are also removed from the bounded signal-label registry.
- A setting under `11 Signal Engine` allows the behavior to be disabled:
  `Remove CONT marker after first TP/SL`.

## Unchanged

P17 calibration presets, signal admission, REV/CONT eligibility, entry prices, stops, targets, outcome attribution, and P16 statistics are unchanged.

Recent entry-result cards remain available. If terminal risk plans are configured to remain visible, those drawings continue to follow the existing `Show terminal risk plans` setting; this change specifically addresses the CONT entry marker.

## Validation target

`pine/v2/ARTHA_V2_P17_1_Trade_Label_Lifecycle.pine`
