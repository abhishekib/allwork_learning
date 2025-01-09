import 'package:realm/realm.dart';
    part 'menu_detail_entity.realm.dart';
    
@RealmModel()
class _MenuDetailEntity {
  @PrimaryKey()
  late String endpoint;
  _ApiResponseEntity? apiResponseEntity; // List of category groups
}

@RealmModel()
// Define a top-level wrapper class
class _ApiResponseEntity {
  List<_KeyValueEntity> data = []; // Top-level data map
}

@RealmModel()
// Define a RealmObject for a generic key-value pair
class _KeyValueEntity {
  String? key; // The key for the entry

  String? stringValue; // Store string values
  int? intValue; // Store integer values
  double? doubleValue; // Store double values
  bool? boolValue; // Store boolean values

  List<_KeyValueEntity> nestedValues= []; // For nested objects
  List<_KeyValueEntity> listValues=[]; // For arrays
}
