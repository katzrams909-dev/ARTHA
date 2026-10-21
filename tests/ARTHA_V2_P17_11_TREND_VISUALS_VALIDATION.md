# P17.11 Validation Checklist

1. Compile in TradingView Pine Script v6.
2. Confirm the trend filter defaults OFF and existing signals remain eligible with it disabled.
3. Enable the filter on a 15m chart; confirm HTF timeframe defaults to 60 minutes.
4. Confirm bullish entries are blocked unless prior-completed 1H fast EMA > slow EMA and confirmed structure bias is bullish.
5. Confirm bearish entries are blocked unless prior-completed 1H fast EMA < slow EMA and confirmed structure bias is bearish.
6. Watch live candles and reload chart; confirm trend direction does not change due to unfinished 1H candles.
7. Verify pivots only affect structure bias after their right-side confirmation bars have elapsed.
8. Confirm risk/reward shaded areas span entry to structural stop and entry to T2, and update their right edge with the active plan.
9. Confirm the stop box follows the entry price when breakeven activates after T1.
10. Confirm boxes are removed when a plan terminates and when old plans are pruned.
11. Check for visual object limits and label overlap on 15m and 1h charts.
12. Validate the screenshot scenario specifically: the intended confirmed retest should not be mislabeled EARLY merely because the trend filter is enabled.

Compilation and visual validation are pending; do not assume success until checked in TradingView.