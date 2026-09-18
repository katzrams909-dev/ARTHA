# ARTHA P04.0 — Session Engine Validation

## Objective

Validate a standalone, non-repainting session engine for Asia, London and New York before integration with ARTHA context and signal logic.

## Session contract

```text
SESSION CLOSED
      ↓
first in-session bar
      ↓
SESSION ACTIVE
      ↓
track high + low
      ↓
last in-session bar closes
      ↓
SESSION CLOSED
      ↓
completed H/L may remain as historical context
```

The engine calculates session state independently of display settings. P04.0 does not generate trade entries.

## Required TradingView tests

1. **Timezone** — test Exchange, UTC and at least one named regional timezone; confirm boundaries move with the selected timezone.
2. **Asia** — verify open/close boundary and high/low tracking; levels stop changing after close.
3. **London** — verify independent high/low tracking and clean close boundary.
4. **New York** — verify independent high/low tracking and clean close boundary.
5. **Overlaps** — London/New York overlap must not corrupt either session's independent H/L.
6. **Completed levels** — completed H/L lines stop at the last in-session bar and do not extend indefinitely.
7. **Renderer independence** — hide/show each session and levels; diagnostic/session state must continue updating identically.
8. **Realtime/non-repainting** — monitor candles around boundaries, then reload and verify completed H/L and session transitions remain stable.
9. **Bounded objects** — set maximum completed sessions per region to 1 or 2; verify old lines/labels are deleted.
10. **Timeframes** — test 1m, 5m, 15m and 1h, especially bars overlapping a configured session boundary.
11. **No signal leakage** — P04.0 exposes session state/H-L lifecycle and open/close alerts only; it must not produce entry signals.

## Integration gate

Do not proceed to Premium/Discount or HTF/MTF bias until P04.0 passes the TradingView tests above, especially timezone, overlap, boundary and realtime reload tests.
