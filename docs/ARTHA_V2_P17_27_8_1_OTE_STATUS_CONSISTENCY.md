# ARTHA P17.27.8.1 — OTE Status Consistency

## Evidence
User provided four P17.27.8 screenshots:
- BTCUSD 5m, NAS100USD 1D, DE30EUR 1D, EURUSD 1D.
- All displayed Auto Fib price levels and a green `READY` status, yet the individual `MINOR POI` and `MAJOR POI` rows read `NO RANGE` and `OTE REACTION` was `WAITING`.
- This does **not** prove an OTE entry is eligible. `READY` represented Fib display availability, **not** POI eligibility.

## Change
- P17.27.8.1 is a versioned dashboard-only patch based on P17.27.8; older files remain unchanged.
- Explicitly select the source archive once in `f_renderFibStatus()` and compute `primaryCount`, drawing availability, POI status and reaction stage from that source. Avoid separately passing archive arrays through ternary expressions into observation helpers.
- `f_oteCandidateStatus` and `f_oteReactionStage` now accept the selected `OTEShadowRange` record directly.
- The dashboard uses the explicit label `FIB DISPLAY — READY` or `FIB DISPLAY — NO RANGE` so Fib visibility is not mistaken for a valid POI-qualified setup.
- In `Both` mode, the primary status is Minor, with the Major POI row derived from the Major archive only when Major has at least one record. `READY` means one or both Fib scales has available drawings, so a single scale can legitimately say NO RANGE; both scales saying NO RANGE with READY needs further investigation.
- Reaction remains the latest record in the primary archive (Minor in Both mode), not a summary of all records or all historical setups.

## NOT changed
No changes to Fib anchors, invalidation, pre-touch extension, POI lifecycle, post-touch reaction logic, REV/CONT/EARLY/MISS, structural stops or TP1–TP4. No production OTE entries.

## Validation
1. Compile P17.27.8.1 in TradingView and provide the exact error code/line if any. The GitHub commit does not establish compilation.
2. On the same four charts, compare `FIB DISPLAY`, `MINOR POI`, `MAJOR POI` and `OTE REACTION`. Check the `MJ n / MN n` counts displayed in the top row.
3. If the counts are both zero, `FIB DISPLAY` must report NO RANGE. If a source has one or more entries, its POI row must resolve to NO POI, POI READY, TOUCH + TYPE, or TOUCH / NO POI.
4. WAITING may be normal: it only means the latest selected source has not passed the qualified OTE touch → rejection → confirmation → retest pathway.
5. Confirm the original FVG/IFVG/OB/BB zones, Auto Fib lines, entry signals, structural SL and TP1–TP4 visually match P17.27.8.

## Caveat
The screens alone cannot prove that specific POIs overlap the *current latest* Fib band: a visible FVG elsewhere on the chart is not sufficient. Visual setups must be evaluated against the latest selected range and the actual positive-width overlapping zone.
