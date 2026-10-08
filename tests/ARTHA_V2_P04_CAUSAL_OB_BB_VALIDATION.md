# ARTHA v2 P04 — Causal OB/BB Validation

Target: `pine/v2/ARTHA_V2_P04_Causal_OB_BB.pine`

## Compile

- [ ] Pine v6 compiles with zero errors.
- [ ] P01–P03.2 behavior remains unchanged.

## OB causality

For several visible OBs verify:

- [ ] every OB has a displacement episode ID;
- [ ] its episode produced a structure break;
- [ ] its episode has a primary structural FVG;
- [ ] origin candle is opposite direction to the impulse;
- [ ] origin candle occurs immediately before the episode within search depth;
- [ ] one episode does not create duplicate same-direction OBs.

## Geometry

- [ ] Wick mode uses full origin candle high/low.
- [ ] Body mode uses origin candle body.
- [ ] Zone does not move after creation.

## Breaker transition

Bullish OB:

- [ ] close below OB lower boundary does not become BB without opposite DSP when requirement is enabled;
- [ ] close below + bearish DSP transitions same object to bearish BB.

Bearish OB:

- [ ] close above + bullish DSP transitions same object to bullish BB.

## Lifecycle

- [ ] mitigation depth updates independently from lifecycle;
- [ ] OB/BB lines/boxes stop when retired;
- [ ] BB preserves original episode/FVG provenance;
- [ ] no separate duplicate Breaker zone is created.

## Display

With provenance enabled:

- [ ] OB text contains EP, FVG and structure kind;
- [ ] BB retains the same provenance;
- [ ] display toggles do not affect calculations.

## Non-repainting

After reload:

- [ ] OB origin bars remain unchanged;
- [ ] episode/FVG provenance remains unchanged;
- [ ] BB transition bars remain unchanged;
- [ ] retired states remain unchanged.

## Exit gate

P04 does not advance until causal origin selection and Breaker transitions are visually coherent on index and FX samples.
