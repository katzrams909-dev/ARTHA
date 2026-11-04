# ARTHA P17.27.6.1 — CE10235 lifecycle branch fix

P17.27.6 reported Pine CE10235: `Return type of one of the "if" or "switch" blocks is not compatible with return type of other block(s) (OTEShadowRange; void)`.

## Cause and focused change
In `f_maintainFibArchive`, the invalidated branch ended with `array.remove(book,i)`, whose return value has type `OTEShadowRange`, whereas the retained branch ended with `array.set(book,i,t)`, which returns `void`. Pine could not reconcile the conditional block's inferred return type.

P17.27.6.1 captures the removed object in a local variable and explicitly ends **both** conditional branches with `true`. The actual archive removal and retained-range update are unchanged. No unrelated OTE or trading logic was edited.

## Invariants
- Close- or wick-based 100% origin invalidation unchanged.
- Confirmed 0% breakout extension allowed only before first OTE touch; freezes on same-candle touch.
- Recorded source confirmation bar; no preconfirmation lifecycle mutation.
- No production REV/CONT/EARLY/MISS, POI, structural SL/TP1–TP4 changes.
- Prior versions remain unchanged.

## Validation
Compile P17.27.6.1 in TradingView and report the first compiler error with its line number, if any. Only after compile passes, compare on the same markets and timeframes against the validated P17.27.5 baseline. Do not infer runtime validation from this GitHub commit.
