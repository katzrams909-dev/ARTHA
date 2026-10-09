# ARTHA v2 P16 — Performance Attribution

## Purpose

P16 measures the validated production engine without changing its trading logic.

The questions P16 answers are:

- Does REV or CONT contribute more?
- Do NORMAL, MISS or EARLY signals contribute more?
- Which quality grades are actually productive?
- What are the realized-R and win-rate characteristics of each bucket?

## Baseline

P16 is built from the validated P15.1 production release.

No changes are made to:

- structure;
- liquidity;
- displacement;
- FVG/IFVG;
- OB/BB;
- Unified POI;
- REV/CONT eligibility;
- quality scoring;
- NORMAL/MISS/EARLY qualification;
- conflict priority;
- stop logic;
- target logic;
- outcome logic.

## Persisted plan metadata

RiskPlan now stores:

```text
score
grade
```

at signal creation.

This avoids relying on bounded signal history when a trade closes later.

Score/grade calculation is performed independently of risk-plan drawing visibility.

## Family/source buckets

P16 records realized outcomes into:

```text
REV · NORMAL
REV · MISS
REV · EARLY
CONT · NORMAL
CONT · MISS
CONT · EARLY
```

Each bucket tracks:

- closed realized trades;
- wins;
- losses;
- total realized R;
- average realized R;
- win rate.

Expired plans remain excluded because they have no realized R under the current production outcome model.

## Grade buckets

A second attribution pass records the same realized outcome into:

```text
Grade A
Grade B
Grade C
Grade D
```

This is intentionally independent of family/source so we can test whether the existing quality ranking is predictive.

## Display

Performance attribution is enabled by default.

The optional table is disabled by default to preserve the clean production chart.

When enabled, it displays:

```text
Bucket | Closed | Wins | Loss | Win % | Total R | Avg R
```

The minimum sample input only suppresses premature win-rate display. It does not affect statistics.

## Interpretation rule

P16 is observational.

Do not change thresholds from a handful of trades.

Calibration should require enough samples across multiple market regimes and instruments before modifying production defaults.
