# ARTHA v2 P02 — Displacement Validation

Target: `pine/v2/ARTHA_V2_P02_DisplacementEngine.pine`

## Compile

- [ ] Pine v6 compiles with zero errors.
- [ ] P01 structure/liquidity behavior remains unchanged.

## Directionality

- [ ] Bull displacement only occurs on bullish candles.
- [ ] Bear displacement only occurs on bearish candles.
- [ ] Doji/neutral candles do not qualify.

## Component measurements

On several manually inspected candles verify:

- [ ] body/ATR is reasonable.
- [ ] range/ATR is reasonable.
- [ ] body efficiency increases for full-bodied candles.
- [ ] bullish close location approaches 1 near candle high.
- [ ] bearish close location approaches 1 near candle low.
- [ ] follow-through only rewards same-direction consecutive candles.
- [ ] volume context can be disabled without changing price components.

## Qualification modes

- [ ] Body only behaves like a simple body/ATR threshold.
- [ ] Balanced rejects weak/inefficient candles despite acceptable direction.
- [ ] Strict is more selective than Balanced.
- [ ] Increasing minimum score reduces event count.

## Structure interaction

Find opposing structure breaks:

- [ ] qualified displacement + opposing break = MSS.
- [ ] opposing break without qualified displacement = CHoCH.
- [ ] displacement without a structural break is recorded as DSP but does not become MSS.
- [ ] same-direction continuation break remains BOS, not MSS.

## Reload / non-repainting

Record several DSP events and scores, reload the chart:

- [ ] event bars remain unchanged.
- [ ] scores remain unchanged.
- [ ] MSS versus CHoCH classification remains unchanged.

## Visual sanity

With displacement markers enabled:

- [ ] markers correspond to confirmed event bars.
- [ ] marker count remains bounded.
- [ ] disabling markers does not affect event counts or structure.

## Exit criteria

P02 passes only when compile, directionality, structure integration, and reload tests all pass. Do not add FVG/IFVG or OB/BB until this gate is cleared.
