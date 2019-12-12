%% Copyright (c) 2013-2019 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(emqx_plugin_custom_app).

-include("emqx_plugin_custom.hrl").

-behaviour(application).

-emqx_plugin(?MODULE).

-export([ start/2
        , stop/1
        ]).

start(_StartType, _StartArgs) ->
    {ok, Sup} = emqx_plugin_custom_sup:start_link(),
%%    ok = emqx_access_control:register_mod(auth, emqx_auth_custom, []),
    ok = emqx:hook('client.authenticate', fun emqx_auth_custom:check/3, []),
    emqx_plugin_custom:load(application:get_all_env()),
    {ok, Sup}.

stop(_State) ->
%    ok = emqx_access_control:unregister_mod(auth, emqx_auth_custom),
%%    ok = emqx:hook('client.authenticate', fun emqx_auth_custom:check/2, []),
  ok = emqx:hook('client.authenticate', fun emqx_auth_custom:check/3, []),
%    ok = emqx:hook('client.check_acl', fun emqx_acl_custom:check_acl/2, []),
    emqx_plugin_custom:unload().

