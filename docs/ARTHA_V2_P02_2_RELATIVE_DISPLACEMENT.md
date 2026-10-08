# ARTHA v2 P02.2 — Relative Displacement

## Trigger for revision

Visual tests on EURUSD and USDJPY daily charts showed that P02.1 was improved but still generated extended runs of DSP markers and too many 90–100 scores.

The remaining problem was conceptual: absolute ATR and candle-shape thresholds can identify a candle as strong even when it is ordinary relative to the instrument's immediately preceding regime.

## P02.2 principle

A displacement candle should be exceptional relative to recent candles.

P02.2 therefore adds:

- body size versus the average body of the prior N candles;
- total range versus the average range of the prior N candles;
- optional requirement that the directional close exits the previous candle's range.

Defaults:

- relative lookback: 20 bars
- body >= 1.25 × prior average body
- range >= 1.10 × prior average range
- close beyond prior candle range: enabled

The current candle is excluded from its own relative baseline.

## Revised quality score

| Component | Max |
|---|---:|
| Body / ATR | 25 |
| Range / ATR | 15 |
| Body efficiency | 15 |
| Directional close location | 15 |
| Body vs recent average | 15 |
| Range vs recent average | 10 |
| Follow-through | 5 |
| Optional volume expansion | +5 bonus, total capped at 100 |

## Balanced qualification

Balanced requires all of:

- directional candle
- absolute body expansion
- minimum range expansion
- minimum body efficiency
- directional close quality
- relative body expansion
- relative range expansion
- close beyond prior candle range when enabled
- minimum quality score

## Expected visual result

DSP events should become discrete impulse bars or short impulse clusters rather than appearing through most directional swings.

This version should be tested on multiple asset classes and timeframes before the displacement definition is frozen.
