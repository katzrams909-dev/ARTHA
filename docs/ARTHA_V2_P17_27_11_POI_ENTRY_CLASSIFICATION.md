# ARTHA v2 P17.27.11 — POI Entry Classification

## Status
Committed on branch `artha-v2-p17-presets`. **TradingView compilation and chart validation pending.** Last user-confirmed compiled version: P17.27.10. This is a production entry-eligibility change. No previous file overwritten.

## Problem
- P17.27.10 allowed EARLY on a confirmed directional close **outside** the FVG/POI. This failed to distinguish lower-confidence inside-zone reaction from a fully reclaimed zone.
- Normal REV/CONT pathways did not strictly require 50% POI penetration, a close outside the entry-facing boundary, or a short confirmation deadline.
- Existing MISS selection could claim a setup-armed POI before its qualifying inside-zone EARLY response was considered.
- User also wants independent simultaneous plans and more significant OTE swings; **both are separate next-stage work** (P17.27.12 and P17.27.13), not silently bundled into this classification change.

## New defaults under 14 Reaction Entries
- `NORMAL · Minimum POI penetration %`: **50%**, configurable 15–100%.
- `NORMAL · Max candles after retest`: **5**, configurable 1–10. The touch/retest candle is included as bar zero; confirmation must occur by +5 bars.
- `EARLY · Quality score discount`: **5** points, configurable 0–20.
- Existing EARLY 25% minimum, wick-or-body basis and minimum 0 bars after touch remain.
- Removed the misleading EARLY alternate close selector because all EARLY candidates now obey the same mandatory inside-favorable-half geometry.

## Definitions

### EARLY
- Valid recent REV/CONT context or matching armed REV/CONT setup, active native same-direction POI, user-configured penetration (default 25%), confirmed favorable-direction candle, minimum close-location threshold.
- **Bullish**: close in **[midpoint, top]** (inside or on the favorable half of FVG/POI); **bearish**: close in **[bottom, midpoint]**.
- No close outside the favorable zone boundary. First valid touch candle is eligible.
- Subtract configurable 5 points from reaction score before threshold/grade determination (clamp >=0); no blanket waiver of existing quality, trend, dedup, frequency, signal-admission or trade risk checks.
- Preserves one existing EARLY label and its POI penetration/real-body-or-wick notation.

### NORMAL
- Valid original setup formation remains mandatory: sweep + shift episode for REV, established trend + qualified impulse for CONT.
- Source POI continues to be identified by engine and ID; directional validity, opposite shift/break and retest deadlines retained.
- As soon as the retest begins, accumulate a boolean `DepthReady` if a **confirmed candle** penetrates at least the configured depth (default 50%) of the live zone. This can be the initial touch candle or a subsequent candle.
- A **confirmed directional close beyond the entry-facing boundary** within 5 bars after first POI contact is required, not merely a midpoint reclaim.
- Bull NORMAL: green candle closing **above POI top**; bear NORMAL: red candle closing **below POI bottom**.
- No extra displacement event is required at **execution**; original formation displacement/structural qualification remains.
- If no valid reclaim by the specified deadline, the setup's current retest state resets. This is independent of the longer arm-to-retest timeout.
- A matching already-admitted EARLY record may cause NORMAL to be duplicate-suppressed by existing one-signal-per-family/episode/POI policy. There is **no automatic second same-setup trade** in this version.

### MISS
Existing MISS 50% penetration and independent close confirmation continue, except a confirmed inside-zone 25%-depth interaction on an armed setup is now classified EARLY instead of being forced into MISS.

## Architectural constraints and limitations
- The code does **not** yet make multiple independent simultaneous signals immune to the 6-bar direction-wide admission conflict. Those changes and same-setup EARLY→NORMAL upgrade policy belong in P17.27.12.
- The code does **not** change Minor/Major Auto Fib defaults or introduce HTF structural Fib. Those changes belong in P17.27.13.
- The existing normal REV/CONT reaction mode inputs remain in the UI for backward layout compatibility, but this version's classification gates require boundary reclaim irrespective of those prior modes.
- If the live POI retires or inverts after first contact, the ongoing normal setup is invalidated by existing logic.
- As in the existing engine, risk-plan creation occurs after signal arbitration; being eligible does not guarantee a plan will be accepted.

## Validation
1. **Compile** `ARTHA_V2_P17_27_11_POI_Entry_Classification.pine` in Pine v6. Send compiler code and first line for failures, or confirm compilation.
2. Bull EARLY: at least 25% penetration, green candle with quality close, **close between FVG midpoint and top** on same bar. No EARLY should be issued for close above top or below midpoint.
3. Bear EARLY: mirrored from bottom toward midpoint. No EARLY if close below bottom or above midpoint.
4. Normal REV/CONT: confirmed 50% depth on retest or subsequent candle plus **close beyond the correct boundary**, within the configured five-bar window.
5. Test setups that reach 50% but only close within zone: eligible EARLY may fire, but NORMAL must wait for a later outside reclaim (or expire).
6. Test setups that never penetrate 50%: no NORMAL, even if later candle closes directionally beyond edge.
7. Confirm scores: EARLY reaction scores reduced by 5 points before minimum score and grade; NORMAL setup scores retain their original quality formula.
8. Inspect duplicate suppression, one-entry-per-POI admission, pre-existing active risk plans, TP1–TP4, stop placement, and MISS behavior against P17.27.10.
9. OTE markers remain observational and based on existing Minor/Major/Break archives; no new production OTE trade plans.
10. Compare signal density on BTCUSD 5m, NAS100 15m and EURUSD 1h to the previous checkpoint.

## Next milestones
P17.27.12 — independent simultaneous entries and explicit EARLY-to-NORMAL upgrade semantics. P17.27.13 — major/HTF OTE swing scale and causal structure confirmation.
