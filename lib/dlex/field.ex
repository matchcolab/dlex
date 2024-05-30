defmodule Dlex.Field do
  @type type ::
          :int
          | :float
          | :string
          | :geo
          | :datetime
          | :uid
          | :bool
          | :password
          | :default
          | {:lang, :string}
          | :auto

  @type t :: %__MODULE__{
          name: atom(),
          type: type(),
          db_name: String.t(),
          alter: map() | nil,
          opts: Keyword.t()
        }

  defstruct [:name, :type, :db_name, :alter, :opts]
end
