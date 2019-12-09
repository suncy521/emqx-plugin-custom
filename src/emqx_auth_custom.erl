-module(emqx_auth_custom).

-behaviour(emqx_auth_mod).

-export([ init/1
%        , check/2
        , check/3
        , description/0
        ]).

%init(Opts) -> {ok, Opts}.

%check(_Credentials = #{client_id := ClientId, username := Username, password := Password}, _State) ->
%    io:format("Auth Demo: clientId=~p, username=~p, password=~p~n", [ClientId, Username, Password]),
%    ok.


md5(S) ->
  Md5_bin =  erlang:md5(S),
  Md5_list = binary_to_list(Md5_bin),
  lists:flatten(list_to_hex(Md5_list)).

list_to_hex(L) ->
  lists:map(fun(X) -> int_to_hex(X) end, L).

int_to_hex(N) when N < 256 ->
  [hex(N div 16), hex(N rem 16)].

hex(N) when N < 10 ->
  $0+N;
hex(N) when N >= 10, N < 16 ->
  $a + (N-10).

check_username_prefix(Username) ->
    "user_" ++ Username_prefix = binary_to_list(Username),
    "pass_"++Username_prefix.

check_username(Username) ->
  case catch check_username_prefix(Username) of
    {'EXIT', What} ->
      {error, What};
    Pass ->
      Pass
  end.

init(Opts) -> {ok, Opts}.

check(#{username := undefined}, _Password, _Opts) ->
  {error, username_undefined};
check(_Credentials, undefined, _Opts) ->
  {error, password_undefined};
check(#{username := Username}, Password, _Opts) ->
  case check_username(Username) of
        {error,_} ->
            {error, username_format_error};
        Pass ->
            T_pass =  md5(Pass),
            case T_pass =:= binary_to_list(Password) of
              true -> ok;
              false -> {error, password_error}
            end
  end.

description() -> "Auth Custom Module".

