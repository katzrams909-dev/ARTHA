# ARTHA P17.25.1 — Delayed Structural OB Confirmation

## Status
Committed source; TradingView compilation and runtime behavior NOT yet confirmed. P17.25 user reported zero OBs.

## Root-cause analysis
The P17.25 OB gate required episodeActive and episodeStructureBreak on the same bar. The episode state flagged a structural break only when a break coincided with a qualifying displacement candle. If the displacement leg happened first and BOS/CHoCH/MSS printed later, the system could miss the entire OB despite valid origin/structure sequencing.

## Revision
- On the first confirmed qualifying displacement candle in an episode, lock an actual opposite candle strictly before episode start, recording its bar/time and bounds. Never use a subsequent fallback candle.
- Retain one bounded pending candidate per direction beyond the duration of the displacement episode. On subsequent bars, a confirmed internal or external directional BOS/CHoCH/MSS can confirm the OB up to 15 chart bars from impulse start (adjustable).
- The confirmed structural break is the actual native `iBullBreak` / `xBullBreak` / `iBearBreak` / `xBearBreak` event on the chart bar, not a hypothetical future structural event.
- An optional external-break requirement and optional linked FVG remain; FVG remains confluence and is not required by default.
- Register the OB only at the confirmed structural break (not on its source candle), with immutable earlier origin and source episode ID. Existing later bars do not retroactively create entry signals.
- Add `Show OB qualification diagnostics in Data Window` (default OFF), with cumulative counters for source candidates, missing pre-impulse origins, expired windows, and confirmed OB births.
- Existing native REV/CONT code and Nearest preference, FVG/IFVG creation, clean-view rendering, mitigation/END behavior, separate inverse-phase boxes, stops and TP1–TP4 remain in place. Because OB eligibility changes, native signals/outcomes may change.

## Limitations
- One pending candidate per direction. A newer same-direction displacement episode supersedes an earlier pending one rather than tracking arbitrarily many concurrent candidates.
- When the prior 8 candles contain no opposite source candle before the displacement leg, the candidate is correctly rejected. Increasing origin search bars can allow legitimate farther origins but must be validated visually.
- If structure breaks outside the 15-bar window, the OB is not confirmed. Increasing the window increases opportunity and potentially false associations; test sensitivity.
- A source FVG that formed and retired before confirmation may not be available under optional linked-FVG requirement. With default OFF, unaffected.
- Technical compilation and runtime validation require TradingView; do not infer success from source commit.

## Test
1. Compile P17.25.1 on DE30EUR 15m with G06 defaults (15-bar validation window, origin search 8, linked FVG OFF, external-only OFF).
2. Toggle Data Window diagnostics ON. If OBs remain absent, compare Candidates seen versus Origin unavailable, Window expired, and Structure confirmations to identify the blocker.
3. Confirm OB origin is the last opposite candle before displacement and actual BOS/CHoCH/MSS is confirmed later; no earlier chart entry may be generated.
4. Check OB-to-BB conversion, mitigation/fill box stop and separate inversion rectangles.
5. Compare native signal/SL/TP outcomes with P17.24.1 under like-for-like settings before adopting P17.25.1 as new validated baseline.
