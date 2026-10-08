# ARTHA v2 P09 — Signal Engine Validation

Target: `pine/v2/ARTHA_V2_P09_Signal_Engine.pine`

## Compile

- [ ] Pine v6 compiles with zero errors.
- [ ] P01–P08 behavior remains unchanged.

## Separation of concerns

- [ ] changing REV signal threshold does not change REV eligibility count;
- [ ] changing CONT threshold does not change CONT eligibility count;
- [ ] quality values remain unchanged;
- [ ] grade thresholds remain independent of signal thresholds.

## Quality filter

With threshold 75:

- [ ] eligible score 74 produces no signal;
- [ ] eligible score 75 can produce a signal;
- [ ] eligible score >75 can produce a signal if other filters pass.

Set threshold 0:

- [ ] all eligible setups can pass quality filtering.

## Duplicate suppression

With one-per-family+episode+POI enabled:

- [ ] same REV episode/POI cannot emit twice;
- [ ] same CONT episode/POI cannot emit twice;
- [ ] a different POI ID is a distinct signal identity;
- [ ] REV and CONT remain distinct identities.

## Cooldown

With 3 bars:

- [ ] second same-direction signal inside window is rejected;
- [ ] same-direction signal after window can emit;
- [ ] opposite direction is not blocked by directional cooldown.

With 0 bars:

- [ ] cooldown does not suppress later-bar signals.

## Events

- [ ] BUY REV alert fires only with bullREVSignal;
- [ ] SELL REV alert fires only with bearREVSignal;
- [ ] BUY CONT alert fires only with bullCONTSignal;
- [ ] SELL CONT alert fires only with bearCONTSignal.

## Reload stability

After chart reload:

- [ ] signal bars remain unchanged;
- [ ] rejection counts remain deterministic;
- [ ] signal history identity remains deterministic.

## Exit gate

Do not add stops/targets until signal emission is visually validated.
