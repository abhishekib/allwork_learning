import 'package:realm/realm.dart';
    part 'menu_detail_entity.realm.dart';

@RealmModel()
class _MenuDetailEntity {
  @PrimaryKey()
  late String endpoint;
  late _ApiResponseEntity? _apiResponseEntity; // List of category groups
}

@RealmModel()
// Define a top-level wrapper class
class _ApiResponseEntity{
  @PrimaryKey()
  late String id; // Unique identifier for the response

  late List<_KeyValueEntity> data; // Top-level data map
}


@RealmModel()
// Define a RealmObject for a generic key-value pair
class _KeyValueEntity{
  @PrimaryKey()
  late String key; // The key for the entry

  late String? stringValue; // Store string values
  late int? intValue; // Store integer values
  late double? doubleValue; // Store double values
  late bool? boolValue; // Store boolean values

  late List<_KeyValueEntity> nestedValues; // For nested objects
  late List<_KeyValueEntity> listValues; // For arrays
}


