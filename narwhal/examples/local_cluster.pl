:- use_module(library(narwhal)).

%! start_local_cluster/0 is det
%
%  Spin up all configured nodes as threads on localhost.
start_local_cluster :-
    forall(node_address(NodeId, _, _), start_node(NodeId)).

% ?- start_local_cluster.
