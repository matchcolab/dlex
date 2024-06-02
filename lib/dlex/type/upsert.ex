defmodule Dlex.Type.Upsert do
  @moduledoc false

  alias Dlex.{Adapter, Query, Utils}
  alias Dlex.Api.{Request, Response, Mutation}

  @behaviour Dlex.Type

  @impl true
  def execute(adapter, channel, request, json_lib, opts) do
    Adapter.upsert(adapter, channel, request, json_lib, opts)
  end

  @impl true
  def describe(query, _opts), do: query

  @impl true
  def encode(%Query{statement: %{query: query, mutations: mutations}}, vars, json_lib) do
    request_mutations =
      for %{set: set, delete: delete} <- mutations do
        struct(Mutation,
          set_json: json_lib.encode!(set),
          delete_json: json_lib.encode!(delete)
        )
      end

    struct(Request,
      query: query,
      vars: Utils.encode_vars(vars),
      mutations: request_mutations
    )
  end

  @impl true
  def decode(%{json: json_lib}, %Response{json: json} = _response, _opts) do
    json_lib.decode!(json)
  end
end
