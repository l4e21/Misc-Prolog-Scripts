# narwhal

DAG-based mempool consensus in SWI-Prolog.

## Overview

`narwhal` is a SWI-Prolog pack implementing a simplified version of the [Narwhal](https://arxiv.org/abs/2105.11827) DAG-based mempool protocol. Nodes broadcast batch digests, collect votes, and issue certificates that are recorded as vertices in a directed acyclic graph (DAG). The cluster size and quorum are dynamic: quorum is computed at round start as 2f+1 where n = peers + self and f = (n−1)//3.

## Installation

```prolog
swipl install.pl
```

Re-run after any changes to `pack.pl`.

## Usage

### Load the library

```prolog
:- use_module(library(narwhal)).
```

### Start a node

```prolog
?- start_node(4001).
```

Binds to the given port (an integer) and spawns a detached accept loop.

### Join peers

After starting a node, call `join/1` for each peer port before beginning a round:

```prolog
?- join(4002).
?- join(4003).
```

`join/1` sends a `hello` handshake to the peer and registers it on success.

### Broadcast a batch digest

```prolog
?- broadcast_batch_digest(1, [tx_abc, tx_def]).
```

Snapshots the current peer list, computes quorum (2f+1), asserts a self-vote, broadcasts concurrently to all peers, and blocks until `certificate(Round, Self)` holds.

### Query a certificate

```prolog
?- certificate(1, 4001).
```

Succeeds when received votes for `(Round, Sender)` meet the quorum for that round.

## Exports

| Predicate                           | Mode           | Description                                        |
|-------------------------------------|----------------|----------------------------------------------------|
| `start_node/1`                      | `+Port`        | Bind to port and start accept loop                 |
| `join/1`                            | `+Port`        | Handshake with a peer and register it              |
| `broadcast_batch_digest/2`          | `+Round,+Batches` | Broadcast, collect votes, wait for certificate  |
| `certificate/2`                     | `+Round,+Sender` | Succeeds when quorum of votes received           |

## Message Types

Messages are standard Prolog terms dispatched by handler predicates:

| Term                                   | Meaning                                           |
|----------------------------------------|---------------------------------------------------|
| `hello(Sender)`                        | Handshake; registers sender as peer               |
| `batch_digest(Round, Sender, Batches)` | A node's batch header for a given round           |
| `vote(Round, Sender)`                  | A vote acknowledging a batch digest               |

## DAG Structure

The DAG is stored as dynamic facts:

```prolog
:- dynamic vertex/3.
%  vertex(?Round, ?NodeId, ?Batches)
```

### Predicates

| Predicate                               | Mode     | Description                               |
|-----------------------------------------|----------|-------------------------------------------|
| `add_vertex(+Round, +NodeId, +Batches)` | det      | Assert a new vertex into the DAG          |
| `has_vertex(+Round, +NodeId)`           | semidet  | Succeeds if a vertex exists for the pair  |

## Documentation Server

```prolog
?- use_module(library(narwhal)), use_module(library(pldoc)), doc_server(4000).
```

Then open `http://localhost:4000` in a browser.

## Testing

```sh
swipl -g "run_tests, halt" test.pl
```

The test suite is a placeholder (`test.pl`) — tests are yet to be written.

## Development

Use `make/0` in a running SWI-Prolog session to reload changed source files:

```prolog
?- make.
```

After structural changes (new exports, modified `pack.pl`), reinstall the pack:

```sh
swipl install.pl
```
