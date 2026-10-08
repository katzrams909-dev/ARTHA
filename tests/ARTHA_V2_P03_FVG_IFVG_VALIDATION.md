# ARTHA v2 P03 — FVG/IFVG Provenance Validation

Target: `pine/v2/ARTHA_V2_P03_FVG_IFVG_Provenance.pine`

## Compile

- [ ] Pine v6 compiles with zero errors.
- [ ] P01/P02.2 behavior remains unchanged.
- [ ] P02.3 episode markers/counts remain unchanged.

## FVG geometry

- [ ] Bull FVG only when current low > high[2].
- [ ] Bear FVG only when current high < low[2].
- [ ] Minimum ATR size removes trivial gaps.

## Creation modes

Compare the same chart:

- [ ] All shows the largest FVG set.
- [ ] Displacement-linked shows a subset of All.
- [ ] Structural shows a subset of Displacement-linked.
- [ ] Changing FVG display toggles does not alter counts/lifecycle.

## Provenance

Enable provenance labels:

- [ ] displacement-linked FVG shows an episode ID;
- [ ] STRUCTURAL FVG is linked to an episode with structure break;
- [ ] ORDINARY appears only in All mode;
- [ ] episode ID is stable after reload.

## IFVG lifecycle

For bullish FVG failure:

- [ ] confirmed close/body below lower boundary transitions to bearish IFVG;
- [ ] original zone geometry is preserved;
- [ ] object is not duplicated as a separate unrelated zone.

For bearish FVG failure:

- [ ] confirmed close/body above upper boundary transitions to bullish IFVG.

## Retirement

- [ ] configured full wick traversal retires FVG when no flip occurs;
- [ ] invalidated IFVG retires cleanly;
- [ ] retired box stops extending;
- [ ] max tracked zones is bounded.

## Non-repainting

After reload:

- [ ] FVG birth bars remain unchanged;
- [ ] episode provenance remains unchanged;
- [ ] IFVG transition bars remain unchanged;
- [ ] retired states remain unchanged.

## Exit gate

Do not begin OB/BB work until causal FVG selection and IFVG lifecycle look correct on at least FX and index samples.
