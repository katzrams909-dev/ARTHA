# ARTHA v2 P17.15 — Fixed-R Primary Targets

## Status
Draft committed. **Not yet compiled or chart-validated in TradingView.** P17.14.1 compiled but experienced a dynamic historical-buffer runtime error at bar 5805; P17.14.2 contains a separate, unconfirmed guard fix, retained in this new baseline.

## Problem
Existing primary targets select nearest qualified active opposing liquidity, sometimes picking PWH at 3.85R as TP1 and a second level at 3.95R as TP2. This conflicts with the intended straightforward risk-based trade management and produces nearly overlapping target lines.

## Changes
- New `Primary TP1 / TP2 model` input defaults to **Fixed R**, with editable `Fixed TP1 / R = 1.00` and `Fixed TP2 / R = 2.00`.
- `Fixed R`: buy TP = entry + riskDistance * selected multiple; sell TP = entry - riskDistance * selected multiple. `riskDistance` is the absolute distance from entry to the structural stop. Mode validates that TP2 multiple exceeds TP1.
- **Legacy liquidity** mode preserves the preceding P17.14.2 target selection, including the old fallback parameters and the exclusion of session levels from managed TPs.
- Visual TP3/TP4 still select eligible active liquidity beyond managed TP2 and TP3, respectively. This includes completed session highs/lows, prior periods (PD/PW/PM), and swing pools if eligible. A PWH at 3.85R may now appear as TP3 rather than displacing TP1.
- TP3/TP4 remain informational: no simulated partial exits or changes to realized R beyond TP2. Existing `50% T1 + BE remainder` logic retained.
- Dashboard header updated to P17.15. Earlier versions unchanged.

## Validation
1. Compile Pine v6, then load enough history to pass the previously reported bar 5805 runtime failure.
2. Confirm TP1 exactly 1R and TP2 exactly 2R under default settings on both BUY and SELL signals.
3. Confirm eligible active PWH/session/swing liquidity beyond TP2 can be TP3 or TP4 (or `NO ELIGIBLE LIQ` if absent).
4. Confirm `Legacy liquidity` mode retains older behavior, and Fixed R mode ignores legacy liquidity override for managed TPs.
5. Confirm existing visual styles, no age-based plan expiry, independent trades, and stop-first bar precedence.
6. Compare realized R for a full TP2 outcome under default partial model: 0.5*1R + 0.5*2R = 1.50R before costs.
