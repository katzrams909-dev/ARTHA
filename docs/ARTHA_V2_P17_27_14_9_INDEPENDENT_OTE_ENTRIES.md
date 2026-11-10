# ARTHA P17.27.14.9 — Independent Confirmed OTE Production Entries

## Baseline
The user's visual review of **P17.27.14.8** reported "all looks ok" after compile-and-chart validation. The baseline source is preserved. The new P17.27.14.9 is a separate, **TradingView compile-unverified** source on branch `artha-v2-p17-presets`.

## Independent OTE model — experimental, OFF by default
New Section 14C input `Enable independent confirmed OTE entries (experimental)`. This engine creates `OTE` candidates **without requiring the native REV/CONT NORMAL/EARLY/MISS signal state machine to emit a candidate**, but intentionally still requires a **confirmed Fibonacci archive** and a **live primary native FVG/IFVG/OB/BB POI**. Fib-only execution without a native POI is NOT supported by this version.

A candidate may be admitted only on its confirmed current candle when:
1. `f_oteProductionSource` finds a confirmed (prior chart bar) Minor / Major / HTF / structural-break Fibonacci retracement (chosen by existing `Production OTE scale`) with a recent (existing 5-bar default) 62–79% touch and overlapping same-direction live POI.
2. The **selected native POI existed before** that recorded OTE retest and still qualifies as a live primary POI with episode provenance; this avoids attributing a touch to a later-born POI, although the archive still lacks a precise historical per-POI touch key.
3. A confirmed directional candle closes back beyond the POI's entry-facing boundary. This is a *close-confirmation model*, not an OTE limit order on the first touch.
4. Structural direction has at least internal/external trend alignment and passes the optional existing combined trend filter. Recent REV/CONT context strengthens family assignment but is no longer mandatory for OTE-originated signals.
5. Existing `f_reactionQuality` score (+5 for confirmed OTE confluence) meets the existing REV or CONT minimum quality threshold (depending on family), and accepted-key duplication/cooldown rules allow the selected native POI.

Priorities: Native NORMAL/EARLY/MISS wins when a native signal is present on the candle. When no native signal is present, independently confirmed OTE has priority over experimental MID when both are enabled and qualify. A one-per-source-POI-per-confirmed-OTE-retest-bar attempt key prevents duplicate retries from one touch; a genuinely new retest may retry after a previous risk rejection. Separately accepted setups can coexist.

## Risk and output
A qualifying OTE candidate is labeled `OTE`, bound to selected same-direction native POI source and ID, and passed through the **unchanged** shared native risk/target engine:
- Same causal/structural stop model, stop side, 3 ATR maximum stop distance, target geometry, fixed-R or liquidity-target selection, TP1–TP4, trade lifecycle and historical marker behavior.
- `Production OTE confluence=Off` does not disable **independent** OTE; the separate input enables/disables the independent entry model. `Require` remains a hard production OTE confluence filter for all qualifying entries.
- Newly admitted OTE labels retain scale attribution (OTE MIN/MAJ/HTF/BRK) where found, even with confluence mode Off.
- Existing combined trend filter, if on, may veto a confirmed OTE reclaim when it is neutral/blocked.
- No retroactive signals on the Fib origin, pivot candle or first touch bar. Decisions occur on the reclaim candle's confirmed close only.

## Explicit limitations
- This is not a general unrestricted standalone Fibonacci trade; it needs a causal overlapping native POI. Fib-only stops and risk-plan identities require a separate future design.
- This is not a backtested claim that user's manually marked examples can all be reproduced. Multi-market 15m screenshot markers are qualitative setup benchmarks.
- Existing OTE `lastConfluenceBar` is not an exact historical per-POI ledger; a selected POI must predate the retest and overlap the confirmed Fib zone, but another live same-direction POI could have been the historical toucher.
- Because structural context and native quality remain required, rejected or missed entries may be appropriate. The 3 ATR risk rule is not weakened.
- Source code is not TradingView-compiled here, and Pine compiled tokens are not proportional to source characters. On CE10117, report the exact count.

## TradingView validation
1. Compile `pine/v2/ARTHA_V2_P17_27_14_9_Independent_OTE_Entries.pine`; preserve .14.8 as the working fallback. If compiler errors, send exact line/error or token count.
2. With independent OTE **Off**, and experimental MID setting held identical to .14.8, verify S/R/P trade counts and M audit labels match on matching history, timeframe and inputs.
3. Turn independent OTE **On**; start with `Production OTE scale=All`, confluence `Off`, and the same trend filter setting. Compare 15m XAUUSD, NAS100, GBPUSD, USDJPY, AUDUSD, USDCAD.
4. Check new `OTE` labels (not just orange `POI 50%` observations), native POI identity, quality, contextual direction, and accepted P# plans or grey risk rejection labels.
5. Recheck with scale `Major + HTF` for tighter confluence and with `Production OTE confluence=Require`. Note that Require may reject other native/MID signals absent Fib confluence.
6. Validate in Bar Replay: the OTE archive must already be confirmed; POI existed before the recorded touch; no backfilled entry at a retrospectively visible pivot. Observe distinct-POI independence and avoid double exposure on one setup.
7. Check historical TP/SL entry markers, stop side, <=3 ATR risk and TP1–TP4 remain intact.
