# ARTHA v2 P11.3 — Consolidated Entry Tag

## Objective

Reduce overlap around the signal bar by making the ENTRY tag the primary execution summary.

## ENTRY tag

The entry label now contains:

```text
CONT BUY · Q82 B
ENTRY  30854.2
OB#977 · EP1012
```

This consolidates:

- setup family
- direction
- quality score
- quality grade
- entry price
- bound POI type / ID
- displacement episode ID

SL, T1 and T2 remain separate right-edge labels.

## Display hierarchy

### Execution mode

Suppresses redundant:

- REV/CONT eligibility markers
- BUY/SELL signal marker text

The consolidated ENTRY tag is the primary execution marker.

### Analysis / Full

Retains eligibility and signal markers for diagnostic inspection.

## Logic

No eligibility, quality, signal, risk, target, or outcome calculations are changed.
