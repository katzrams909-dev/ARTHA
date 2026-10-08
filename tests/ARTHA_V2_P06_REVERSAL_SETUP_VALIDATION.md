# ARTHA v2 P06 — Reversal Setup Validation

Target: `pine/v2/ARTHA_V2_P06_Reversal_Setup_Engine.pine`

## Compile

- [ ] Pine v6 compiles with zero errors.
- [ ] P01–P05 native engine behavior remains unchanged.

## Bullish REV sequence

For selected bullish candidates:

- [ ] sell-side liquidity sweep creates SWEEP state;
- [ ] ordinary bullish displacement without CHoCH/MSS does not advance;
- [ ] bullish displacement + CHoCH/MSS advances to SHIFT;
- [ ] bound episode ID matches the displacement episode;
- [ ] same-episode bullish UnifiedPOI advances to ARMED;
- [ ] arming bar does not count as retest;
- [ ] later zone overlap advances to RETEST;
- [ ] configured bullish reaction creates one REV Eligible event.

## Bearish REV

Verify symmetric behavior for buy-side sweep and bearish shift.

## Causality

- [ ] BOS alone cannot qualify REV;
- [ ] POI from a different episode cannot be bound;
- [ ] secondary FVG is not selected by default;
- [ ] nearest/preference logic only chooses among valid same-episode POIs.

## Invalidation

- [ ] sweep window expiration resets candidate;
- [ ] shift-to-POI expiration resets candidate;
- [ ] retest timeout resets candidate;
- [ ] POI retirement resets candidate;
- [ ] POI inversion resets candidate;
- [ ] opposite structure break resets candidate when enabled.

## Reaction modes

- [ ] Directional close is looser;
- [ ] Midpoint reclaim is more selective;
- [ ] failed reaction does not create eligibility.

## Non-repainting

After reload:

- [ ] state transitions occur on the same historical bars;
- [ ] eligibility markers remain on the same bars;
- [ ] bound episode and POI IDs remain stable.

## Exit gate

Do not add scoring or signals yet. Validate REV behavior across index and FX samples first.
