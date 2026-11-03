# ARTHA P17.22.1 — Pine CE10295 main-body refactor

Status: committed development draft; compilation in TradingView not yet confirmed. P17.21 is user visually validated; P17.22 was rejected by compiler CE10295.

## Scope
- Extracted confirmed higher-timeframe candidate registry state transitions into f_processHTFRegistry(). Primitive counters/timestamps return explicitly, and the zone array retains mutable elements.
- Extracted the HTF candidate box update loop into f_drawHTFRegistry().
- Removed the redundant P17.22 HTF registry statistics table and its switch; retained the source-versus-native OB parity audit table.
- No changes to native REV/CONT admission, HTF FVG entry admission, SL geometry, fixed TP1/TP2, managed TP3/TP4, or underlying OB candidate rules.
- P17.19.1 skipped session-line fix has not been merged.

## Rationale
Pine compilation error CE10295 indicated main script body was too long. Function extraction reduces main-body complexity while preserving the P17.22 registry and trade calculations. The overall source line count remains substantial, but main-body length is the specific compiler constraint.

## Validation
1. Compile P17.22.1 in TradingView; send exact error and line if CE10295 or another error remains.
2. Verify candidate OB/BB registry on GBPUSD 5m, POI 15m and source/native parity audit on GBPUSD 15m.
3. Compare native entries, HTF FVG entries, structural stops and outcomes with prior compiled version under matching inputs.
4. Check history/runtime errors and object limits. HTF OB/BB entries remain disabled; parity is not proven.
