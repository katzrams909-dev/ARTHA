# ARTHA v2 P17.27.12 — Multi-Entry Independence / EARLY-to-NORMAL Milestones

## State
New versioned source on `artha-v2-p17-presets`. **TradingView compile/runtime confirmation pending.** P17.27.11.5 is the latest user-confirmed compiling baseline. Previous sources preserved unchanged.

## Scope
The user requested multiple simultaneously active entries on the same chart, each independently managed, plus clear treatment of an EARLY entry that later earns stronger NORMAL confirmation without automatically doubling the position.

Source audit confirmed P17.27.11.5 **already** uses `array<RiskPlan>` and updates each nonterminal plan independently, has a default `Draw only newest active plan = false`, protects live positions during `maxRiskPlans` cleanup (removes terminal plans only) and filters duplicates/conflict using accepted per-direction/family/episode/POI keys. P17.27.12 corrects the UI and upgrade semantics, rather than replacing the working risk manager.

## Implemented

1. **Accurate open-plan dashboard:** scan every tracked risk plan, count all plans with state `ACTIVE` or `PARTIAL` (state < 2), select the **newest still-open** risk plan, not simply the last created record. Show `ACTIVE · P#<id> · <count> OPEN` (or runner/BE management variant). If the latest plan closes while an older plan remains active, the dashboard now displays that older live plan and its independent entry/stop/TPs instead of incorrectly reporting `NO ACTIVE PLAN`.
2. **Visible plan identity:** add `P#<id>` prefix to recent entry/result cards, the risk-plan ENTRY label and separately to SL/TP1/TP2/TP3/TP4 level tags. This allows cross-referencing concurrently visible plans even when they overlap in price/time. Plans retain independent IDs, directions, entry, stop, targets, and outcome state.
3. **Mandatory no-duplicate EARLY -> NORMAL upgrade:** before allowing a NORMAL signal for each of four REV/CONT directions, check whether an **accepted EARLY plan of the exact direction, family, episode and native POI** already exists. If yes, treat this as confirmation of an existing setup **even if the user switched off** generic `One signal per family + episode + POI`. Do not create a second risk plan, modify the original stop/TPs, emit an additional entry alert, or move an earlier label retrospectively.
4. **Confirmation-only markers:** new section 11 toggle `Mark NORMAL confirmation after EARLY (no second plan)` (ON by default). When an existing accepted EARLY setup subsequently qualifies for NORMAL under the existing depth/close/quality rules, emit one small current-bar `NORMAL CONFIRMED ... UPGRADE ONLY · NO NEW PLAN` note. The display is capped at 30 labels; a rolling 120-key ledger prevents repeated notes for one setup. It is not a new trade, fill or strategy execution.
5. **Attribution:** a first genuine NORMAL upgrade does not increment `signalRejectedDuplicate`; other duplicate cases still increment that counter. It is an observational milestone distinct from rejected signals and accepted entries.
6. **Compiled-token stewardship:** remove obsolete, write-only direction-wide `lastBull/BearSignal*`, `lastBull/BearEarlySignal*` and `lastStructuralResetBar` bookkeeping, its now-unused full signal-history reconstruction on each arbitration event, and the no-op risk-rejection rollback tied to those retired variables. Current per-POI accepted-plan admission, the authoritative signal history for scoring, and rejected label dedup remain intact. Resulting source size **234,382 characters**, smaller than P17.27.11.5 despite the enhancements; character size is NOT an exact compiled-token measure.

## Preserved architectural protections
- Multiple **independent accepted setups on different bars** can coexist as separate risk plans. Active plans are not expired because a new plan appears. The max-risk-plans retention setting removes terminal histories only, never a still-open plan just to meet the configured cap.
- The 25%-inside-POI EARLY and 50%-penetration/outside-POI NORMAL with five-bar confirmation remain, as do REV/CONT original structural formation, MISS, risk filters, 3 ATR maximum stop distance, Local causal option, stop/TP1–TP4, and rejected grey diagnostic labels.
- Main signal arbitration still **selects only one winning production signal per bar**. This version does not promise simultaneous independent entries on the *same exact candle*. Adding that requires a dedicated multi-candidate risk-admission engine and alert attribution changes; do not conflate it with independently open positions from distinct bars.
- The main setup dashboard displays a count and the newest active plan's price levels, **not a full per-plan table**; individual charts have P# identifiers.
- `showOnlyLatestActivePlan=true` can still intentionally hide older active drawings. Keep it OFF when reviewing concurrent plans. Recent-entry result count also remains configurable.
- No OTE entry promotion, additional OTE dashboards, HTF Fib changes or lookahead. OTE A/B/C study markers remain observational.

## TradingView verification checklist
1. Compile `pine/v2/ARTHA_V2_P17_27_12_Multi_Entry_Independence.pine`; report exact CE/error and compiled-token total if it fails.
2. Turn `Show entry / stop / targets` ON; `Draw only newest active plan` OFF; `Show ENTRY / SL / T1 / T2 labels` ON and `Mark NORMAL confirmation after EARLY` ON.
3. Find two accepted different native POI/episode setups firing on different candles while first plan is still open. Expect two separate P# identities and independent SL/TP tracking.
4. When the most recently created plan is stopped/completed but an older plan remains open, dashboard should show the older plan's ID, prices and the correct OPEN count.
5. Inspect a previously accepted EARLY whose source POI later reaches 50%+ penetration and directional outside-boundary NORMAL close within the valid 5-bar window. Expect `NORMAL CONFIRMED ... NO NEW PLAN` on the confirmation bar; no additional risk plan or entry alert.
6. Check same-POI duplicate suppression still works even if `One signal per family + episode + POI` is disabled: at least EARLY-to-NORMAL upgrades must not automatically become second positions.
7. Confirm rejected risk labels remain grey and never show an accepted P# plan or create entry alerts. Causal/Local causal and 3-ATR tests remain unchanged.
8. Test BTCUSD 5m, NAS100 15m and USDCHF 1h; verify Pine object limits on crowded charts, historical OTE markers and price labels.
9. Be explicit when the desired test has **two independent signals on one candle**: current arbitration intentionally permits one; record that as the next separate enhancement, not a regression.

## Follow-up
After compilation and multi-plan visual validation, consider (a) deterministic same-bar multi-candidate execution, (b) plan-select UI as space allows, (c) HTF/Major OTE structural scale improvements.
