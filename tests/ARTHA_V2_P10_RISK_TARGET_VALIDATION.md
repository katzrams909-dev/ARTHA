# ARTHA v2 P10 — Risk & Target Validation

Target: `pine/v2/ARTHA_V2_P10_Risk_Target_Engine.pine`

## Compile

- [ ] Pine v6 compiles with zero errors.
- [ ] P01–P09 signal behavior remains unchanged.

## Signal independence

- [ ] every P09 signal creates one P10 plan;
- [ ] changing stop model does not change signal count;
- [ ] changing target settings does not change signal count;
- [ ] projected R:R does not suppress a P09 signal.

## Entry

- [ ] entry equals confirmed signal-bar close.

## REV causal stop

Bullish REV:
- [ ] stop is below sweep/POI structural invalidation;
- [ ] ATR buffer is outside that level.

Bearish REV:
- [ ] symmetric behavior.

## CONT causal stop

Bullish CONT:
- [ ] stop uses protected external low / POI causal invalidation.

Bearish CONT:
- [ ] stop uses protected external high / POI causal invalidation.

## Alternative stop models

- [ ] POI edge uses far POI boundary;
- [ ] Protected swing uses external protected swing;
- [ ] missing protected swing falls back safely;
- [ ] stop is never emitted on the profit side of entry.

## Liquidity targets

Bull:
- [ ] T1 is nearest active buy-side liquidity above entry;
- [ ] T2 is second-nearest active buy-side liquidity.

Bear:
- [ ] symmetric sell-side behavior below entry.

## Fallback targets

- [ ] missing T1 uses configured T1 R multiple;
- [ ] missing T2 uses configured T2 R multiple;
- [ ] disabling liquidity targets uses R fallbacks.

## R:R

- [ ] RR1 = abs(T1-entry) / abs(entry-stop);
- [ ] RR2 = abs(T2-entry) / abs(entry-stop);
- [ ] diagnostics match plotted levels.

## Object lifecycle

- [ ] plan lines use time-based coordinates;
- [ ] no bar-index distance runtime error;
- [ ] old plans are deleted after max visible count.

## Exit gate

Do not add position sizing or strategy orders until stop and target geometry is visually validated across index, FX, and metal samples.
