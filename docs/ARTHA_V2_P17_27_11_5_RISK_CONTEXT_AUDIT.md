# ARTHA P17.27.11.5 — USDCHF Risk Context Audit

## Status
Based on **P17.27.11.4**, observed on user's USDCHF OANDA 1-hour screenshots (November 2026). **TradingView compilation and runtime verification for P17.27.11.5 remain pending**. Versions before P17.27.11.5 remain untouched.

## Screenshot observations
- Multiple grey `CONT BUY · EARLY/MISS` risk rejection labels explicitly report approximately 6–8 ATR stops, versus the default maximum of 3 ATR.
- At least one green CONT BUY EARLY label reports TP achieved: production trades have been admitted and resolved, not all signals are missing.
- The ARTHA setup dashboard displays `NO ACTIVE PLAN` in the captured latest state; that is consistent with an absence of currently open accepted positions and doesn't invalidate historical outcomes.
- Multiple historical observational OTE A/B/C labels report `Risk: NO POI` although they identify a previously qualified FVG. The risk function checks whether a matching actionable same-direction POI is **still live when a later candidate confirmation prints**, which can differ from the original touch context.

## Root causes verified from source
1. `f_planStop("CONT",...)` with stop model `Causal` uses the farther of the native POI invalidation boundary and **confirmed external protected high/low** (`xProtectedLow/High`) plus configured ATR buffer. In extended directional trends, the external structure can be multiple ATR away; the strict 3-ATR stop gate then correctly rejects.
2. Historical grey rejection labels are appended for each new rejected attempt, because only **accepted** plans populate the duplicate-suppression ledger. Identical setup/source can therefore create multiple grey labels, while legitimate retries should remain eligible.
3. Risk plan acceptance in P17.27.11.4 did not explicitly require a live native POI index: if a source had retired or inverted, the stop helper had a fallback that could produce a synthetic short risk distance. That is now guarded.
4. OTE study risk evaluates active confluence again at the candidate confirmation bar; missing current registry isn't proof the original OTE first touch was invalid.

## Changes
- Section 12 Stop model offers new **`Local causal`** option, **not default**. It uses the confirmed internal protected low/high (`iProtectedLow/High`) as the context for CONT stop construction **only when that level lies beyond the native POI's adverse invalidation boundary**. Otherwise the POI edge + original `stopBufferATR` is used. This preserves an explicit invalidation basis and the 3-ATR maximum; it does **not** fabricate stop placement at a chosen fixed ATR distance.
- The original `Causal`, `POI edge` and `Protected swing` options remain available and default remains **Causal**. Under `REV`, the existing sweep-price-versus-POI-edge causal stop remains protective; `Local causal` does not override the reversal sweep rule.
- The OTE study risk branch reflects selected `Local causal` for CONT-like hypothetical stops; its labels remain observation only and have no production influence.
- Explicit `pidx>=0` is now required for risk-plan acceptance. Missing POI produces `NO ACTIVE POI` rather than risk-helper fallback admission.
- Grey rejected labels are capped to **one historical diagnostic label per direction + family + episode + POI source engine/ID + entry source (EARLY/NORMAL/MISS)** over the last 120 unique rejection keys; duplicates are deleted, but candidates are **still reevaluated on every occurrence**, so later legitimate risk-accepted retries are not suppressed.
- A qualified historical OTE candidate lacking a currently actionable POI reports `Risk: POI NOT LIVE`, while an unqualified one still reports `Risk: NO POI`. This is display-only precision, not a reclassification.

## Guardrails
- 3 ATR maximum stop, stop-side and TP1/TP2 geometry checks unchanged.
- Existing EARLY 25%-inside-half, NORMAL 50%-outside-boundary and five-bar, MISS rules, REV/CONT formation and arbitration preserved.
- Existing `riskPlans`, TP1–TP4, independent ongoing trade management and historical OTE Fib archives preserved.
- **There is no guarantee the Local causal alternative improves performance**. A nearer POI-based invalidation can generate more accepted entries but also be stopped out more frequently. It must be reviewed using historical chart examples before adopting as default.

## Validation
1. Compile P17.27.11.5; report exact compiler error/line or token count if CE10117.
2. Load USDCHF 1h screenshot periods and switch section 12 `Stop model` between **Causal** (unchanged original baseline) and **Local causal**. Compare accepted/rejected counts, stop distances and actual SL placement on the same price history, not just number of green labels.
3. Check grey labels only appear once per distinct setup/source; a later valid retry must still produce an accepted trade plan despite earlier grey rejection.
4. Confirm default 3 ATR maximum remains; `Local causal` never chooses a stop inside the original adverse POI boundary. For REV, confirm sweep-derived stops remain protective.
5. Verify green TP-results remain, OTE A/B/C study markers persist, the top-center OTE dashboard remains removed, and missing active POI cannot become an admitted trade via fallback stop.
6. Inspect other instruments (BTCUSD 5m, USDCAD 5m, NAS100 15m) before using a new default.

## Pending architecture
P17.27.12 independent simultaneous plans and explicit EARLY-to-NORMAL upgrade semantics; subsequent POI-linked OTE first-touch persistence and major/HTF structural OTE improvements.
