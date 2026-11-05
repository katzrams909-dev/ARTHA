# ARTHA v2 P17.27.10 — EARLY POI Touch-and-Close Refinement

## Status
Source versioned on `artha-v2-p17-presets`. **TradingView compilation and behavioral regression pending.** Last user-confirmed working baseline: P17.27.9.

## Reason for change
The production adaptive EARLY reaction path in P17.27.9 required at least one additional bar after the first POI interaction (`earlyMinBarsAfterTouch=1`) and shared a 50% POI penetration threshold with MISS. That delayed some otherwise valid directional rejections. The user requested confirmed entry on the touching candle with 25% minimum POI penetration by wick or body.

## Settings, section 14 Reaction Entries
- `EARLY · Minimum bars after POI touch`: **0** default; configurable 0–3. Zero permits the first completed qualifying touch/rejection bar.
- `EARLY · Minimum POI penetration`: **25%** default; options 15/25/50/75/100%.
- `EARLY · POI penetration source`: **Wick or body** default; alternatives **Wick only** (wick qualifies but body does not), **Body only** (body reaches threshold).
- `EARLY · Confirmed touch candle close`: **Directional rejection** default, alternatives **Midpoint reclaim**, **Boundary reclaim**. All three require directionally aligned close location and do not allow a close through the adverse POI boundary.
- The existing `MISS · Required POI fill` retains **50%** default, options 15/25/50/75/100 and sweep. The existing MISS confirmation/window and same-bar behavior remain unchanged.

## Technical implementation
- `f_earlyPenetrationPct(dir,top,bottom,bodyOnly)`: measures wick penetration from the entry-facing edge, or penetration of the candle's open-to-close body via `min(open,close)` for bullish POIs and `max(open,close)` for bearish POIs. Clamps the reported minimum at 0%; a move past the far boundary can exceed 100%, while the displayed label caps at 100%.
- `f_earlyFillReached`: requires candle/zone intersection plus configured minimum percentage and basis.
- `f_earlyTouchClose`: requires a completed directionally aligned candle (green for bull, red for bear), existing configurable minimum close-location quality, and an adverse-boundary safety check; optional stricter midpoint or entry-boundary reclaim.
- `f_auditInteractionPOI`: first tests whether a native POI corresponds to an existing armed REV/CONT setup (MISS). Applies the unchanged MISS penetration gate to that case; otherwise uses the new EARLY gate. The original setup-family classification uses actual recent structural context. `RAW` (no valid context) remains suppressed.
- EARLY confirmation on the current bar requires the live native POI still matching its source ID and direction, the live price penetrating the zone to threshold **on this same confirmation bar**, and a directional close satisfying `f_earlyTouchClose`. This avoids confirming a different, non-touching later candle as the EARLY event.
- Original duplicate prevention, score thresholds, opposite signal admission, early-repeat suppression, trend filter, native risk-stop/target admission, and single family signal arbitration remain in place.
- The existing single EARLY signal label is annotated with its source POI type, percentage and `WICK` or `BODY` provenance; no second label is created. The corresponding status text also includes penetration metadata.
- All entry events are still evaluated on `barstate.isconfirmed`; there is no unconfirmed candle signal and no lookahead.

## Architectural boundaries
- This is an **actual production EARLY pathway change**, not an observational-only OTE update. It can increase EARLY signals, change which signal wins arbitration, and consequently change production `riskPlans` relative to P17.27.9. That difference is intended and must be reviewed before adoption.
- Existing normal REV/CONT impulse formation gates are unchanged; their own POI retest/confirmation logic remains unchanged. Existing MISS behavior retains its prior threshold and signal confirmation.
- The new penetration computation is candle-based (including current active POI bounds). Native mitigation/inversion/retirement still govern POI eligibility.
- Wick-only option means **only the wick** reaches threshold (not the real body); for a wick-or-body inclusive rule, retain the default.
- Body-only qualifies only if the real body penetrates the threshold (and the candle intersects the POI); its directional rejection close is still mandatory.
- No changes to OTE A/B/C candidate observations, Fibonacci lifecycle, observational OTE SL/TP1–TP4, or their marker logic.

## Validation checklist
1. **Compile** `ARTHA_V2_P17_27_10_EARLY_POI_Touch_Close.pine` in TradingView Pine v6. Report any code/line compiler errors or compiled-token count.
2. Use the default `EARLY Minimum bars=0`, `EARLY penetration 25%`, `Wick or body`, `Directional rejection`. On BTCUSD 5m, NAS100 15m, EURUSD 1h, inspect whether an EARLY signal is anchored on the completed first qualifying touch candle.
3. Compare an actual penetration between 25 and 49.9%: candidate should be eligible for EARLY but not for default 50% MISS. Note that an eligible reaction may still be excluded by score, priority, trend, duplicate, or risk-plan gates.
4. Verify bullish signal requires bullish directional close, bearish signal requires bearish directional close; closes beyond the POI's adverse boundary must not trigger EARLY.
5. Switch penetration to 50%, minimum bars to 1 to approximate earlier EARLY strictness; note the earlier close behavior was independently controlled by `Close confirmation`, so this is not byte-for-byte identical to P17.27.9.
6. Test `Body only` versus `Wick only` with a 25% wick / shallow body touch and with a body that penetrates at least 25%.
7. Check `Midpoint reclaim` and `Boundary reclaim` remain stricter close-confirmation options.
8. Confirm each admitted EARLY entry has exactly one label showing FVG/IFVG/OB/BB penetration info, and trade risk/target visuals still obey the existing independent risk-plan architecture.
9. Compare production normal REV/CONT and MISS signals against P17.27.9, accounting for expected arbitration conflicts from newly admitted EARLY signals.
10. Confirm no new OTE production entries are introduced.

## Next
Evaluate signal frequency, time-to-entry, SL distance and subsequent returns against P17.27.9 on identical markets/settings before making further production-gate changes.
