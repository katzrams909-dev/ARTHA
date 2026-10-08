# ARTHA v2 P11.4 — Missed Entry Audit Validation

Target: `pine/v2/ARTHA_V2_P11_4_Missed_Entry_Reaction_Audit.pine`

## Compile

- [ ] Pine v6 compiles without errors.
- [ ] P01–P11.3 behavior remains unchanged.

## Non-invasive contract

- [ ] audit ON/OFF does not change REV eligibility count.
- [ ] audit ON/OFF does not change CONT eligibility count.
- [ ] audit ON/OFF does not change P09 signal count.
- [ ] risk/outcome plans remain unchanged.

## Reaction classification

For bullish and bearish examples:

- [ ] clean touch without far-boundary sweep = REJECTION.
- [ ] bounded far-boundary sweep + reclaim = SWEEP_RECLAIM.
- [ ] IFVG/BB touch = FLIP_RETEST.

## Timing

- [ ] same-bar confirmation works when enabled.
- [ ] disabling same-bar requires later confirmation.
- [ ] 1-bar window expires sooner than 2/3-bar windows.
- [ ] pending interaction disappears if native POI retires/inverts.

## Captured vs missed

- [ ] existing ARTHA eligibility inside audit window counts as captured.
- [ ] existing P09 signal inside window counts as captured.
- [ ] no ARTHA capture produces one missed-entry event.
- [ ] missed event does not create a risk plan.

## Miss reasons

Verify visible cases for:

- [ ] WAIT_SHIFT
- [ ] WAIT_POI
- [ ] WAIT_RETEST
- [ ] REACTION_GATE
- [ ] NO_ACTIVE_REV_STATE / NO_ACTIVE_CONT_STATE where applicable.

## Requested chart review

Re-check:

- [ ] GBPUSD 5m
- [ ] AUDUSD 5m
- [ ] EURUSD 5m
- [ ] NAS100 sample

Record which miss reason dominates before changing ARTHA's permanent entry logic.
