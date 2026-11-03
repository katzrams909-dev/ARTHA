# ARTHA v2 P17.24.1 — Native OB Recovery and FVG Display Filtering

Status: new version committed, TradingView compilation and runtime validation pending. P17.24 is compile-confirmed.

## Root cause verified in P17.24 source
- Strict default OB admission required a *primary structural FVG* and an attributed displacement episode. Many valid native FVGs do not meet this stronger filter, so FVG/IFVG drawings can dominate.
- When `Require primary structural FVG` was switched off, the OB trigger could pass on a displacement-linked FVG, but its subsequent branch continued to use `newBullPrimaryEpisodeId`/`newBearPrimaryEpisodeId`, which are populated only for primary structural FVGs. This prevented the intended relaxed route from producing OB records.
- OB origin lookup only scanned candles before the episode start. On tightly clustered impulses, the search may return no opposite candle. BB production depends on existing OBs, so sparse OBs also suppress BBs.

## Changes
- OB structural qualification switch defaults OFF. With it OFF, an OB still REQUIRES a displacement-linked FVG with a valid causal episode. Strict mode ON restores the previous primary-structural admission requirement. This changes POI availability and may affect native entries; do not assume signal parity with P17.24.
- Fixed non-primary route to use that new FVG's actual episode ID, displacement score, structure provenance, and current FVG ID, rather than unpopulated primary-only variables.
- Added optional `Fallback: find prior opposite candle for OB` (default ON). If pre-episode origin lookup fails, searches up to the configured origin search bars before the current confirmed event for a genuine opposite candle. It never uses future candles.
- Added `Show only displacement-linked FVG / IFVG` (default ON) to hide ordinary FVG/IFVG drawings. It does NOT delete imbalance records or remove them from native trade calculations; use `Show secondary FVGs` separately if needed.
- Native zone fill endpoints, separate native FVG-to-IFVG and OB-to-BB phase boxes, structural stop rules, TP1=1R/TP2=2R and liquidity TP3/4 calculations are unchanged.
- HTF POI registry/entries stay removed. Optional HTF swing liquidity targets remain available independently.

## Validation priorities
1. Compile P17.24.1 on TradingView. If a compiler error occurs, provide exact message and line.
2. On the same symbol/timeframe and settings, compare P17.24 vs P17.24.1 counts of FVG, IFVG, OB and BB. Expect more causal OBs and potentially BBs, plus fewer FVG/IFVG drawings. No particular minimum OB count is guaranteed.
3. Turn `Require primary structural FVG for OB` ON to compare the strict prior qualification. Turn fallback origin OFF to isolate search effects.
4. Confirm native entry decisions, structural stops and TP results; because the native POI admission universe changes, these outcomes may legitimately differ. Evaluate quality with chart examples, not only counts.
5. Replay OB to BB / FVG to IFVG and verify original-phase box ends, new phase begins, and mitigation rules still stop them.
6. Compare FVG/IFVG records and signals with `Show only displacement-linked FVG / IFVG` ON/OFF; changing a presentation-only setting must not alter signals.

Important: This is a targeted repair and causal filtering step, not a claim that every visually expected OB will now appear. If OBs remain absent, next diagnose actual displacement event and episode provenance counts rather than further weakening causal requirements.