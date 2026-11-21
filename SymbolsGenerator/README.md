# SymbolsGenerator

This command line tool creates most of the `SFSafeSymbols` and `SFSafeSymbolsPrivate` code by converting the system's SF Symbols data to Swift code. The private symbols are only generated when `--private-output-dir` is passed, which the `Makefile` does.

The tool is best used by opening a terminal, changing to the main `SFSafeSymbols` directory and running `make` (or `make pr`, see `CONTRIBUTING.md`). The relevant files are then (over)written automatically. Newly created files must be added manually to the `SFSafeSymbols` Xcode project.
