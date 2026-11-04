# ARTHA P17.27.7 — Mandatory Native POI Confluence (Observation Only)

## Status
New versioned source on `artha-v2-p17-presets`; **TradingView compilation and visual validation pending**. P17.27.6.1 is the user-confirmed working baseline.

## Goal
Implement the mandatory POI requirement for any *future* executable OTE entry candidate, without enabling OTE entries. A Fib without native POI overlap remains a visualization, not a valid executable setup.

## Native eligibility source
The existing `unifiedPOIs` registry is rebuilt by `f_rebuildUnifiedPOIs` before the OTE evaluator executes. Its source state filters only include `ImbalanceZone.state < 2` (active FVG or active inverted FVG) and `OrderBlockZone.state < 2` (active OB or active breaker BB). Direction is converted to current **actionable** direction after inversion, and existing POI family toggles are respected. P17.27.7 reads this registry without creating, reclassifying or retiring native zones.

## Eligibility criteria
1. Fibonacci range is active and valid under P17.27.6.1 lifecycle rules.
2. There is a native actionable POI whose current direction matches Fib direction.
3. There is a **positive-area intersection** with the 62–79% Fib zone: `poi.top > ote.bandBottom` and `poi.bottom < ote.bandTop`. Merely sharing a boundary is insufficient.
4. POI must have existed **before the current evaluation candle** (`poi.bornBar < bar_index`). Same-candle birth/touch sequencing is ambiguous in chart-timeframe OHLC; it fails closed.
5. When an untouched Fib qualifies on the current closed candle, `poiOverlap` flags current readiness. On the **first actual OTE band touch**, the presence of an eligible POI is frozen in `qualifiedTouch` and its type in `matchedPOIType`. A POI becoming available later cannot retroactively qualify an earlier no-POI touch.
6. For an already-touched Fib, `qualifiedTouch` is historical first-touch evidence, *not* a guarantee that the POI remains active now. `poiOverlap` is reevaluated each confirmed bar and can become false if a native POI retires, inverts or no longer intersects the band.
7. Existing confirmed range 100% invalidation, new-extreme extension before first touch, post-touch freeze and retained archive limits are unchanged.
8. Confluence is tracked independently for Minor, Major and Structural Break Fib archives. The observation-only OTE source registry remains distinct.

## User-facing UI
The existing top-center Auto Fib status panel shows a small extra row when `Show OTE POI eligibility status` is enabled (default ON):
- `NO RANGE`: no retained Fib for selected source.
- `NO POI`: range exists but currently lacks mandatory actionable overlapping native POI.
- `POI READY`: range remains untouched and currently has confluence.
- `TOUCH + FVG` / `TOUCH + IFVG` / `TOUCH + OB` / `TOUCH + BB`: the first confirmed Fib band touch had same-direction, pre-existing active POI.
- `TOUCH / NO POI`: the first touch lacked eligible confluence, and must not later become a qualified past touch.
For `Both` scale, minor and major rows are shown independently.

## Scope protections
- No production OTE entry labels, orders, additional risk plans or modifications to REV/CONT/EARLY/MISS.
- No changes to native POI lifecycle, mitigation or inversion rules.
- No changes to SL, TP1–TP4 or performance attribution.
- No reintroduction of midpoint shadow statistical audits.
- No arbitrary numerical signal score or synthetic confluence.

## Validation matrix
1. Compile P17.27.7 and report exact Pine error code/line if any. Prior CE10235 type mismatch was addressed in P17.27.6.1; this version keeps compatible lifecycle branches.
2. Turn Auto Fib overlay and status ON. Compare Minor, Major and Both.
3. Fib + same-direction active FVG/IFVG/OB/BB with positive 62–79% overlap: `POI READY` before touch and `TOUCH + TYPE` after first touch.
4. Fib with no POI, opposite-direction POI, touching boundaries only or retired POI: `NO POI` before touch or `TOUCH / NO POI` after touch.
5. Newly born POI on the touch candle does not qualify. A subsequently born POI cannot retrospectively upgrade a recorded no-POI touch.
6. Native POI inversion must be evaluated under its **new** direction; pre-inversion direction must not qualify.
7. Native POI retirement must remove present readiness; touch history remains historical evidence, not a live status.
8. Validate no changes in original native FVG/OB/BB visuals, REV/CONT entry classification, SL, TP1–TP4 and existing risk plans compared with P17.27.6.1.

## Future stages
P17.27.8: causal post-OTE reaction and entry confirmation candidates; observation first.
P17.27.9: integrate validated OTE candidate and risk management into existing production architecture subject to explicit testing.
