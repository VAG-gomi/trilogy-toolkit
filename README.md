# trilogy-toolkit

One-command installer for the **Trilogy research software mirrors** —
[CFHM](https://github.com/VAG-gomi/cfhm-software),
[MAF](https://github.com/VAG-gomi/maf-software), and
[LHE](https://github.com/VAG-gomi/lhe-software) —
so humans and AI agents can get them working without the setup hazards
(system-Python blocks, tiny `/tmp` build dirs, transient network retries).

## Requirements

- Python 3.10+ and `git`.
- A stable network connection: `maf` and `cfhm` depend on `torch`
  (~526 MB wheel), so the venv downloads ~700 MB total on first install.
- ~1 GB free disk for the venv.

## Install

```bash
git clone https://github.com/VAG-gomi/trilogy-toolkit.git
cd trilogy-toolkit
./install.sh
source ./trilogy-venv/bin/activate
```

That's it. The script:

1. Creates an isolated venv at `./trilogy-venv` (override with `TRILOGY_VENV`;
   system Python is never touched — this avoids PEP 668 blocks).
2. Redirects pip's build temp dir locally (avoids "no space left" on small
   `/tmp` filesystems).
3. Installs the three packages from **pinned commits** (`requirements.txt`).
4. Runs `verify.py` — all three must import or the install fails loudly.

Non-interactive throughout: an AI agent can run `./install.sh` unattended.

## Manual install

```bash
python3 -m venv trilogy-venv
source trilogy-venv/bin/activate
pip install -r requirements.txt
python verify.py
```

## What's installed

| Package | Repo | Installed version |
|---|---|---|
| `cfhm` | `VAG-gomi/cfhm-software` | 0.1.0 |
| `maf` | `VAG-gomi/maf-software` | 1.1.1 |
| `lhe` | `VAG-gomi/lhe-software` | 0.1.1 |

Pins recorded 2026-10-19; each package retains its upstream license
(see its own repo). For latest `main` instead of pinned commits, drop the
`@<sha>` suffix in `requirements.txt`.

## Files

- `install.sh` — the installer (bash, stdlib only, no dependencies).
- `requirements.txt` — pinned `git+https` requirements.
- `verify.py` — import check; exit 0 iff `cfhm`, `maf`, `lhe` all import.
