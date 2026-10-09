# ARTHA v2 — Release Handoff / Continuation Prompt

## Current status

ARTHA v2 is production-consolidated through P15.

Current production source:

`pine/v2/ARTHA_V2_Production.pine`

Frozen predecessor:

`pine/v2/ARTHA_V2_P15_Production_Consolidation.pine`

Active branch:

`artha-v2-revaluation`

## Stable architecture

```text
Structure
→ Liquidity
→ Relative Displacement
→ Episodes
→ FVG/IFVG
→ Causal OB/BB
→ Unified POI
→ REV/CONT
→ Quality
→ NORMAL/MISS/EARLY
→ Conflict Resolution
→ Risk/Targets
→ Outcomes
```

## Decisions that should remain frozen unless explicitly revisited

- non-repainting confirmed-bar logic;
- only REV and CONT setup families;
- IFVG and BB are POI lifecycle/types, not strategy families;
- divergence is not a standalone setup family;
- VWAP is excluded;
- no strategy() conversion;
- NORMAL > MISS > EARLY;
- RAW is ignored;
- visual toggles must not alter calculations;
- recent result cards default to 4;
- internal risk tracking defaults to 20;
- P13 target-quality filters remain active.

## How to continue

Use the production file as the baseline.

Do not resume from experimental P12.1–P12.5 files.

Any future change should follow:

```text
production file
→ one narrowly scoped change
→ Pine compile
→ visual smoke test
→ validate on NAS100 + XAUUSD + FX
→ freeze only after user confirmation
```

## Recommended next categories

Only pursue these if there is a concrete observed problem:

1. bug fixes;
2. market-specific calibration;
3. alert-message refinement;
4. small execution/display refinements;
5. profiling/resource optimization.

Avoid adding new context engines without evidence that the current causal model is missing something.

## Continuation prompt

Copy this into a new chat:

> Continue the ARTHA v2 TradingView indicator from the production release in the public GitHub repository `katzrams909-dev/ARTHA`, branch `artha-v2-revaluation`. Use `pine/v2/ARTHA_V2_Production.pine` as the only production baseline. P15 is validated and frozen. The architecture is Structure → Liquidity → Relative Displacement → Episodes → FVG/IFVG → Causal OB/BB → Unified POI → REV/CONT → Quality → NORMAL/MISS/EARLY → Conflict Resolution → Risk/Targets → Outcomes. Signal priority is NORMAL > MISS > EARLY; RAW reactions are ignored. P13 target-quality rules are validated. VWAP is excluded, there is no strategy() conversion, and display toggles must never affect calculations. Do not revive the P12.1–P12.5 experimental chain. Work iteratively: make one scoped change, compile in Pine v6, visually validate, then freeze only after confirmation.
