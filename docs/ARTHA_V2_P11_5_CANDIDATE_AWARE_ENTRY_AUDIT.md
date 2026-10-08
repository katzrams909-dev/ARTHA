# ARTHA v2 P11.5 — Candidate-Aware Entry Audit

## Problem addressed

P11.4 treated a trend-aligned POI reaction as a missed CONT entry even when ARTHA had never created a CONT candidate. This made the audit overly permissive and cluttered the chart.

## New classification

### TRUE MISS

Requires an active ARTHA candidate at the moment the PLUTUS-style POI interaction begins.

```text
active REV or CONT state
+ POI interaction
+ PLUTUS-style close confirmation
+ no ARTHA eligibility/signal capture
= TRUE MISS
```

Only TRUE MISS events receive the full orange diagnostic label.

### EARLY OPPORTUNITY

No active candidate exists, but recent causal context exists:

REV:
- recent liquidity-sweep context

CONT:
- established external trend
- recent same-direction displacement or BOS context

A confirmed early opportunity gets only a small orange triangle.

It is research evidence, not a missed ARTHA trade.

### RAW REACTION

A POI reacts without an active candidate or recent qualifying causal context.

Raw reactions are counted in diagnostics only and are not plotted.

## State snapshot

P11.5 records the REV/CONT state at the moment the interaction arms.

The miss reason therefore reflects the stage ARTHA had actually reached, even if that state later resets before the reaction confirmation bar.

## True-miss reasons

REV:
- WAIT_SHIFT
- WAIT_POI
- WAIT_RETEST
- REACTION_GATE

CONT:
- WAIT_POI
- WAIT_RETEST
- REACTION_GATE

## Visual policy

- TRUE MISS: full orange label
- EARLY opportunity: small orange triangle
- RAW reaction: no chart object
- audit markers bounded to 30 by default

No upstream eligibility, signal, risk, or outcome logic is changed.
