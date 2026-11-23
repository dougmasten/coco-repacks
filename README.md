# CoCo SDC repacks

CoCo games rebuilt as one [dmpkg](https://github.com/dougmasten/dmpkg) disk image each: the original disks go in, a single `.DSK` comes out, and its loader streams the whole game from the CoCo SDC with no disk swapping.

Each folder builds from the game's original disks in its `bin/`. Those disks, and everything extracted or built from them, are git-ignored: only the scripts and loader are the repack.

| folder | game | status |
|---|---|---|
| [rick_dangerous/](repacks/rick_dangerous/README.md) | Rick Dangerous (CoCo 3, 2 MB, 6309) | works on real hardware |

## Building

dmpkg is a git submodule in `tools/dmpkg/`:

```sh
git clone --recurse-submodules <this repo>
# or, in an existing clone:
git submodule update --init
```

Then put the original disks in `repacks/<game>/bin/` and run `cd repacks/<game> && make all`. You need python3 (with PyYAML) and lwasm. Each Makefile finds dmpkg at `../../tools/dmpkg`; override with `DMPKG=` to use another checkout.
