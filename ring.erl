-module(ring).

-export([start/3, start_process/1, start_process/2]).

start(M, N, Message) ->
    Pid = spawn(ring, start_process, [N]),
    Pid ! {msg, Message, M}.

start_process(Count) ->
    io:format("~p: Spawned ~p~n", [self(), Count]),
    Pid = spawn(ring, start_process, [Count - 1, self()]),
    loop(Pid).

start_process(1, Last) ->
    io:format("~p: Linking to first ~p~n", [self(), Last]),
    loop(Last);
start_process(Count, Last) ->
    io:format("~p: Spawned ~p~n", [self(), Count]),
    Pid = spawn(ring, start_process, [Count - 1, Last]),
    loop(Pid).

loop(NextPid) ->
    receive
      {msg, _, 0} -> true;
      {msg, Msg, M} ->
	  io:format("~p (~p) ~p~n", [Msg, self(), M]),
	  NextPid ! {msg, Msg, M - 1},
	  loop(NextPid)
    end.
