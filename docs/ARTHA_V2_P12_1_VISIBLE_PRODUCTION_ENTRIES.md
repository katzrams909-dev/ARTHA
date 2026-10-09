# ARTHA v2 P12.1 — Visible Production Entries

## Problem

P12 Production + Execution mode suppressed verbose BUY/SELL signal labels.

Because terminal risk-plan drawings are also removed by default, historical charts could appear to contain no entries even though P09 signals were emitted.

## Fix

Execution mode now retains a compact permanent marker for each actual P09 signal:

```text
▲ R  bullish REV
▲ C  bullish CONT
▼ R  bearish REV
▼ C  bearish CONT
```

These markers are stored in the existing bounded signal-label registry.

Analysis and Full modes continue to use the verbose labels:

```text
BUY REV · Q84 B
SELL CONT · Q78 B
```

## Important

P12.1 changes presentation only.

It does not modify:

- REV/CONT eligibility
- quality scores
- P09 signal thresholds
- duplicate/cooldown logic
- P10 risk geometry
- P11 outcomes
