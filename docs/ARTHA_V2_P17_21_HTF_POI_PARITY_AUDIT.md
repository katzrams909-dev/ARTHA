# ARTHA P17.21 — HTF POI Candidate History and Parity Audit

Status: committed draft, not compiled in TradingView. P17.20 is the latest user-confirmed compiled baseline. P17.19.1 was skipped.

P17.21 keeps up to 16 historical HTF OB/BB candidate rectangles rather than only the latest drawing. It introduces a parity table for comparisons made on the source chart timeframe: GBPUSD chart 15m, with selected POI source 15m. It compares each newly confirmed candidate birth to native OB records using birth, origin, direction and top/bottom within one tick. Counts are exact matches, no native match, and boundary mismatch.

IMPORTANT: The source-side candidate detector still uses a reduced displacement/break/FVG model. Parity is NOT established merely because the script compiles or the candidate rectangles appear. Candidate OB/BB entries remain disabled. The native signal engine, HTF FVG entries, risk stops, TP1 1R, TP2 2R, liquidity TP3/TP4 are unchanged.

How to validate: (1) Compile and replay P17.21 on GBPUSD 15m with POI source=15m; inspect audit counts. (2) Compare candidate zones to actual native 15m OBs and note disagreements. (3) Change to 5m chart with source=15m; verify candidate boundaries and historical rectangles. (4) Compare native and HTF-FVG trade outcomes against P17.20. (5) Check drawing limits on long histories.

Limitations: candidate-centric audit may miss zones that retire before the next confirmed source snapshot; registry trims can affect matching; source candidate engine still retains a single active candidate rather than simultaneous native POIs; breaker/IFVG parity not validated. Source-equal chart comparisons provide diagnostics, not certified native equivalence.

Next task: encapsulate exact native displacement episode, primary structural FVG, OB and BB lifecycle into a source-timeframe-safe registry; export stable native IDs and multiple concurrent zones before enabling HTF OB/BB-derived entries.
