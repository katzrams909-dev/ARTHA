# ARTHA v2 P17 — Calibration Presets

## Purpose

P17 keeps one causal ARTHA engine while allowing market-sensitive thresholds to differ by instrument family.

Available presets:

```text
Default
Indices
Gold
FX
Custom
```

P16 performance attribution remains available so the presets can be evaluated empirically.

## Important principle

Presets do not change the meaning of:

- pivots;
- BOS / CHoCH / MSS;
- liquidity tiers;
- FVG geometry;
- IFVG lifecycle;
- causal OB / BB logic;
- Unified POI;
- REV / CONT state-machine definitions;
- NORMAL / MISS / EARLY priority;
- stop model;
- outcome model.

Only calibration thresholds change.

## Default

Default reproduces the validated P15.1/P16 behavior exactly.

## Candidate presets

These are initial conservative candidates, not claimed optimized values.

### Indices

Designed for faster, noisier index movement.

Key tendencies:

- slightly stronger relative displacement requirement;
- moderately shorter setup windows;
- EARLY threshold increased;
- reaction sweep allowance modestly wider;
- maximum liquidity target reduced to 4.5R.

### Gold

Designed for XAUUSD's wickier reaction behavior.

Key tendencies:

- strongest displacement selectivity of the initial presets;
- slightly larger minimum FVG;
- shorter setup windows;
- higher normal and EARLY score floors;
- wider reaction sweep allowance;
- tighter maximum target envelope.

### FX

Designed for lower-volatility, often smoother major-FX movement.

Key tendencies:

- lower normalized displacement floors;
- smaller FVG minimum;
- longer setup windows;
- slightly lower signal thresholds;
- longer causal-context window;
- tighter liquidity clustering and T1/T2 separation.

## Active preset parameters

P17 currently presets:

- swing clustering tolerance / ATR;
- displacement body / ATR;
- displacement range / ATR;
- body efficiency;
- close location;
- displacement score floor;
- body vs recent average;
- range vs recent average;
- minimum FVG / ATR;
- REV timing windows;
- CONT timing windows;
- REV signal score floor;
- CONT signal score floor;
- maximum liquidity target R;
- minimum T1/T2 separation;
- reaction close-location floor;
- maximum POI sweep allowance;
- recent reaction-context window;
- EARLY score floor.

## Universal parameters

Not preset-controlled:

- pivot strengths;
- previous D/W/M logic;
- liquidity tier definitions;
- episode gap/duration;
- FVG creation mode;
- IFVG / BB flip definitions;
- POI inclusion rules;
- reaction confirmation mode;
- risk stop mode;
- minimum T1/T2 R floors;
- conflict priority/window;
- outcome model.

These remain manual/universal because changing them would alter architecture or because current evidence does not justify market-specific treatment.

## Custom mode

Custom uses the visible `Custom · ...` inputs.

In every other preset those custom values are ignored.

## Calibration workflow

Use P16 attribution inside P17 to compare presets on the same market and timeframe.

Do not optimize from a handful of trades.

Preferred comparison dimensions:

- closed sample count;
- total R;
- average R;
- win rate;
- REV/CONT balance;
- NORMAL/MISS/EARLY balance;
- grade distribution.
