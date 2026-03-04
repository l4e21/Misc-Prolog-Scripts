---
name: PROLOG
description: PROLOG code style hints
disable-model-invocation: true
allowed-tools: Read, Bash
---

# Prolog Style Hints

When creating a new template or project, please do so minimally to begin with, only implementing requested features with the least amount of (readable) code. Always include a `README.md` (see the README.md section under Multifile Projects).

## Naming

- Predicates use `snake_case`.
- Variables use full, meaningful names rather than single letters. E.g., prefer `Element` over `X`, `Accumulator` over `Acc`. Single-letter variables are acceptable only when the meaning is genuinely obvious from context (e.g., `N` for a numeric counter in a tight arithmetic predicate).
- Module names are lowercase and descriptive.

## Cuts

Avoid cuts where possible — they are an antipattern that obscures control flow and makes clauses harder to reason about independently. Instead, use explicit guard conditions in clause heads or bodies to make each clause's domain unambiguous. Reserve `!` for cases where backtracking is genuinely semantically wrong and cannot be expressed otherwise.

## Clause Ordering

Order clauses from base/terminal cases to recursive/general cases.

## Module Declarations

Always declare a module with an explicit export list. Declare `dynamic` and `discontiguous` predicates at the top of the file.

```prolog
:- module(my_module, [exported_pred/2]).

:- dynamic some_fact/1.
:- discontiguous some_pred/2.
```

## Comments and Examples

- Use `%!` for predicate-level PlDoc header comments. Do not insert a blank line between the `%!` signature line and the description body.
- Use `% ?-` and `%@` markers for ediprolog inline query output — these are executable via ediprolog and serve as inline tests.
- For multifile projects, maintain a dedicated `examples/` directory for standalone example scripts.

## Multifile Projects

Structure multifile projects as SWI-Prolog packs:

```
project/
  pack.pl        % pack manifest: name, version, dependencies
  test.pl        % top-level test runner
  README.md
  prolog/        % source modules (auto-added to library path when pack is installed)
  examples/      % standalone example scripts
```

The `prolog/` directory is the SWI-Prolog pack convention — when a pack is installed it is automatically added to the library search path, so modules are available via `:- use_module(library(module_name))` with no manual path setup.

### Entry point and sub-module layout
- The main entry point file must match the pack name: `prolog/<packname>.pl` (e.g. `prolog/narwhal.pl`). This is what consumers load via `:- use_module(library(narwhal))`.
- Sub-modules live in a subdirectory named after the pack: `prolog/<packname>/` (e.g. `prolog/narwhal/dag.pl`). Load them with `:- use_module(library(narwhal/dag))`.

### `install.pl`

Each pack includes an `install.pl` at the project root:

```prolog
/* install.pl — run once before using: swipl install.pl */
:- pack_install('.', []).
```

Run it once before first use so `library(<packname>)` resolves everywhere:

```bash
swipl install.pl
```

Re-run after changes to `pack.pl` or when new sub-modules are added. `make/0` handles reloading changed source files without reinstalling.

### Installing locally during development

From within a SWI-Prolog session, run from the project directory:

```prolog
?- pack_install('.', []).
```

### Recompilation

For iterative development without restarting, use `make/0` in a live session to reload any source files that have changed on disk:

```prolog
?- make.
```

Note that `make/0` won't pick up changes to `pack.pl` or newly added files — reinstall the pack for those.

### Declaring a dependency on another pack in `pack.pl`

```prolog
name(myproject).
version('0.1.0').
requires(narwhal).
```

For unpublished packs, point at a local path or git URL in the `requires` field.

Note: ediprolog inline queries are better suited to single-file scripts as the pack load context can interfere.

### README.md

Every new pack template must include a `README.md`. At minimum it should cover:

1. **Installation** — how to install the pack locally:
   ```bash
   swipl install.pl
   ```

2. **Running** — how to start the project (e.g. load the top-level module, run examples, or start a node):
   ```bash
   swipl -g "use_module(library(<packname>)), <entry_goal>" -t halt
   ```

3. **Documentation Server** — how to browse PlDoc for the pack:
   ```prolog
   ?- use_module(library(<packname>)), use_module(library(pldoc)), doc_server(4000).
   ```
   Then open `http://localhost:4000` in a browser.

### Documentation (PlDoc)

See [PlDoc manual](https://www.swi-prolog.org/pldoc/man?section=pldoc-comments) and follow these conventions.
