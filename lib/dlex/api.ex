alias Dlex.Api

defmodule Api.LinRead.Sequencing do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :CLIENT_SIDE, 0
  field :SERVER_SIDE, 1
end

defmodule Api.Facet.ValType do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :STRING, 0
  field :INT, 1
  field :FLOAT, 2
  field :BOOL, 3
  field :DATETIME, 4
end

defmodule Api.Request.VarsEntry do
  @moduledoc false

  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end

defmodule Api.Request do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :query, 1, type: :string
  field :vars, 2, repeated: true, type: Api.Request.VarsEntry, map: true
  field :start_ts, 13, type: :uint64, json_name: "startTs"
  field :lin_read, 14, type: Api.LinRead, json_name: "linRead"
  field :read_only, 15, type: :bool, json_name: "readOnly"
end

defmodule Api.Response do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :json, 1, type: :bytes
  field :schema, 2, repeated: true, type: Api.SchemaNode
  field :txn, 3, type: Api.TxnContext
  field :latency, 12, type: Api.Latency
end

defmodule Api.Assigned.UidsEntry do
  @moduledoc false

  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end

defmodule Api.Assigned do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :uids, 1, repeated: true, type: Api.Assigned.UidsEntry, map: true
  field :context, 2, type: Api.TxnContext
  field :latency, 12, type: Api.Latency
end

defmodule Api.Mutation do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :set_json, 1, type: :bytes, json_name: "setJson"
  field :delete_json, 2, type: :bytes, json_name: "deleteJson"
  field :set_nquads, 3, type: :bytes, json_name: "setNquads"
  field :del_nquads, 4, type: :bytes, json_name: "delNquads"
  field :set, 10, repeated: true, type: Api.NQuad
  field :del, 11, repeated: true, type: Api.NQuad
  field :start_ts, 13, type: :uint64, json_name: "startTs"
  field :commit_now, 14, type: :bool, json_name: "commitNow"
  field :ignore_index_conflict, 15, type: :bool, json_name: "ignoreIndexConflict"
end

defmodule Api.Operation do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :schema, 1, type: :string
  field :drop_attr, 2, type: :string, json_name: "dropAttr"
  field :drop_all, 3, type: :bool, json_name: "dropAll"
end

defmodule Api.Payload do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :Data, 1, type: :bytes
end

defmodule Api.TxnContext do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :start_ts, 1, type: :uint64, json_name: "startTs"
  field :commit_ts, 2, type: :uint64, json_name: "commitTs"
  field :aborted, 3, type: :bool
  field :keys, 4, repeated: true, type: :string
  field :preds, 5, repeated: true, type: :string
  field :lin_read, 13, type: Api.LinRead, json_name: "linRead"
end

defmodule Api.Check do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3
end

defmodule Api.Version do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :tag, 1, type: :string
end

defmodule Api.LinRead.IdsEntry do
  @moduledoc false

  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :uint32
  field :value, 2, type: :uint64
end

defmodule Api.LinRead do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :ids, 1, repeated: true, type: Api.LinRead.IdsEntry, map: true
  field :sequencing, 2, type: Api.LinRead.Sequencing, enum: true
end

defmodule Api.Latency do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :parsing_ns, 1, type: :uint64, json_name: "parsingNs"
  field :processing_ns, 2, type: :uint64, json_name: "processingNs"
  field :encoding_ns, 3, type: :uint64, json_name: "encodingNs"
end

defmodule Api.NQuad do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :subject, 1, type: :string
  field :predicate, 2, type: :string
  field :object_id, 3, type: :string, json_name: "objectId"
  field :object_value, 4, type: Api.Value, json_name: "objectValue"
  field :label, 5, type: :string
  field :lang, 6, type: :string
  field :facets, 7, repeated: true, type: Api.Facet
end

defmodule Api.Value do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  oneof(:val, 0)

  field :default_val, 1, type: :string, json_name: "defaultVal", oneof: 0
  field :bytes_val, 2, type: :bytes, json_name: "bytesVal", oneof: 0
  field :int_val, 3, type: :int64, json_name: "intVal", oneof: 0
  field :bool_val, 4, type: :bool, json_name: "boolVal", oneof: 0
  field :str_val, 5, type: :string, json_name: "strVal", oneof: 0
  field :double_val, 6, type: :double, json_name: "doubleVal", oneof: 0
  field :geo_val, 7, type: :bytes, json_name: "geoVal", oneof: 0
  field :date_val, 8, type: :bytes, json_name: "dateVal", oneof: 0
  field :datetime_val, 9, type: :bytes, json_name: "datetimeVal", oneof: 0
  field :password_val, 10, type: :string, json_name: "passwordVal", oneof: 0
  field :uid_val, 11, type: :uint64, json_name: "uidVal", oneof: 0
end

defmodule Api.Facet do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :bytes
  field :val_type, 3, type: Api.Facet.ValType, json_name: "valType", enum: true
  field :tokens, 4, repeated: true, type: :string
  field :alias, 5, type: :string
end

defmodule Api.SchemaNode do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :predicate, 1, type: :string
  field :type, 2, type: :string
  field :index, 3, type: :bool
  field :tokenizer, 4, repeated: true, type: :string
  field :reverse, 5, type: :bool
  field :count, 6, type: :bool
  field :list, 7, type: :bool
  field :upsert, 8, type: :bool
  field :lang, 9, type: :bool
end

defmodule Api.Dgraph.Service do
  @moduledoc false

  use GRPC.Service, name: "api.Dgraph", protoc_gen_elixir_version: "0.12.0"

  rpc(:Query, Api.Request, Api.Response)

  rpc(:Mutate, Api.Mutation, Api.Assigned)

  rpc(:Alter, Api.Operation, Api.Payload)

  rpc(:CommitOrAbort, Api.TxnContext, Api.TxnContext)

  rpc(:CheckVersion, Api.Check, Api.Version)
end

defmodule Api.Dgraph.Stub do
  @moduledoc false

  use GRPC.Stub, service: Api.Dgraph.Service
end
