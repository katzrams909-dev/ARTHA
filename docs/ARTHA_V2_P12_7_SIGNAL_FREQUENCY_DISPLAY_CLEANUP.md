# ARTHA v2 P12.7 — Signal Frequency + Display Cleanup

## Objective

Keep the P12.6 signal model intact while reducing repeated EARLY exposure and improving historical readability.

## EARLY frequency rule

A same-direction EARLY signal is suppressed until at least one reset condition occurs:

1. a new displacement episode is associated with the reaction POI;
2. a new CHoCH/MSS occurs after the previous EARLY signal;
3. an opposite-direction execution signal occurs after the previous EARLY signal.

Default:

```text
Suppress repeated same-direction EARLY until reset = ON
```

MISS signals are not affected by this rule.

Normal REV/CONT signals are not affected.

## Why

P12.6 correctly promoted EARLY opportunities into entries, but a directional leg could generate multiple EARLY entries that represented repeated exposure to essentially the same move.

P12.7 treats those as one opportunity until the market produces new causal information.

## Completed entry cards

ACTIVE and T1-HIT cards retain entry detail.

Terminal cards collapse from:

```text
CONT BUY · EARLY · Q82 B
ENTRY 30909.4
T2 HIT · +9.17R
```

to:

```text
CONT BUY · EARLY · Q82 B
T2 HIT · +9.17R
```

STOPPED and EXPIRED cards use the same compact format.

## Unchanged

- REV/CONT setup logic
- MISS qualification
- EARLY qualification
- quality calculations
- normal cooldown
- duplicate suppression
- stops
- targets
- outcome model
- last-four recent entry history
