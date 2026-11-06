# ARTHA P17.27.14 — Production OTE Confluence Integration

## Delivery status
- Based on **P17.27.13.1** (last user compile- and chart-validated baseline).
- New independent versioned source: `pine/v2/ARTHA_V2_P17_27_14_Production_OTE_Confluence.pine`.
- Static source inspection completed; **TradingView compilation and chart outcomes remain pending**.
- The removed hypothetical OTE A/B/C study engine is **not** restored.

## Design decision
This is the **first, bounded production OTE integration**: OTE is an optional confirmation/admission gate on the **existing** qualified REV/CONT EARLY, NORMAL or MISS event. It is **not yet a standalone additional OTE signal trigger**, not another entry family, and not an automatic second position.

The selected signal's direction, family, episode, native POI engine/ID, accepted-only duplicate/admission ledger, trend/structure gating, stop, target geometry, TP1–TP4, alert and independent trade lifecycle stay canonical.

## New Section 14C inputs
- `Production OTE confluence` default **Off**:
  - **Off**: no OTE check at risk admission; P17.27.13.1 execution behavior retained.
  - **Annotate**: when the existing signal is risk-accepted and recent confirmed Fib/native POI OTE confluence exists, add `OTE HTF` / `OTE MAJ` / `OTE MIN` / `OTE BRK` to its existing production entry reason and current plan summary; no change to execution eligibility.
  - **Require**: the same qualified REV/CONT EARLY/NORMAL/MISS candidate must additionally pass the OTE confluence test **before RiskPlan admission**; otherwise `OTE NO CONFLUENCE`. Rejected signals do not create RiskPlans or entry alerts; existing grey rejection diagnostics may show this reason.
- `Production OTE scale` default **Major + HTF**; choices **Minor**, **Major**, **HTF**, **Major + HTF**, **All**, **Structural Breaks**. Production source selection does not depend on whether Auto Fib overlays are displayed.
- `Production OTE maximum bars after first touch` default **5**, range 1–20. The matching OTE Fib's **first observed post-confirmation touch** must be within this many chart candles (count includes signal candle).

## Causality and confluence
- Existing confirmed Minor, Major, HTF and Structural Break Fib archives remain the sole source of Fib geometry; no developing/unconfirmed HTF values.
- Add `firstTouchBar` to archived range UDT and populate it **only on the first candle that touches the 62–79% Fib zone after the range's original confirmation**.
- OTE production match requires **all**:
  - The Fib was confirmed **before** the production signal bar (`confirmedAt < bar_index`).
  - Fib direction matches existing signal direction.
  - Fib's first touch occurred when a native same-direction POI was registered (`qualifiedTouch`).
  - Its touch timestamp is known (`firstTouchBar` is non-`na`), and first touch is within the configured recent-bar window.
  - Fib retracement price band strictly overlaps the **particular native POI** already selected for the production signal.
- Historic Fib records already touched **before** their pivot confirmation remain flagged `touched=true`, but have no valid `firstTouchBar`; they are **ineligible for newly invented production confirmations**.
- Archive invalidation logic still removes failed structural Fib levels. The native POI must still exist at risk admission; no synthetic POI is constructed.
- For overlapping accepted sources, attribution prioritizes **HTF**, then **Major**, **Minor**, **Structural Breaks** (according to the selected production scale); one existing plan only.
- OTE is evaluated at production risk admission **after Fib archive maintenance on that bar**. This does not backdate entries, labels or HTF information.

## Important bounds
- **Require** mode can reduce accepted trade count because it is an additional confluence condition; changing to Require is deliberately opt-in. It cannot create a trade on its own when the base REV/CONT EARLY/NORMAL/MISS criteria are absent.
- The first touch must overlap a qualifying live native POI, and the existing selected POI must overlap that Fib band at signal time. The minimal implementation records first-touch confluence as a **boolean**, not the full first-touch POI ID, so overlapping same-direction native POIs are not yet disambiguated by historical first-touch source. Exact per-POI first-touch tagging is a future refinement.
- An accepted EARLY entry and subsequent NORMAL confirmation from the same POI/episode continue to use the P17.27.12 no-second-plan rule, including when the OTE mode is enabled.
- Selected fib scale is independent of the visible `Auto Fib anchor source`; chart overlay configuration does not unexpectedly alter live risk admission.
- Historical already-accepted trades are recalculated when the user changes modes, as with any Pine indicator input.
- The same-bar single-winner arbitration still applies; separate multi-candidate execution requires another major architectural change.

## Preserved
- Default 3-ATR structural stop cap, Causal/Local causal stops, native POI gate and TP1–TP4.
- Independent active risk plans, plan IDs, last-open-plan dashboard, realized trade results, rejected marker diagnostics.
- Causal, close-confirmed EARLY/NORMAL/MISS and REV/CONT architecture.
- HTF pivots with fully offset prior-completed `request.security` data, Minor/Major/HTF/Structural Fib overlays and source selection, all prior-version files.

## TradingView validation plan
1. Compile P17.27.14. If **CE10117** returns, report precise compiled token count (100,256 limit). Also report any **CE10295** main-body limit or syntax/typing errors.
2. On USDCHF 1H, keep `Production OTE confluence = Off`; verify accepted/rejected base signals and SL/TP match P17.27.13.1. Leave Fib display enabled for comparison.
3. Switch to `Annotate`: accepted trades stay the same, but recent confirmed Major/4H OTE+native POI overlaps should show `OTE MAJ` or `OTE HTF` on existing entry tags. No extra entries/alerts.
4. Switch to `Require`: only qualifying previously detected production signals remain risk-admitted; other signal candidates show `OTE NO CONFLUENCE`. Check that base 3-ATR limit still rejects an oversized stop **before** the OTE reason appears.
5. Validate exact first-touch window with 1 vs 5 vs 15 chart bars; older zone touches must not qualify. Previously pre-confirmation-touched HTF ranges must not qualify.
6. Test original native POI IDs and continuity: an early-accepted entry must not be duplicated by later NORMAL upgrade, regardless of confluence.
7. Compare Minor/Major/HTF/Structural Breaks, plus no-display Auto Fib overlay OFF; observational overlay should not affect execution.
8. Check independent P# trades, TP3/TP4 and grey risk labels across USDCHF 1H, BTCUSD 5m and USDCAD 5m.

## Follow-on scope
Once compilation and risk-mode comparison pass, consider exact first-touch native POI identity, production OTE-only setup eligibility (using the same REV/CONT structure/stop/target pipeline), and same-candle independent multi-POI arbitration. Any addition must respect Pine's compiled-token ceiling.
