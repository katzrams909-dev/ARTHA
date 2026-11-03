# ARTHA v2 P17.23.1 — HTF Clean View

**Status:** Committed, not TradingView compiled or replay-validated. P17.22.2 is compile-confirmed and visual box endpoints were validated; P17.23 compilation was not confirmed.

## Why this version exists
The user's NAS100 5m screenshot showed multiple overlapping imported HTF FVGs, historical END rectangles, source-labelled OB candidate boxes, and native 5m zones obscuring price action. Visual filters should not alter liquidity or entry calculations.

## Change
- HTF Clean View (03A) defaults ON. It restricts HTF FVG rectangles to the selected `POI source timeframe` (15m when source=15m, 1H when source=60, or custom HTF). The other 15m/1H overlay is not shown even if its independent display switch is enabled.
- HTF OB/BB candidate overlay defaults OFF, because its source detector has not achieved exact native ARTHA OB parity. Registry and HTF source calculations remain intact.
- Candidate parity audit table defaults OFF to reduce screen obstruction.
- `Show historical filled / retired HTF zones` defaults OFF. The HTF FVG preview renderer deletes its finished rectangle and records the stopped source-origin to prevent redrawing it. The HTF OB/BB registry deletes hidden completed drawings while retaining the zone state.
- FVG historical cap lowered from 12 per timeframe to 4. HTF OB/BB registry retained-record cap lowered from 24 to 8. Users can increase both if needed.
- 1H overlay switch defaults OFF when Clean View is disabled; when Clean View is ON and source=1H, the source 1H FVG overlay still shows.
- No changes made to native 5m zone drawings, native REV/CONT, HTF FVG admission, source snapshots, structural SL or managed TP1–TP4.

## Limitations
- Clean View selects one source timeframe, but does NOT yet merge overlapping native 5m and imported HTF 15m boundaries into one confluence rectangle. Such price-level deduplication requires an explicit provenance-aware rule and regression checks.
- Source HTF OB/BB candidates remain simplified preview zones and not independently eligible for trade plans.
- Hidden historical HTF boxes are intentionally not displayed even though the zone history and terminal states can remain in memory.
- The P17.19.1 session line patch is still skipped.

## TradingView checks
1. Compile P17.23.1; report exact line and error if it fails.
2. Set NAS100USD chart 5m and POI source 15m. Keep HTF Clean View ON, HTF candidate overlay OFF, historical filled HTF zones OFF.
3. Verify fewer imported HTF drawings and no redundant 1H layer; native 5m FVG/IFVG/OB/BB still display and end at existing mitigation rules.
4. Temporarily turn Clean View OFF and re-enable HTF candidate overlay to compare with P17.23. Ensure overlay controls alone do not alter native REV/CONT and HTF FVG entries or risk plans.
5. Validate completed HTF FVG rectangles don't reappear after subsequent 5m bars; track limited source-origin history.
