# ARTHA v2 P02.3 — Episode Validation

Target: `pine/v2/ARTHA_V2_P02_3_DisplacementEpisodes.pine`

## Compile gate

- [ ] Pine Script v6 compiles with zero errors.
- [ ] P02.2 DSP markers remain visually unchanged.

## Episode aggregation

With both DSP and episode markers enabled:

- [ ] isolated DSP bar creates one episode;
- [ ] consecutive same-direction DSP bars aggregate into one episode;
- [ ] one allowed non-DSP gap does not split the episode;
- [ ] a gap larger than the configured allowance closes the episode;
- [ ] opposite-direction DSP closes the current episode and starts the opposite episode;
- [ ] maximum duration prevents an episode from running indefinitely.

## Episode metadata

For selected episodes verify:

- [ ] start bar = first DSP bar;
- [ ] end bar = last qualifying DSP bar;
- [ ] peak bar corresponds to the highest DSP score;
- [ ] event count matches the number of qualifying DSP bars;
- [ ] high/low span covers the impulse episode;
- [ ] structure metadata is retained when BOS/CHoCH/MSS occurs during the episode.

## Non-repainting

After reload:

- [ ] completed episode start/end bars remain unchanged;
- [ ] peak score/bar remain unchanged;
- [ ] episode count remains unchanged;
- [ ] P02.2 DSP bar qualification remains unchanged.

## Exit gate

Do not begin P03 until episode aggregation behaves consistently across FX and index daily charts.
