alias Dlex.Api

defmodule Api.Request.RespFormat do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :JSON, 0
  field :RDF, 1
end

defmodule Api.Operation.DropOp do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :NONE, 0
  field :ALL, 1
  field :DATA, 2
  field :ATTR, 3
  field :TYPE, 4
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

  field :start_ts, 1, type: :uint64, json_name: "startTs"
  field :query, 4, type: :string
  field :vars, 5, repeated: true, type: Api.Request.VarsEntry, map: true
  field :read_only, 6, type: :bool, json_name: "readOnly"
  field :best_effort, 7, type: :bool, json_name: "bestEffort"
  field :mutations, 12, repeated: true, type: Api.Mutation
  field :commit_now, 13, type: :bool, json_name: "commitNow"
  field :resp_format, 14, type: Api.Request.RespFormat, json_name: "respFormat", enum: true
  field :hash, 15, type: :string
end

defmodule Api.Uids do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :uids, 1, repeated: true, type: :string
end

defmodule Api.ListOfString do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :value, 1, repeated: true, type: :string
end

defmodule Api.Response.UidsEntry do
  @moduledoc false

  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end

defmodule Api.Response.HdrsEntry do
  @moduledoc false

  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Api.ListOfString
end

defmodule Api.Response do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :json, 1, type: :bytes
  field :txn, 2, type: Api.TxnContext
  field :latency, 3, type: Api.Latency
  field :metrics, 4, type: Api.Metrics
  field :uids, 12, repeated: true, type: Api.Response.UidsEntry, map: true
  field :rdf, 13, type: :bytes
  field :hdrs, 14, repeated: true, type: Api.Response.HdrsEntry, map: true
end

defmodule Api.Mutation do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :set_json, 1, type: :bytes, json_name: "setJson"
  field :delete_json, 2, type: :bytes, json_name: "deleteJson"
  field :set_nquads, 3, type: :bytes, json_name: "setNquads"
  field :del_nquads, 4, type: :bytes, json_name: "delNquads"
  field :set, 5, repeated: true, type: Api.NQuad
  field :del, 6, repeated: true, type: Api.NQuad
  field :cond, 9, type: :string
  field :commit_now, 14, type: :bool, json_name: "commitNow"
end

defmodule Api.Operation do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :schema, 1, type: :string
  field :drop_attr, 2, type: :string, json_name: "dropAttr"
  field :drop_all, 3, type: :bool, json_name: "dropAll"
  field :drop_op, 4, type: Api.Operation.DropOp, json_name: "dropOp", enum: true
  field :drop_value, 5, type: :string, json_name: "dropValue"
  field :run_in_background, 6, type: :bool, json_name: "runInBackground"
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
  field :hash, 6, type: :string
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

defmodule Api.Latency do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :parsing_ns, 1, type: :uint64, json_name: "parsingNs"
  field :processing_ns, 2, type: :uint64, json_name: "processingNs"
  field :encoding_ns, 3, type: :uint64, json_name: "encodingNs"
  field :assign_timestamp_ns, 4, type: :uint64, json_name: "assignTimestampNs"
  field :total_ns, 5, type: :uint64, json_name: "totalNs"
end

defmodule Api.Metrics.NumUidsEntry do
  @moduledoc false

  use Protobuf, map: true, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :uint64
end

defmodule Api.Metrics do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :num_uids, 1,
    repeated: true,
    type: Api.Metrics.NumUidsEntry,
    json_name: "numUids",
    map: true
end

defmodule Api.NQuad do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :subject, 1, type: :string
  field :predicate, 2, type: :string
  field :object_id, 3, type: :string, json_name: "objectId"
  field :object_value, 4, type: Api.Value, json_name: "objectValue"
  field :lang, 6, type: :string
  field :facets, 7, repeated: true, type: Api.Facet
  field :namespace, 8, type: :uint64
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
  field :vfloat32_val, 13, type: :bytes, json_name: "vfloat32Val", oneof: 0
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

defmodule Api.LoginRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :userid, 1, type: :string
  field :password, 2, type: :string
  field :refresh_token, 3, type: :string, json_name: "refreshToken"
  field :namespace, 4, type: :uint64
end

defmodule Api.Jwt do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :access_jwt, 1, type: :string, json_name: "accessJwt"
  field :refresh_jwt, 2, type: :string, json_name: "refreshJwt"
end

defmodule Api.Dgraph.Service do
  @moduledoc false

  use GRPC.Service, name: "api.Dgraph", protoc_gen_elixir_version: "0.12.0"

  rpc(:Login, Api.LoginRequest, Api.Response)

  rpc(:Query, Api.Request, Api.Response)

  rpc(:Alter, Api.Operation, Api.Payload)

  rpc(:CommitOrAbort, Api.TxnContext, Api.TxnContext)

  rpc(:CheckVersion, Api.Check, Api.Version)
end

defmodule Api.Dgraph.Stub do
  @moduledoc false

  use GRPC.Stub, service: Api.Dgraph.Service
end
