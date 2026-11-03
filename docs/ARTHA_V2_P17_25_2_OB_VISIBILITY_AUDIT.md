# ARTHA v2 P17.25.2 — OB Visibility Audit

## Status
Source committed; not yet TradingView compiled or replay-validated. P17.25 remains the user's selected baseline, and P17.25.1 is intentionally not incorporated.

## Diagnosis in P17.25
An observed OB may be hidden or its drawing deleted without the source OB having been retrospectively reclassified:
- Native POI Clean View (default ON) hides OB/BB boxes more than 5 ATR from current price.
- Once an OB's visual stop rule is triggered, its END rectangle can be hidden after the default 12-bar lookback even if the underlying OB state remains active.
- Upon OB→BB inversion, the OB's original source-phase rectangle is archived; Clean View can delete it after 12 bars.
- The maximum tracked OB/BB registry is 24 records by default. Oldest entries and their current boxes are deleted on trimming. Inversion archive boxes have an independent 80-item cap.

These are concrete visibility/deletion paths, not proof of historical signal repainting.

## P17.25.2 changes
- Introduces G06 input **Audit: keep confirmed OB / BB visible**, default ON. This overrides distance and END recency hiding for native OB/BB boxes, including retired ones, while respecting each family's Show zones switch.
- Retains OB source-phase archive rectangles across the Clean View 12-bar expiry while audit is enabled; a boolean-per-archive record distinguishes archived OB from archived FVG. The cap of 80 archived phase boxes remains.
- Retired boxes preserve the correct last phase label/color (OB vs BB) based on whether that source entered a BB phase.
- It does **not** change OB detection, structure/displacement requirements, confirmed bar gating, state-machine transitions, mitigation endpoint, BB flip qualification, REV/CONT, structural SL or TP1–TP4.
- Existing 24-record tracked OB/BB cap remains; an old entry can still be removed when that cap is exceeded. Increasing the cap under G06 gives a longer history (upper limit 50). Pine chart object budget remains bounded.

## How to distinguish
1. Compile P17.25.2 on the same instrument/timeframe and replay segment as P17.25.
2. Keep the G06 **Audit: keep confirmed OB / BB visible** ON, both Show OB and Show Breaker ON. The old source rectangle should remain after a BB inversion, rather than silently disappearing because of Clean View.
3. Compare bar-by-bar actual OB creation and inversion relative to structural breaks and mitigation endpoint.
4. If OB birth or past signals disappear between live and refreshed historical charts even with this audit enabled, that is evidence of an additional source-series/realtime recalculation issue and needs a specific replay case. This patch does not assert that all possible repaint sources have been excluded.
5. Toggle audit OFF to compare the old Clean View behavior; do not change REV/CONT settings.

## Limitation
Historical box retention is bounded (24 current native OB/BB records and 80 archived inversion boxes by default). This is intentionally not an unlimited all-history archival guarantee. When users require proof of exact historical event identity beyond caps, an independent bounded event-log table/plot would be a separate project.
