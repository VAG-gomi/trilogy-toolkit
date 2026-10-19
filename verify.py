"""Import-check for the Trilogy toolkit. Exit 0 iff all three import."""
import importlib
import sys

failures = []
for name in ("cfhm", "maf", "lhe"):
    try:
        mod = importlib.import_module(name)
        print(f"{name}: OK (version {getattr(mod, '__version__', 'unknown')})")
    except Exception as exc:  # noqa: BLE001 - report, don't crash the loop
        print(f"{name}: FAILED ({type(exc).__name__}: {exc})")
        failures.append(name)

if failures:
    print(f"FAILED: {', '.join(failures)}", file=sys.stderr)
    sys.exit(1)
print("All Trilogy packages import cleanly.")
