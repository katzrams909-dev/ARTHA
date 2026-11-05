# ARTHA P17.27.8.4 — On-Chart OTE Candidate Entry Markers

## Context
The user compiled P17.27.8.3 but could not visually verify A/B/C entry models: the top-center panel read `OTE PATHS A — / B — / C —` while existing normal REV/CONT signal markers appeared. A dashboard is insufficient to verify a model's hypothetical historical entry timing.

## Implementation
New versioned source from P17.27.8.3. Three additional 14C settings:
- `Show OTE study entry markers (no trades)` = ON.
- `OTE marker model` = Selected (default) or All.
- `Maximum OTE study markers` = 60, adjustable 10–100.

Whenever the OTE lifecycle first records the existing confirmed-bar Aggressive rejection, Balanced break or Conservative confirmation, `f_oteStudyMark` may create a **distinct, clearly labeled study marker** at that signal bar:
- `OTE A · BUY/SELL · MIN/MAJ/BRK · FVG/IFVG/OB/BB`
- `OTE B · BUY/SELL · MIN/MAJ/BRK · FVG/IFVG/OB/BB`
- `OTE C · BUY/SELL · MIN/MAJ/BRK · FVG/IFVG/OB/BB`
- Second line says `Study @ <confirmed signal close>`.

`Selected` displays only the pathway named by `OTE observation entry strength`; `All` displays all three independently when their events actually occur. Markers respond to anchor source and Minor/Major/Both selection. Color is directional cyan/purple from existing Auto Fib input. Historical marks are created only when the corresponding event occurs while processing bars—never backdated by a last-bar scan. As such, original pre-confirmation touch events are not incorrectly marked.

Each mark is appended to its own capped label array and the oldest label is deleted when the configured limit is exceeded. These study labels are deliberately **not** part of the continuously refreshed Auto Fib lines/labels so they remain visible historically even if the original Fib later invalidates; they record past observations, not ongoing eligibility.

## Crucial limitations
- A/B/C annotations are **not production signals**, orders, filled trades, alerts, stop/TP plans, or profitability evidence. They represent possible entries at confirmed signal close; slippage, spread, next-bar fill and risk gates are not evaluated.
- The user's screenshot displays normal `CONT ... EARLY` production labels: those are unrelated and are not evidence that OTE A/B/C fired.
- If no Fib experiences an active same-direction POI-qualified first OTE touch followed by the selected reaction conditions, then **no OTE entry markers appear**. The tool must not invent an entry to satisfy visual expectations.
- The latest Fib status panel reports just the newest selected source. A historic study label may exist despite the panel showing no current A/B/C eligibility.
- After first POI-qualified OTE touch, reaction pathways continue to require ongoing native POI overlap, as inherited from P17.27.8.3.
- The reaction condition currently tests an actual Fib band contact and available POI overlap independently; verifying the **intersection of the POI footprint and Fib band was also actually touched on the relevant candle** is a recommended next accuracy gate.
- Labels use a confirmed close as hypothetical entry price. They do not predict a future order fill.

## Preserved
REV/CONT/EARLY/MISS production signal arbitration and classification, native OB/BB/FVG/IFVG lifecycles, Fibonacci source and invalidation, OTE A/B/C classifications, structural SL/TP1–TP4 and independent trade management all remain unchanged.

## TradingView validation
1. Compile P17.27.8.4. Report any error code and line or CE10117 compiled token count; compilation is **not yet confirmed**.
2. Set section 14C `Show Auto Fib overlay` ON; `Show OTE study entry markers (no trades)` ON; `OTE marker model` **All**. Inspect Minor, Major and Structural Breaks individually.
3. Select `Historical` Fib display if desired. Check chart history where a confirmed and still-actionable FVG/IFVG/OB/BB actually overlaps an OTE band.
4. Validate `OTE A` label only on qualified POI rejection; `OTE B` label only on a **later** candle closing beyond rejection candle extreme; `OTE C` label only with extra directional displacement/MSS. A/B/C may show separate labels on a shared bar if B and C qualify simultaneously—that is expected in All mode.
5. Compare historic original REV/CONT/EARLY/MISS labels and structural SL/TP plans against P17.27.8.3 with identical settings; they should not move or change.
6. If no labels show, report which source scale, date range, available Fib counts and POI status you see. No artificial entries should be generated.

## Next phase
After chart-mark validation, evaluate first-touch POI-zone intersection, structural stop eligibility and TP1–TP4 hypothetical risk/reward for each pathway; only then decide on adding controlled production OTE entries.
