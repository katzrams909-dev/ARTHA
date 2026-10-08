# ARTHA v2 P02.1 — Displacement Selectivity Repair

## Why this revision exists

Visual validation of P02 on US30 daily showed excessive displacement density and repeated 90/95 scores on ordinary directional candles.

The cause was the original score curve:

- each component reached maximum points as soon as it reached its minimum threshold;
- Balanced mode only hard-gated body/ATR;
- range, efficiency and close-location could contribute large partial scores without being individually acceptable;
- follow-through only meant two consecutive same-colour candles.

That made the score behave more like a threshold counter than a quality ranking.

## P02.1 changes

### 1. Non-saturating-at-minimum score curve

At the configured minimum threshold a component now receives 50% of its available points.

Full points require a materially stronger target:

- body target: max(1.75 × minimum, minimum + 0.40 ATR)
- range target: max(1.60 × minimum, minimum + 0.50 ATR)
- body-efficiency target: minimum + 0.25, capped at 0.90
- close-location target: minimum + 0.20, capped at 0.98

### 2. Balanced mode now has four hard quality gates

Balanced requires:

- body >= minimum body/ATR
- range >= 85% of configured minimum range/ATR
- body efficiency >= configured minimum
- directional close location >= configured minimum
- score >= minimum score

### 3. Strict mode is materially stricter

Strict additionally requires:

- body >= 1.20 × minimum body threshold
- full configured range threshold
- efficiency >= minimum + 0.05
- close location >= minimum + 0.05
- score >= max(user minimum, 75)

### 4. Follow-through upgraded

Follow-through now requires not merely the same candle direction, but actual extension:

Bullish:
`previous candle bullish AND current close > prior high`

Bearish:
`previous candle bearish AND current close < prior low`

## Expected result

P02.1 should produce visibly fewer DSP events, with scores distributed across a wider range rather than clustering around 90/95.

The objective is not to minimize event count. The objective is for a DSP marker to correspond to a candle that is recognizably impulsive relative to current volatility.
