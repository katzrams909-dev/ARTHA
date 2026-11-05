# ARTHA P17.27.11.3 — Remove OTE Dashboard (CE10117)

## Report and scope
P17.27.11.2 generated **100,926** compiled tokens, exceeding TradingView's **100,256** limit by **670**. The user explicitly requested removal of the OTE dashboard.

P17.27.11.3 is a new versioned file based on P17.27.11.2. It removes:
- The `oteFibStatusTable` top-center six-row table allocation.
- `f_renderFibStatus()` and its last-bar invocation.
- Display-only `f_oteReactionStage()` and `f_oteCandidateStatus()` helpers.
- Four no-longer-used dashboard switches: OTE POI eligibility status, OTE reaction status, three-path comparison, and Auto Fib status.

## Preserved
- The three Fib archives (Minor, Major, Structural Break), OTE lifecycle updates, invalidation/extension and graphical Fib overlays.
- On-chart OTE A/B/C candidate study labels and hypothetical SL/TP.
- All normal REV/CONT and EARLY/MISS entry logic from P17.27.11.2.
- Accepted-plan-scoped duplicate/cooldown handling and historical risk-rejected marker diagnostics from P17.27.11.1.
- The separate ARTHA setup dashboard, which was **not** the OTE dashboard requested for removal.
- Prior source versions and other repository documents.

Source length decreased from 237,073 to 232,938 characters (4,135 characters). **This does not establish a particular reduction in compiled Pine tokens; a new TradingView compilation is required.**

## Testing
1. Compile `pine/v2/ARTHA_V2_P17_27_11_3_No_OTE_Dashboard.pine` and report compile success or the remaining CE10117 compiled-token count.
2. Ensure the top-center OTE status table is absent. Do not confuse it with the bottom-right/main ARTHA SETUP dashboard.
3. Verify user-configured OTE Fib overlays, A/B/C labels and study risk annotations still appear when qualified.
4. Inspect USDCAD 5m near the orange arrow in the screenshot for gray `REJECTED` label. A risk rejection is not a live executed trade.
5. Confirm no change to stop filter, risk plan admission, TP1–TP4 or the signal classification.
