# ARTHA v2 P11.2 — Readable Trade Display

P11.2 addresses readability, not logic.

Default chart behavior:

- only the newest active plan is drawn;
- older active plans continue to track internally but their drawings are removed;
- ENTRY, SL, T1 and T2 use normal-size boxed labels;
- each label includes the exact price;
- T1/T2 labels include projected R;
- plan lines use width 2;
- the extra status label is OFF by default;
- detailed outcome/statistics remain in diagnostics.

Example:

```text
ENTRY  30785.5
SL     30612.0
T1     31045.0 · 1.49R
T2     31220.0 · 2.50R
```

No setup, signal, stop, target, or outcome calculations are changed.
