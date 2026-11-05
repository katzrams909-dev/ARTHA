# ARTHA P17.27.8.3 — Entry Confirmation Strength Study

## Status
Versioned Pine v6 source committed on `artha-v2-p17-presets`. **TradingView compilation and visual validation pending.** P17.27.8.2 is the latest compilation-confirmed baseline. No production entry rules have been loosened.

## Scope and findings from original source
Inspection of REV, CONT, the native POI reaction subsystem, and OTE confirmation logic found:
- REV setup formation begins with a liquidity sweep, then a reversal shift paired with qualified displacement and an episode, then a qualifying same-episode POI. Its **entry-stage** trigger already uses a confirmed directional candle at the existing valid POI (optionally a midpoint reclaim), not a second displacement.
- CONT setup formation starts with preexisting trend and a qualified displacement episode (and BOS if configured), then same-episode POI. Its **entry-stage** likewise uses the POI retest plus directional reaction (optionally a midpoint reclaim), not a second displacement.
- The EARLY/MISS reaction entries already have directional close/reclaim modes.
- No independent programmatic engine named `Unicorn` was found in the inspected P17.27.8.2 source. It must be separately mapped to actual FVG/IFVG + BB overlap logic before any Unicorn-specific gate is altered.
- OTE's existing post-rejection `confirmedSeen` logic **does** require a subsequent break of the rejection candle's high/low paired with a fresh directional displacement or MSS. This is where a balanced comparison is justified.

## Additions
Two settings under 14C:
- `OTE observation entry strength`: Aggressive / **Balanced** (default) / Conservative. **Display selection only**. It does not change the observed or actual production entry engine.
- `Show OTE three-path comparison`: ON (default). Status row `OTE PATHS` shows whether each pathway has occurred for the most recent selected Fib candidate.

OTE range type gains `bool balancedSeen` and `int balancedBar` (both source constructors verified to have 22 fields). No new trade plan fields.

## Independent observation definitions
All require a Fib whose first OTE 62–79% touch had a preexisting, active same-direction FVG/IFVG/OB/BB with positive area overlap and a still-live overlapping POI during the reaction sequence. 100% invalidation removes the Fib. All recorded milestones use **confirmed bars**.

- **Aggressive (A):** existing first qualifying directional rejection within the OTE reaction window; bullish close > open and > 70.5%; bearish close < open and < 70.5%; candle intersects the frozen OTE zone. Records rejection bar and rejection extreme.
- **Balanced (B):** strictly later than the frozen rejection bar; closes beyond that candle's high (bull) or low (bear) within reaction window. **No additional displacement or MSS is required.** Does not alter the conservative milestone.
- **Conservative (C):** the original P17.27.8 strict confirmation: strictly later confirmed close beyond rejection extreme AND qualified directional displacement or internal/external MSS. Tracked independently of Balanced; therefore conservative will usually imply Balanced on the same bar or later.
- **Retest:** the original P17.27.8 retest observation remains dependent on conservative confirmation. It is **not** silently remapped to balanced. A balanced-dependent retest path can be compared later in its own version.

The chosen `OTE observation entry strength` changes only how the newest range's OTE reaction is reported on the panel; all three flags still update regardless of which option is selected.

## Rendered panel
- OTE · Aggressive: REJECTION when A has been observed.
- OTE · Balanced: BALANCED when B observed; otherwise REJECTION or QUALIFIED TOUCH where applicable.
- OTE · Conservative: CONSERVATIVE (or RETEST) when C observed; otherwise REJECTION/QUALIFIED TOUCH.
- OTE PATHS: `A YES/— · B YES/— · C YES/—` using one selected source record (Minor by default in Both). This is **not** a profitability metric or historical win-rate summary.
- Fib availability, Minor/Major POI status and validation from P17.27.8.2 are unchanged.

## Confirmed non-changes
No new OTE entries, alerts or signals. No modifications to REV/CONT/EARLY/MISS production state machines, their causality, deduplication/priority rules, structural SL, TP1–TP4, native POI lifecycle, trade plan admission or ongoing managed trades. No relaxed setup formation. No new trade objects/drawings beyond a status row.

## Validation
1. Compile P17.27.8.3 in TradingView. If it fails, report exact error code/line or compiled token count. Code review is not a compilation claim.
2. On NAS100, EURUSD, BTCUSD and DE30, enable Auto Fib overlay and the two observation settings in 14C; compare source Minor, Major and Structural Breaks.
3. Ensure no status can report A/B/C for a first OTE touch without a qualified POI; confirm that an origin breach removes the range.
4. Confirm A on a qualifying directional rejection; B only on a later bar that closes beyond the rejection extreme; C only with the extra displacement/MSS event. A never requires a subsequent displacement; B never requires one; C does.
5. Switch the display-mode selector among Aggressive/Balanced/Conservative: the A/B/C comparison flags must not change as a result of display choice.
6. Compare native REV/CONT/EARLY/MISS entry labels, structural stop/TP and managed risk plans against P17.27.8.2 on the same history and settings.
7. Record real-world samples of A-only, A+B and A+B+C to assess speed vs signal quality. Do not infer profitable results from occurrence counts.
8. Unicorn: identify which existing entry model or native POI pattern the user means. Do not assume an independent Unicorn engine exists in this branch.

## Next decision
Once observation and regression are validated, decide if the Balanced criterion should be integrated into the production entry-admission system, and what stop/TP eligibility applies. Work remains versioned; P17.27.8.2 stays the last known compiling checkpoint until P17.27.8.3 is confirmed.
