-module(emqx_acl_custom).

-include_lib("emqx/include/emqx.hrl").

%% ACL callbacks
-export([ init/1
%        , check_acl/5
        , check_acl/2
        , reload_acl/1
        , description/0
        ]).

init(Opts) ->
    {ok, Opts}.

%check_acl({Credentials, PubSub, _NoMatchAction, Topic}, _State) ->
%    io:format("ACL Demo: ~p ~p ~p~n", [Credentials, PubSub, Topic]),
%    allow.

check_acl({Credentials, PubSub, Topic}, _Opts) ->
    io:format("ACL Custom: ~p ~p ~p~n", [Credentials, PubSub, Topic]),
    allow.

reload_acl(_State) ->
    ok.

description() -> "ACL Custom Module".
