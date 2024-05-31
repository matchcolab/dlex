defmodule Dlex.Type.Mutation do
  @moduledoc false

  alias Dlex.{Adapter, Query, Utils}
  alias Dlex.Api.{Response, Request}

  @behaviour Dlex.Type

  @impl true
  def execute(adapter, channel, request, json_lib, opts) do
    Adapter.mutate(adapter, channel, request, json_lib, opts)
  end

  @impl true
  def describe(%Query{statement: [%{set: statement} = map]} = query, opts) do
    statement = if opts[:return_json], do: Utils.add_blank_ids(statement), else: statement
    %Query{query | statement: [%{map | set: statement}]}
  end

  def describe(%Query{statement: [%{delete: statement} = map]} = query, opts) do
    statement = if opts[:return_json], do: Utils.add_blank_ids(statement), else: statement
    %Query{query | statement: [%{map | delete: statement}]}
  end

  def describe(query, _opts), do: query

  @impl true
  def encode(query, vars, _opts) do
    %Query{statement: mutations, query: query, txn_context: txn, json: json} = query
    {commit, start_ts} = transaction_opts(txn)

    %Request{
      start_ts: start_ts,
      query: build_query_string(mutations, query, commit),
      vars: Utils.encode_vars(vars)
    }
  end

  defp build_query_string(mutations, query, commit_now) do
    mutation_strs = Enum.map(mutations, &mutation_to_string(&1, commit_now))
    [query | mutation_strs] |> Enum.join(" ")
  end

  defp mutation_to_string(%{set: set, delete: delete}, commit_now) do
    set_str = if set, do: "set { #{set} }", else: ""
    delete_str = if delete, do: "delete { #{delete} }", else: ""
    commit_str = commit_status(commit_now)
    [set_str, delete_str, commit_str] |> Enum.filter(&(&1 != "")) |> Enum.join(" ")
  end

  defp mutation_to_string(%{set: set}, commit_now) do
    commit_str = commit_status(commit_now)
    "set { #{set} } #{commit_str}"
  end

  defp mutation_to_string(%{delete: delete}, commit_now) do
    commit_str = commit_status(commit_now)
    "delete { #{delete} } #{commit_str}"
  end

  defp commit_status(true), do: "commitNow: true"
  defp commit_status(_), do: ""

  defp transaction_opts(%{start_ts: start_ts}), do: {false, start_ts}
  defp transaction_opts(nil), do: {true, 0}

  defp infer_type(%{}), do: :json
  defp infer_type([%{} | _]), do: :json
  defp infer_type(_), do: :iodata

  defp format(:iodata, statement, _), do: statement
  defp format(:json, statement, json_lib), do: json_lib.encode!(statement)

  # :iodata is :nquads if it set or delete
  defp mutation_key(:iodata, :cond), do: :cond
  defp mutation_key(:json, :set), do: :set_json
  defp mutation_key(:iodata, :set), do: :set_nquads
  defp mutation_key(:json, :delete), do: :delete_json
  defp mutation_key(:iodata, :delete), do: :del_nquads

  defp parse_json(_json_lib, ""), do: %{}
  defp parse_json(_json_lib, nil), do: %{}
  defp parse_json(_json_lib, json) when is_map(json), do: json
  defp parse_json(json_lib, json) when is_binary(json), do: json_lib.decode!(json)

  @impl true
  def decode(
        %Query{statement: statement, json: json_lib, type: Dlex.Type.Mutation} = _query,
        %Response{json: json} = _result,
        opts
      ) do
    parsed_json = parse_json(json_lib, json)
    uids = parsed_json["uids"]
    result = %{uids: uids, queries: parsed_json}

    if opts[:return_json] do
      [mutation] = statement
      statement = Map.get(mutation, :set) || Map.get(mutation, :delete)
      json_result = if is_binary(statement), do: %{}, else: Utils.replace_ids(statement, uids)
      Map.put(result, :json, json_result)
    else
      result
    end
  end
end
