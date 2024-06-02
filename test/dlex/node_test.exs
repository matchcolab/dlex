defmodule Dlex.NodeTest do
  use ExUnit.Case

  defmodule TestSchema do
    use Dlex.Node

    schema "test_schema" do
      field :name, :string, index: ["term"]
      field :age, :integer
      field :is_active, :bool
      field :data, :bytes
      field :tags, {:array, :string}
      field :preferences, :map
    end
  end

  describe "schema generation" do
    test "basic" do
      assert "test_schema" == TestSchema.__schema__(:source)
      assert :string == TestSchema.__schema__(:type, :name)
      assert :integer == TestSchema.__schema__(:type, :age)
      assert :bool == TestSchema.__schema__(:type, :is_active)
      assert :bytes == TestSchema.__schema__(:type, :data)
      assert {:array, :string} == TestSchema.__schema__(:type, :tags)
      assert :map == TestSchema.__schema__(:type, :preferences)

      assert [:name, :age, :is_active, :data, :tags, :preferences] ==
               TestSchema.__schema__(:fields)
    end

    test "alter" do
      alter_schema = TestSchema.__schema__(:alter)

      expected_schema = [
        %{
          "index" => true,
          "predicate" => "test_schema.name",
          "tokenizer" => ["term"],
          "type" => "string"
        },
        %{"predicate" => "test_schema.age", "type" => "int"},
        %{"predicate" => "test_schema.is_active", "type" => "bool"},
        %{"predicate" => "test_schema.data", "type" => "bytes"},
        %{"predicate" => "test_schema.tags", "type" => "[string]"},
        %{"predicate" => "test_schema.preferences", "type" => "map"}
      ]

      expected_types = [
        %{
          "fields" => [
            %{"name" => "test_schema.name", "type" => "string"},
            %{"name" => "test_schema.age", "type" => "int"},
            %{"name" => "test_schema.is_active", "type" => "bool"},
            %{"name" => "test_schema.data", "type" => "bytes"},
            %{"name" => "test_schema.tags", "type" => "[string]"},
            %{"name" => "test_schema.preferences", "type" => "map"}
          ],
          "name" => "test_schema"
        }
      ]

      assert %{"schema" => schema, "types" => types} = alter_schema
      assert Enum.sort(schema) == Enum.sort(expected_schema)

      sorted_types =
        Enum.map(types, fn type ->
          Map.update!(type, "fields", fn fields -> Enum.sort_by(fields, & &1["name"]) end)
        end)

      expected_sorted_types =
        Enum.map(expected_types, fn type ->
          Map.update!(type, "fields", fn fields -> Enum.sort_by(fields, & &1["name"]) end)
        end)

      assert Enum.sort_by(sorted_types, & &1["name"]) ==
               Enum.sort_by(expected_sorted_types, & &1["name"])
    end

    test "transformation callbacks" do
      assert "test_schema.name" == TestSchema.__schema__(:field, :name)
      assert {:name, :string} == TestSchema.__schema__(:field, "test_schema.name")
    end
  end
end
