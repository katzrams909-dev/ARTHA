# ARTHA v2 P12.6 — Lean Reaction Signals

## Why this build exists

P12.5 was accidentally truncated during the CE10295 refactor. P12.6 is rebuilt from the complete P12.4 source.

The permanent audit layer is removed. Its useful execution behavior is retained as an alternate reaction-signal path.

## Signal paths

```text
Normal REV / CONT
        │
        ├──────────────→ execution signal
        │
POI reaction
        │
        ├─ MISSED ─────→ execution signal
        ├─ EARLY ──────→ execution signal
        └─ RAW ────────→ ignored
```

## MISSED signal

A MISSED reaction requires an already-bound ARTHA candidate POI:

- REV candidate in ARMED/RETEST;
- CONT candidate in ARMED/RETEST;
- exact source engine + POI ID match;
- confirmed reaction;
- no normal signal already captured;
- family quality threshold;
- duplicate and cooldown checks.

## EARLY signal

An EARLY reaction requires:

- a primary actionable POI;
- recent same-direction causal context;
- REV: recent CHoCH/MSS;
- CONT: external trend aligned + recent displacement/BOS;
- reacting POI has an episode ID;
- confirmed reaction;
- configurable minimum score (default 65);
- duplicate and cooldown checks.

EARLY does not require an already-armed ARTHA candidate. It is the deliberate fast-entry path.

## RAW

A POI reaction without candidate or recent causal context is ignored.

## Removed

P12.6 removes the permanent audit/reporting subsystem:

- MISS labels;
- EARLY triangle markers;
- RAW counters;
- audit counters;
- audit diagnostic table rows;
- large diagnostic table/counting section;
- research/production runtime profile;
- engine-event alert clutter.

The normal chart modes and execution display remain.

## Downstream

MISSED and EARLY signals enter the same existing pipeline as normal signals:

```text
signal
→ risk / targets
→ outcome tracking
→ persistent recent-entry history
```

## Pine-size goal

Removing the diagnostic table and audit display layer materially reduces the main executable body and is intended to resolve CE10295 without truncating the indicator.
