# ARTHA v2 P12.4 — Persistent Entry History

## Why P12.3 could show nothing

P12.3 created a historical label only after a trade reached a terminal outcome.

It also used a shallow risk-plan tracking buffer. A plan could therefore disappear from internal tracking before its result was recorded.

## P12.4 behavior

A history card is created immediately when a P09 signal creates a risk plan.

Example at entry:

```text
CONT BUY · Q82 B
ENTRY 1.16842
ACTIVE
```

The same card updates:

```text
CONT BUY · Q82 B
ENTRY 1.16842
T1 HIT
```

then finally:

```text
CONT BUY · Q82 B
ENTRY 1.16842
T2 HIT · +2.00R
```

or:

```text
REV SELL · Q76 B
ENTRY 1.34120
STOPPED · -1.00R
```

## History depth

- visible cards: latest 4 by default, configurable 1–10;
- internal risk-plan tracking: 20 by default, configurable 10–50.

Dropping an old visible card no longer drops the underlying risk-plan tracking.

## Active risk plan

The newest active plan may still display ENTRY / SL / T1 / T2 separately.

The history card is the persistent record.

## Logic contract

This is presentation and tracking-depth only.

No setup eligibility, signal threshold, stop, target, or outcome math is changed.
