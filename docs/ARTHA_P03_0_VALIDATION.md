# ARTHA P03.0 — Order Block / Breaker Validation

## Objective

Validate a standalone, non-repainting Order Block / Breaker Block lifecycle before integrating it with the unified ARTHA engine.

## Lifecycle contract

```text
confirmed displacement + structure break
              ↓
      opposite candle candidate
              ↓
          ACTIVE OB
              ↓
     mitigation threshold
              ↓
        MITIGATED OB
              ↓
 confirmed close through far side
              ↓
           BREAKER
              ↓
 confirmed close back through
 the source OB near boundary
              ↓
         INVALIDATED
```

An OB or breaker is context only. P03.0 does not issue entries.

## Required TradingView tests

1. Bullish OB: confirmed bullish structural break; most recent confirmed bearish candle before the break is selected.
2. Bearish OB: mirror case using the most recent confirmed bullish candle.
3. No unconfirmed lifecycle transitions: realtime wick penetration must not permanently change state; reload history and compare.
4. Mitigation: threshold changes OB to MITIGATED; mitigation alone does not create a breaker.
5. Breaker conversion: bullish OB requires confirmed close below its lower boundary; bearish OB requires confirmed close above its upper boundary. Wick alone is insufficient.
6. Breaker invalidation: bullish-origin bearish breaker requires confirmed close back above original upper boundary; bearish-origin bullish breaker requires confirmed close back below original lower boundary.
7. Renderer independence: visibility toggles must not change diagnostic counts or lifecycle state.
8. Bounded objects: set maximum tracked zones to 5 and verify old zones/objects are deleted.
9. Body-vs-wick mode: test both zone definitions and verify lifecycle boundaries follow the selected definition.
10. No signal leakage: P03.0 must only provide OB/breaker lifecycle events and alerts, not entry signals.

## Integration gate

Do not proceed to the Session Engine until all tests above pass on TradingView and the P03.0 lifecycle contract is explicitly accepted.
