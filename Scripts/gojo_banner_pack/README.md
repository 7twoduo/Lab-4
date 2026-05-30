# Gojo Banner Pack

Files:
- `gojo-banner.sh` - Unicode-safe banner renderer.
- `art/gojo1.txt` - first uploaded ASCII/Unicode art.
- `art/gojo2.txt` - second uploaded ASCII art.
- `art/gojo3.txt` - add your third ASCII art here when ready.

Run:

```bash
chmod +x gojo-banner.sh
./gojo-banner.sh
```

Force side-by-side:

```bash
FORCE_SIDE_BY_SIDE=1 ./gojo-banner.sh
```

Force sequential:

```bash
FORCE_SEQUENTIAL=1 ./gojo-banner.sh
```

Tune animation speed and spacing:

```bash
GAP=8 DELAY=0.005 ./gojo-banner.sh
```
