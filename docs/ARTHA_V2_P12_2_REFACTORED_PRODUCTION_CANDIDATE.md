# ARTHA v2 P12.2 — Refactored Production Candidate

P12.1 hit Pine compiler error CE10295 because the script main body exceeded the compiler's size limit.

P12.2 moves the repeated production/analysis signal-marker renderer into `f_signalEntryMarker()`.

Behavior is unchanged:

- Execution mode: compact `▲ R`, `▲ C`, `▼ R`, `▼ C` markers.
- Analysis/Full: verbose BUY/SELL family + quality labels.
- Signal generation, thresholds, cooldowns, risk plans and outcomes are unchanged.

This revision exists specifically to reduce main-body statement count while preserving P12.1 behavior.
