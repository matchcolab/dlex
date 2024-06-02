### Dgraph supports various data types that allow for flexible and powerful schema definitions. Here is a list of the supported types:

#### Scalar Types:
  string: A sequence of characters.
  int: An integer value.
  float: A floating-point number.
  bool: A boolean value (true or false).
  datetime: Date and time values.
  geo: Geospatial data (e.g., points, polygons).
  password: A hashed password string.

#### Collection Types:
  list: A list of values of a specific type.
  set: A set of unique values of a specific type.

#### Uid Type:
  uid: A unique identifier used to represent edges between nodes.

#### Default Types:
  default: Used for predicates where the type is not explicitly specified. This type is inferred based on the data provided.

#### Other Types:
  dateTime: Another notation for datetime values.
  default: This type is used when the type is not specified and will be inferred from the provided data.
