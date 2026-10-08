# ARTHA v2 P03.2 — Primary FVG Family Validation

Target: `pine/v2/ARTHA_V2_P03_2_PrimaryFVGFamilies.pine`

## Compile

- [ ] Pine v6 compiles with zero errors.
- [ ] P03.1 FVG/IFVG lifecycle remains unchanged.

## Family grouping

On an episode that creates multiple FVGs:

- [ ] all candidates retain the same episode ID;
- [ ] exactly one active family member is marked PRIMARY;
- [ ] remaining family members are SECONDARY;
- [ ] default display hides secondaries;
- [ ] enabling Show secondary FVGs reveals them.

## Ranking

For selected multi-FVG episodes:

- [ ] primary candidate is closest in birth bar to episode peak DSP bar;
- [ ] equal-distance candidates choose larger gap/ATR;
- [ ] family assignment remains stable after reload.

## Lifecycle independence

- [ ] primary and secondary zones each track mitigation separately;
- [ ] FVG → IFVG transitions preserve primary/secondary metadata;
- [ ] retirement of one family member does not mutate sibling geometry.

## Chart clutter

Compare P03.1 vs P03.2:

- [ ] P03.2 shows materially fewer active boxes by default;
- [ ] visible zones still correspond to the strongest representative imbalance of each episode.

## Exit gate

Do not begin OB/BB until primary-family behavior is visually coherent and stable.
