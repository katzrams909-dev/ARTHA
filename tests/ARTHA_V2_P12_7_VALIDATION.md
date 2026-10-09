# ARTHA v2 P12.7 Validation

Target: `pine/v2/ARTHA_V2_P12_7_Signal_Frequency_Display_Cleanup.pine`

## Compile
- [ ] Pine v6 compiles without errors.
- [ ] CE10295 does not return.

## EARLY frequency
- [ ] first valid bullish EARLY signal is allowed.
- [ ] another bullish EARLY in the same episode is blocked.
- [ ] new bullish episode allows another bullish EARLY.
- [ ] CHoCH/MSS after the prior bullish EARLY allows a new bullish EARLY.
- [ ] bearish execution signal after bullish EARLY resets bullish EARLY suppression.
- [ ] bearish side behaves symmetrically.
- [ ] MISS signals are unaffected.
- [ ] normal REV/CONT signals are unaffected.

## Display
- [ ] active entry card retains ENTRY price.
- [ ] T1 HIT card retains active detail.
- [ ] T2 HIT terminal card is two lines.
- [ ] STOPPED terminal card is two lines.
- [ ] EXPIRED terminal card is two lines.
- [ ] only last 4 recent entry/result cards remain.

## Smoke test
- [ ] NAS100 5m: repeated CONT BUY EARLY cluster reduced.
- [ ] XAUUSD 5m.
- [ ] EURUSD 5m.
- [ ] GBPUSD 5m.
