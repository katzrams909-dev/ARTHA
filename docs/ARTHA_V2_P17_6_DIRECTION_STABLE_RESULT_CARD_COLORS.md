# ARTHA v2 P17.6 — Direction-Stable Result Card Colors

## Purpose

Keep each recent-entry result card in the original trade-direction color for the full lifecycle.

## Behavior

- BUY result cards remain the configured bullish signal color while active and after any terminal outcome, including `STOPPED`.
- SELL result cards remain the configured bearish signal color while active and after any terminal outcome, including `STOPPED`.
- The card text continues to show the result status and realized R where applicable. Outcome text does not recolor the card.
- Existing P17.5 color inputs, entry-label controls, signal arbitration, POI selection, risk geometry, outcome calculations, and terminal cleanup remain unchanged.
- The separate stop-loss line/label continues to use the user-configured `Stop-loss line / label color` while active; terminal risk drawings are still removed.

## Implementation

The recent-entry card update chooses its background from `dir` only:

```pine
color bg=dir==1?bullSignalColor:bearSignalColor
label.set_color(lb,color.new(bg,15))
```

`realizedR` remains used for result text/accounting, not for the card background.

## Validation target

`pine/v2/ARTHA_V2_P17_6_Direction_Stable_Result_Card_Colors.pine`
