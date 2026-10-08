# ARTHA v2 P07 — Continuation Setup Validation

Target: `pine/v2/ARTHA_V2_P07_Continuation_Setup_Engine.pine`

## Compile

- [ ] Pine v6 compiles with zero errors.
- [ ] P01–P06 behavior remains unchanged.

## Bullish CONT

- [ ] external trend is already bullish before trigger;
- [ ] qualified bullish displacement occurs;
- [ ] bullish BOS occurs when BOS requirement is enabled;
- [ ] CHoCH/MSS trigger bar does not qualify CONT;
- [ ] candidate binds to same-episode bullish primary UnifiedPOI;
- [ ] arming bar cannot count as pullback;
- [ ] later POI overlap advances to RETEST;
- [ ] configured bullish reaction creates one CONT Eligible event.

## Bearish CONT

Verify symmetric behavior in an already bearish trend.

## Trend integrity

- [ ] new bullish CHoCH cannot instantly create bullish CONT;
- [ ] new bearish CHoCH cannot instantly create bearish CONT;
- [ ] Internal + External mode requires both pre-existing trends aligned;
- [ ] loss of required trend invalidates active candidate.

## BOS requirement

With Require same-direction BOS enabled:

- [ ] displacement without BOS does not create IMPULSE state;
- [ ] BOS without qualified displacement does not create IMPULSE state.

With requirement disabled:

- [ ] qualified displacement in established trend can create candidate;
- [ ] CHoCH/MSS exclusion still remains.

## POI causality

- [ ] selected POI has same episode ID;
- [ ] selected POI direction matches CONT direction;
- [ ] secondary FVG does not bind by default;
- [ ] retired/inverted POI invalidates candidate.

## REV / CONT separation

- [ ] reversal sequences produce REV but are not automatically CONT;
- [ ] continuation sequences do not require liquidity sweep;
- [ ] BOS is continuation confirmation, CHoCH/MSS is reversal confirmation.

## Non-repainting

After reload:

- [ ] CONT state transitions remain on same bars;
- [ ] eligibility markers remain on same bars;
- [ ] episode and POI IDs remain stable.

## Exit gate

Do not add setup scoring until REV and CONT both pass behavioral validation.
