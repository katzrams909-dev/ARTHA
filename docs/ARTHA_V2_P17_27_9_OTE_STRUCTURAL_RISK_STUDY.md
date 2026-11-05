# ARTHA P17.27.9 — Observational OTE Structural Risk Evaluation

## Status
Source and documentation committed to `artha-v2-p17-presets`. **TradingView compilation and runtime verification pending.** P17.27.8.4.1 is the latest user-confirmed working baseline.

## Scope
The user's positive assessment of on-chart OTE A/B/C study entries permits adding risk estimates, **not activating production OTE trades**. P17.27.9 expands candidate marker text at the moment each A/B/C confirmed-bar observation occurs. All production REV/CONT/EARLY/MISS signals, their signal arbitration and managed risk plans are unchanged.

## New setting
Section 14C: `Include hypothetical SL/TP in OTE markers` = ON by default. Requires `Show OTE study entry markers` ON and a candidate that matches the selected marker/source filter.

## Risk snapshot
On each hypothetical OTE A/B/C event:
1. Use the confirmation candle **close** as a hypothetical entry price, explicitly marked `Study @`. No intrabar or next-bar fill is implied.
2. Find an actionable same-direction native FVG/IFVG/OB/BB that currently overlaps the frozen 62–79% Fib zone with existing `f_otePOIIndex`. If unavailable, mark `Risk: NO POI` rather than fabricate an SL or target.
3. Call the existing production `f_planStop()` with `family="CONT"`, `poi.top/bottom`, the current confirmed external protected high/low and existing `riskStopMode` / `stopBufferATR`. **This is explicitly a provisional CONT-style structural stop approximation**, because OTE candidates do not yet have a classified REV/CONT family, associated sweep, or dedicated structural stop attachment.
4. Check stop side, minimum risk, configured max stop-to-ATR bound (`maxStopDistanceATR`, default 3), and the same TP1/TP2 geometry prerequisites used by the native risk plan engine.
5. If checks fail, include the proposed SL and `RISK REJECTED`; do not suppress the candidate marker, and do not create a real plan.
6. If accepted, use the existing fixed-R or legacy liquidity TP1/TP2 policies (including minimum separation, fallback R and active liquidity tiers). Retrieve tentative liquidity TP3/TP4 using the native read-only visual extension helpers and confirmed HTF swing extras. These extensions are **visual**; they do not imply filled positions or planned exits.
7. Show provisional SL, stop distance in ATR, TP1/TP2, optional TP3/TP4 and TP1/TP2 reward-to-risk ratios on the study marker. No return, win/loss or outcome is claimed.
8. Calculations occur only when a confirmed A/B/C event fires and its label is emitted. Existing marker cap and source/model filters are retained.

## Causal and architectural safeguards
- The actual `riskPlans` array is not modified. No OTE orders, production entry labels, trade alerts, expiry changes, position sizing, stage outcomes or strategy conversion.
- The candidate's latest current active overlapping native POI can differ from the one present on its original first touch; therefore the risk snapshot is provisional rather than an immutable POI-linked historical plan. The next integration stage should persist the original POI's `sourceEngine/sourceId` and distinguish an OTE-REV versus OTE-CONT structural stop.
- The existing `f_planStop` has an ATR fallback when the chosen causal stop is on the wrong side. The study uses that same helper and rejects only when the resulting price/distance/targets fail the present risk filters; this is intentionally consistent with production, although future OTE-specific validation may require a stricter structural-origin check.
- No extra chart lines, boxes or long-lived trade management objects are created; only expanded capped marker label text. On a crowded lower timeframe, switch off `Include hypothetical SL/TP in OTE markers` to get compact labels.
- In legacy-liquidity primary targeting, TP1/TP2 can use fallback R targets when no registered active liquidity target passes the native selection rules. TP3/TP4 may be absent, shown as dashes.
- A study entry candidate is not necessarily a tradable entry; this is **risk estimation, not a backtest**.

## Validation
1. Compile P17.27.9. Report first exact TradingView error code/line or compiled-token total if any; commit itself does not verify compilation.
2. Set `Show Auto Fib overlay` ON, `Show OTE study entry markers` ON, `OTE marker model` All and `Include hypothetical SL/TP in OTE markers` ON.
3. Inspect NAS100 15m, BTCUSD 1m/5m, EURUSD 1H. When A/B/C markers fire, confirm quoted entry equals the confirmed signal candle close and the stop lies beyond native POI/protected structure as expected.
4. Verify a candidate with stop greater than 3 ATR reads `RISK REJECTED`; the label still appears. Verify no POI produces `Risk: NO POI`.
5. With `Primary TP1/TP2 model = Fixed R`, check TP1/TP2 equal the configured R multiples. With Legacy liquidity, check registered liquidity and fallback separation rules.
6. Check TP3/TP4 are directional, beyond TP2 and may legitimately be unavailable. Check that none of the targets are misrepresented as executed.
7. Compare production REV/CONT/EARLY/MISS labels and managed risk plans on identical chart data with the P17.27.8.4.1 baseline. They must remain unchanged.
8. Test marker cap, performance and verbosity across timeframes.

## Next
After verifying study calculations, store POI identity at first touch, classify OTE-REV vs OTE-CONT, use the corresponding structural-stop rule, and evaluate independent observational trade outcomes before enabling any production execution.
