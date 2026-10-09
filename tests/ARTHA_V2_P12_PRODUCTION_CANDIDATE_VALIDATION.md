# ARTHA v2 P12 — Production Candidate Validation

Target: `pine/v2/ARTHA_V2_P12_Production_Candidate.pine`

## Compile
- [ ] Pine v6 compiles with zero errors.

## Default production presentation
On first load:
- [ ] Runtime profile = Production.
- [ ] Display mode = Execution.
- [ ] diagnostic panel is hidden.
- [ ] missed-entry audit markers are absent.
- [ ] ENTRY / SL / T1 / T2 remain readable.
- [ ] chart does not regress into line/label clutter.

## Engine parity
Against P11.6 using identical engine settings:
- [ ] structure events unchanged.
- [ ] liquidity lifecycle unchanged.
- [ ] FVG/IFVG lifecycle unchanged.
- [ ] OB/BB lifecycle unchanged.
- [ ] REV eligibility counts unchanged.
- [ ] CONT eligibility counts unchanged.
- [ ] quality scores unchanged.
- [ ] P09 signal counts unchanged.
- [ ] P10 risk geometry unchanged.
- [ ] P11 outcomes unchanged.

## Runtime profile isolation
Production:
- [ ] audit does not run.
- [ ] changing audit-specific settings cannot change core signal results.

Research:
- [ ] audit can be enabled.
- [ ] TRUE MISS / EARLY / RAW behavior matches P11.6.
- [ ] enabling audit does not change core eligibility/signals.

## Non-repainting / reload
- [ ] setup bars stable after reload.
- [ ] signal bars stable after reload.
- [ ] risk levels stable after reload.
- [ ] outcomes stable after reload.

## Cross-market smoke test
- [ ] EURUSD
- [ ] GBPUSD
- [ ] AUDUSD
- [ ] XAUUSD
- [ ] NAS100
- [ ] SPX500

## Object lifecycle
- [ ] no bar-index distance runtime errors.
- [ ] no vertical joins/artifacts.
- [ ] terminal risk plans clean up correctly.
- [ ] arrays remain bounded on long histories.

## Exit gate
If P12 passes, treat it as the consolidated ARTHA v2 production candidate. Further changes should be targeted revisions, not new architectural layers.
