# ARTHA Non-Repainting Contract

1. Engine events are committed only on confirmed bars.
2. Pivot values are usable only after their right-side confirmation bars have elapsed.
3. A pivot may be drawn back on its pivot bar for visualization, but cannot influence prior bars.
4. HTF data uses `request.security()` with confirmed historical values and `lookahead_off`.
5. Signal state is not recalculated from future information.
6. Historical reload must reproduce the same committed events.
7. A confirmed event cannot later be removed or rewritten by the engine.
8. Hidden drawings must not disable calculations.
9. Diagnostic mode is observational only.
10. Any unavoidable realtime distinction must be documented rather than concealed.
