# ARTHA v2 P11.6 — Direction-Aware Audit Validation

Target: `pine/v2/ARTHA_V2_P11_6_Direction_Aware_Entry_Audit.pine`

## Compile
- [ ] Pine v6 compiles without errors.

## Direction
- [ ] bullish EARLY REV requires recent bullish CHoCH/MSS.
- [ ] bearish EARLY REV requires recent bearish CHoCH/MSS.
- [ ] sweep alone cannot assign EARLY REV direction.
- [ ] bullish EARLY CONT requires bullish external trend.
- [ ] bearish EARLY CONT requires bearish external trend.
- [ ] freshest opposite displacement/BOS suppresses stale-direction EARLY CONT.
- [ ] freshest opposite CHoCH/MSS suppresses stale-direction EARLY REV.

## TRUE MISS
- [ ] active candidate direction still takes priority.
- [ ] true-miss state-at-arm reason remains unchanged.

## RAW
- [ ] opposing/stale POI reaction creates no marker.
- [ ] RAW count may increase as incorrect directional markers disappear.

## Visual re-check
- [ ] XAUUSD 5m
- [ ] GBPUSD 5m
- [ ] AUDUSD 5m
- [ ] EURUSD 5m
- [ ] NAS100
