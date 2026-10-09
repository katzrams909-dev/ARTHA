# ARTHA v2 P12.5 — Adaptive Entry Engine

## Purpose

P12.5 converts selected P11.x TRUE_MISS events into real ARTHA entries.

The PLUTUS-style reaction does not create a setup by itself. It is an alternate confirmation path for an already active ARTHA REV or CONT candidate.

## Promotion contract

A reaction becomes a valid adaptive entry only when all conditions are true:

1. audit classification is TRUE_MISS;
2. reaction is confirmed;
3. no normal same-direction capture occurred in the reaction window;
4. active candidate is already bound to a POI;
5. audit POI engine + source ID exactly match the candidate POI;
6. direction matches candidate direction;
7. adaptive quality score meets the normal family threshold;
8. normal duplicate suppression passes;
9. normal directional cooldown passes.

EARLY and RAW never become trades.

## Candidate states allowed

REV:
- ARMED
- RETEST

CONT:
- ARMED
- RETEST

WAIT_SHIFT / WAIT_POI / IMPULSE are not promotable because no exact candidate POI is yet established.

## Quality

Adaptive entries use the same P08 quality components:

REV:
- displacement
- reversal structure
- POI
- mitigation
- initiating liquidity tier

CONT:
- displacement
- BOS
- POI
- mitigation
- trend context

The normal P09 minimum score thresholds still apply.

## Downstream behavior

Once promoted, the adaptive entry enters the existing pipeline:

```text
adaptive confirmation
→ P09-equivalent signal record
→ P10 risk / targets
→ P11 outcome tracking
→ persistent recent-entry card
```

## CE10295 refactor

P12.5 moves repeated risk-plan visual lifecycle code into:

- f_clearRiskPlanVisuals()
- f_hidePriorActiveRiskVisuals()
- f_refreshRiskPlanVisuals()
- f_trimRiskPlans()

This reduces Pine main-body size without changing risk math.

## Production behavior

Adaptive entries are ON by default.
The visual missed-entry audit remains Research-only.

Thus a promotable event should appear as a normal ARTHA entry, not an orange MISS label.
