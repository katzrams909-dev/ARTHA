# P17.12 Validation Checklist

1. Compile in TradingView Pine Script v6.
2. Load historical data where no signal marker has been created yet; verify the line 2971 empty-array runtime error is gone.
3. Confirm same-bar arbitration still removes losing markers and keeps the selected signal marker.
4. Confirm compact and verbose labels preserve the ▲/▼ or BUY/SELL prefixes and still bind to the correct risk plan.
5. Test Badge and Text Only styles, emoji on/off, bullish/bearish label colors and transparency.
6. Enable confirmed HTF EMA plots and verify configurable 1H fast/slow lengths and colors.
7. Verify no repaint from unfinished higher-timeframe candles.
8. Show/hide the setup dashboard; test all four positions and both sizes.
9. Confirm dashboard trend/structure text and active-plan entry, stop, T1, T2 values update as expected.
10. Confirm existing risk/reward boxes, breakeven stop movement, targets and outcome accounting remain unchanged.
11. Check object limits and label overlap on the user's 15m SPX500USD chart.

Compilation and visual validation are pending.