# ARTHA v2 P17.25 — Structural Order Block Qualification

## Status
Source committed, not TradingView compiled or replay-verified. P17.24.1 was chart-reviewed by user; P17.24.2 clean-view code remains an unconfirmed intermediate base. P17.25 includes its visual-only clean-view settings and native inversion box lifecycles.

## Qualification model
A native bullish OB is the last bearish candle before a confirmed qualified bullish displacement episode that records a bullish structure break. A bearish OB is the last bullish candle before an analogous bearish episode. The selected origin is strictly BEFORE the episode's first qualifying displacement candle. The confirmed OB is registered only on/after the qualifying structural break; its left edge can be plotted at the origin for visual provenance but may NOT create earlier signals.

Conditions: barstate.isconfirmed; active displacement episode; confirmed episodeStructureBreak and non-NONE structure kind (BOS/CHoCH/MSS); minimum displacement quality score 60 (adjustable); optional external-scope requirement (OFF by default); valid pre-episode opposite-candle origin within obSearchBars. FVG is optional corroboration: only when Require linked FVG is ON does the episode require a linked registered FVG before OB admission.

## Code changes
- Removed the former fallback that could select an arbitrary recent opposite candle after an episode began.
- Replaced primary structural FVG gating with structure-breaking qualified displacement as mandatory OB evidence. Linked-FVG requirement is a separate optional confluence switch.
- Origin lookup uses the already present bounded pre-episode search and never crosses into the displacement interval.
- Adds G06 settings: Require linked FVG for confirmed OB (default OFF), Require external BOS/CHoCH/MSS (default OFF), Minimum OB episode displacement score (default 60). Existing obSearchBars, OB body boundaries and BB flip rules remain.
- Reuses stable native episodeId and POI ID; linked FVG ID is stored when one is already present in the episode. If a FVG appears later, previously created OB metadata is NOT retroactively rewritten. This is intentional to avoid hindsight changes.
- Existing BB conversion and mitigation/inversion box rules unchanged. REV/CONT entry-selection code, Nearest preferences and structural stop/TP implementations unchanged.
- Because the **POI source registry changes**, native REV/CONT signal counts and outcomes may change despite unchanged entry predicates. Do not claim risk-plan parity with P17.24.1.

## Caveats
- The episode structureBreak flag is populated by a qualified displacement candle that also has a directional internal/external break; a structure break occurring on an intervening non-displacement bar is not counted in this strict model. That is a deliberately conservative filter and may under-detect otherwise valid OBs.
- The attached FVG is optional and is drawn separately; this revision does NOT implement a multi-tier candidate/confirmed/high-confluence OB drawing registry.
- Requiring external scope or linked FVG may reduce OB frequency considerably. No expected OB count can be guaranteed.
- Verified mitigation box END behavior is retained; FVG/IFVG and OB/BB inversion phases remain independent. The HTF POI engine is still absent; HTF swing liquidity targeting remains optional.

## Test protocol
1. Compile P17.25 in TradingView Pine v6. If compile fails, report exact line and error.
2. Compare DE30EUR 15m chart with P17.24.1: confirm fewer unjustified OBs and retained genuine directional structure-break OBs. Check boundaries against opposite source candle.
3. Verify linked FVG requirement ON/OFF, external break ON/OFF and origin-search bounds. Every created OB must have an episode-linked structural break.
4. Replay OB->BB conversions and FVG->IFVG: verify distinct phase boxes stop under existing mitigation rule.
5. Compare REV/CONT counts, structural SL and TP1/TP2/TP3/TP4 against previous baseline; changes caused by POI availability should be explicitly evaluated rather than assumed improvements.
6. Test display-only Clean View OFF vs ON: it must not modify POI identities or trade results.
