import 'dart:developer';

import 'package:allwork/entities/menu_detail_entity.dart';
import 'package:allwork/modals/api_response_handler.dart';
import 'dart:developer' as developer;

import 'package:realm/realm.dart';

Future<String> getUserTimeZone() async {
  try {
    final now = DateTime.now();
    final timeZoneOffset = now.timeZoneOffset;
    final hours = timeZoneOffset.inHours.abs().toString().padLeft(2, '0');
    final minutes =
        (timeZoneOffset.inMinutes % 60).abs().toString().padLeft(2, '0');
    final sign = timeZoneOffset.isNegative ? '-' : '+';
    final formattedTimeZone = 'UTC$sign$hours:$minutes';

    final timeZoneName = now.timeZoneName;

    return timeZoneName;
  } catch (e) {
    throw Exception('Error fetching user timezone: $e');
  }
}

class MenuDetailsHelpers {
  static MenuDetailEntity toMenuDetailEntity(
      String endpoint, ApiResponseHandler apiResponsehandler) {
    developer.log("Converting to MenuDetailEntity");
    return MenuDetailEntity(endpoint,
        apiResponseEntity: _convertToApiResponseEntity(apiResponsehandler));
  }

  // Helper function to convert ApiResponseHandler to _ApiResponseEntity
  static ApiResponseEntity _convertToApiResponseEntity(
      ApiResponseHandler handler) {
    developer.log("Converting to ApiResponseEntity");
    return ApiResponseEntity(data: _convertMapToKeyValueEntities(handler.data));
  }

  static List<KeyValueEntity> _convertMapToKeyValueEntities(
      Map<String, dynamic> map) {
    developer.log("converting map to key value entities");
    List<KeyValueEntity> entities = [];

    map.forEach((key, value) {
      List<KeyValueEntity> nestedValues = [];
      List<KeyValueEntity> listValues = [];
      String? stringValue;
      int? intValue;
      double? doubleValue;
      bool? boolValue;
      //KeyValueEntity entity = KeyValueEntity();
      //entity.key = key;

      if (value is Map<String, dynamic>) {
        //entity.nestedValues = _convertMapToKeyValueEntities(value);
        nestedValues = _convertMapToKeyValueEntities(value);
      } else if (value is List) {
        //entity.listValues = _convertListToKeyValueEntities(value);
        log("====================================");
        log("converting list to key value entities");
        log(key);
        log(value.toString());
        log("====================================");
        listValues = _convertListToKeyValueEntities(value);
      } else {
        // Assign primitive values to the corresponding fields
        if (value is String) {
          //entity.stringValue = value;
          stringValue = value;
        } else if (value is int) {
          //entity.intValue = value;
          intValue = value;
        } else if (value is double) {
          //entity.doubleValue = value;
          doubleValue = value;
        } else if (value is bool) {
          //entity.boolValue = value;
          boolValue = value;
        }
      }
      KeyValueEntity entity = KeyValueEntity(
          key: key,
          nestedValues: RealmList<KeyValueEntity>(nestedValues),
          listValues: RealmList<KeyValueEntity>(listValues),
          stringValue: stringValue,
          intValue: intValue,
          doubleValue: doubleValue,
          boolValue: boolValue);

      entities.add(entity);
    });
    return entities;
  }

  static List<KeyValueEntity> _convertListToKeyValueEntities(
      List<dynamic> list) {
    developer.log("converting list to key value entities");
    List<KeyValueEntity> entities = [];
    for (var item in list) {
      //KeyValueEntity entity = KeyValueEntity();
      List<KeyValueEntity> nestedValues = [];
      List<KeyValueEntity> listValues = [];
      String? stringValue;
      int? intValue;
      double? doubleValue;
      bool? boolValue;
      if (item is Map<String, dynamic>) {
        //entity.nestedValues = _convertMapToKeyValueEntities(item);
        nestedValues = _convertMapToKeyValueEntities(item);
      } else if (item is List) {
        //entity.listValues = _convertListToKeyValueEntities(item);
        listValues = _convertListToKeyValueEntities(item);
      } else {
        // Handle primitive values in lists similarly
        if (item is String) {
          //entity.stringValue = item;
          stringValue = item;
        } else if (item is int) {
          //entity.intValue = item;
          intValue = item;
        } else if (item is double) {
          //entity.doubleValue = item;
          doubleValue = item;
        } else if (item is bool) {
          //entity.boolValue = item;
          boolValue = item;
        }
      }
      KeyValueEntity entity = KeyValueEntity(
          nestedValues: RealmList<KeyValueEntity>(nestedValues),
          listValues: RealmList<KeyValueEntity>(listValues),
          stringValue: stringValue,
          intValue: intValue,
          doubleValue: doubleValue,
          boolValue: boolValue);
      entities.add(entity);
    }
    return entities;
  }

// Helper function to convert _ApiResponseEntity back to ApiResponseHandler
  static ApiResponseHandler convertToApiResponseHandler(
      ApiResponseEntity entity) {
    Map<String, dynamic> dataMap = _convertKeyValueEntitiesToMap(entity.data);
    //before this line, exception is coming
    developer.log("data map: $dataMap");
    return ApiResponseHandler(data: dataMap);
  }

//exception is coming here
  static Map<String, dynamic> _convertKeyValueEntitiesToMap(
      RealmList<KeyValueEntity> entities) {
    log("Converting key value entities to map");
    Map<String, dynamic> map = {};
    for (KeyValueEntity entity in entities) {
      dynamic value;
      if (entity.nestedValues.isNotEmpty) {
        value = _convertKeyValueEntitiesToMap(entity.nestedValues);
      } else if (entity.listValues.isNotEmpty) {
        value = _convertKeyValueEntitiesToList(entity.listValues);
      } else {
        // Assign primitive values from the corresponding fields
        if (entity.stringValue != null) {
          value = entity.stringValue;
        } else if (entity.intValue != null) {
          value = entity.intValue;
        } else if (entity.doubleValue != null) {
          value = entity.doubleValue;
        } else if (entity.boolValue != null) {
          value = entity.boolValue;
        }
      }
      //exception is here
      if (entity.key != null) {
        map[entity.key!] = value;
      }
    }
    return map;
  }

  static List<dynamic> _convertKeyValueEntitiesToList(
      RealmList<KeyValueEntity> entities) {
    log("Converting key value entities to map");
    List<dynamic> list = [];
    for (KeyValueEntity entity in entities) {
      if (entity.nestedValues.isNotEmpty) {
        list.add(_convertKeyValueEntitiesToMap(entity.nestedValues));
      } else if (entity.listValues.isNotEmpty) {
        list.add(_convertKeyValueEntitiesToList(entity.listValues));
      } else {
        // Append primitive values directly to the list
        if (entity.stringValue != null) {
          list.add(entity.stringValue);
        } else if (entity.intValue != null) {
          list.add(entity.intValue);
        } else if (entity.doubleValue != null) {
          list.add(entity.doubleValue);
        } else if (entity.boolValue != null) {
          list.add(entity.boolValue);
        }
      }
    }
    return list;
  }
}
