import 'package:allwork/entities/menu_detail_entity.dart';
import 'package:allwork/modals/api_response_handler.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/content_data.dart';
import 'dart:math';
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

/*
class MenuDetailsHelpers {
  static final List<int> _ran = [];

  static LyricsEntity _toLyricsEntity(Lyrics lyrics) {
    return LyricsEntity(
        lyrics.time, lyrics.arabic, lyrics.translitration, lyrics.translation);
  }

  static Lyrics _toLyrics(LyricsEntity lyricsEntity) {
    return Lyrics(
        time: lyricsEntity.time,
        arabic: lyricsEntity.arabic,
        translitration: lyricsEntity.transliteration,
        translation: lyricsEntity.translation);
  }

  static ContentDataEntity _toContentDataEntity(ContentData contentData) {
    var random = Random();
    int ranNum;
    do {
      ranNum = random.nextInt(4294967296);
    } while (_ran.contains(ranNum));

//generate a random primary key
    _ran.add(ranNum);

    developer.log("I am getting called");

    return ContentDataEntity(ranNum, contentData.type, contentData.audiourl,
        lyricsEntities:
            contentData.lyrics.map((lyric) => _toLyricsEntity(lyric)).toList());
  }

  static ContentData _toContentData(ContentDataEntity contentDataEntity) {
    developer.log("content data entity assigned to id ${contentDataEntity.id}");
    return ContentData(
       id: contentDataEntity.id,
        type: contentDataEntity.type,
        audiourl: contentDataEntity.audiourl,
        offlineAudioPath: contentDataEntity.offlineAudioUrl,
        lyrics: contentDataEntity.lyricsEntities
            .map((lyricEntity) => _toLyrics(lyricEntity))
            .toList());
  }

  static CategoryEntity _toCategoryEntity(Category category) {
    return CategoryEntity(category.id, category.category, category.title,
        isFav: category.isFav,
        cdataEntities: category.cdata!
            .map((cdata) => _toContentDataEntity(cdata))
            .toList());
  }

  static Category _toCategory(CategoryEntity categoryEntity) {
    return Category(
        category: categoryEntity.category,
        id: categoryEntity.id,
        title: categoryEntity.title,
        isFav: categoryEntity.isFav ?? '',
        cdata: categoryEntity.cdataEntities
            .map((cdata) => _toContentData(cdata))
            .toList());
  }

  static CategoryGroupEntity _toCategoryGroupEntity(
      MapEntry<String, List<Category>> category) {
    return CategoryGroupEntity(category.key,
        categoryEntities: category.value
            .map((category) => _toCategoryEntity(category))
            .toList());
  }

  static MapEntry<String, List<Category>> _toMapEntry(
      CategoryGroupEntity categoryGroupEntity) {
    return MapEntry<String, List<Category>>(
        categoryGroupEntity.groupName,
        categoryGroupEntity.categoryEntities
            .map((categoryEntity) => _toCategory(categoryEntity))
            .toList());
  }

/*
  static MenuDetailEntity toMenuDetailEntity(
      String endpoint, CategoryResponse categoryResponse) {
    List<CategoryGroupEntity> categoryGroups = categoryResponse
        .categories.entries
        .map((e) => _toCategoryGroupEntity(e))
        .toList();
    return MenuDetailEntity(endpoint, categoryGroups: categoryGroups);
  }

  static MenuDetailEntityNested toMenuDetailEntityNested(
      String endpoint, CategoryResponse2 categoryResponse2) {
    List<MenuDetailEntity> menuDetailEntities = [];

    menuDetailEntities.add(toMenuDetailEntity(
        categoryResponse2.ziyarat14Masoomeen.keys.elementAt(0),
        categoryResponse2.ziyarat14Masoomeen[
            categoryResponse2.ziyarat14Masoomeen.keys.elementAt(0)]!));

    MenuDetailEntity others =
        toMenuDetailEntity(endpoint, categoryResponse2.otherZiyarats);

    MenuDetailEntityNested result = MenuDetailEntityNested(endpoint,
        menuDetailEntity: menuDetailEntities, others: others);

    developer.log("Data saved is: $result");

    return result;
  }

 static CategoryResponse2 toCategoryResponse2(MenuDetailEntityNested menuDetailEntityNested) {
    // Map to store the ziyarat14Masoomeen using the MenuDetailEntity list
    Map<String, CategoryResponse> ziyarat14Masoomeen = {};

    // Assuming that there is only one key in the MenuDetailEntity corresponding to ziyarat14Masoomeen
    String keyFor14Masoomeen = menuDetailEntityNested.menuDetailEntity.first.endpoint;

    CategoryResponse responseFor14Masoomeen = toCategoryResponse(menuDetailEntityNested.menuDetailEntity.first);

    ziyarat14Masoomeen[keyFor14Masoomeen] = responseFor14Masoomeen;

    // Convert the 'others' MenuDetailEntity to a CategoryResponse
    CategoryResponse otherZiyaratsResponse = toCategoryResponse(menuDetailEntityNested.others!);

    // Create a CategoryResponse2 object with the constructed maps
    CategoryResponse2 categoryResponse2 = CategoryResponse2(
      ziyarat14Masoomeen: ziyarat14Masoomeen,
      otherZiyarats: otherZiyaratsResponse
    );

    //log("Converted to CategoryResponse2: $categoryResponse2");
    return categoryResponse2;
  }


  static CategoryResponse toCategoryResponse(
      MenuDetailEntity menuDetailEntity) {
    Map<String, List<Category>> categories = Map.fromEntries(menuDetailEntity
        .categoryGroups
        .map((categoryGroupEntity) => _toMapEntry(categoryGroupEntity)));
    return CategoryResponse(categories: categories);
  }
*/
}
*/
class MenuDetailsHelpers {
  static MenuDetailEntity toMenuDetailEntity(
      String endpoint, ApiResponseHandler apiResponsehandler) {
    return MenuDetailEntity(endpoint,
        apiResponseEntity: _convertToApiResponseEntity(apiResponsehandler));
  }

  // Helper function to convert ApiResponseHandler to _ApiResponseEntity
  static ApiResponseEntity _convertToApiResponseEntity(
      ApiResponseHandler handler) {
    return ApiResponseEntity()
      ..data = _convertMapToKeyValueEntities(handler.data);
  }

  static RealmList<KeyValueEntity> _convertMapToKeyValueEntities(
      Map<String, dynamic> map) {
    List<KeyValueEntity> entities = [];
    map.forEach((key, value) {
      KeyValueEntity entity = KeyValueEntity();
      entity.key = key;

      if (value is Map<String, dynamic>) {
        entity.nestedValues = _convertMapToKeyValueEntities(value);
      } else if (value is List) {
        entity.listValues = _convertListToKeyValueEntities(value);
      } else {
        // Assign primitive values to the corresponding fields
        if (value is String) {
          entity.stringValue = value;
        } else if (value is int) {
          entity.intValue = value;
        } else if (value is double) {
          entity.doubleValue = value;
        } else if (value is bool) {
          entity.boolValue = value;
        }
      }
      entities.add(entity);
    });
    return RealmList<KeyValueEntity>(entities);
  }

  static RealmList<KeyValueEntity> _convertListToKeyValueEntities(
      List<dynamic> list) {
    List<KeyValueEntity> entities = [];
    for (var item in list) {
      KeyValueEntity entity = KeyValueEntity();
      if (item is Map<String, dynamic>) {
        entity.nestedValues = _convertMapToKeyValueEntities(item);
      } else if (item is List) {
        entity.listValues = _convertListToKeyValueEntities(item);
      } else {
        // Handle primitive values in lists similarly
        if (item is String) {
          entity.stringValue = item;
        } else if (item is int) {
          entity.intValue = item;
        } else if (item is double) {
          entity.doubleValue = item;
        } else if (item is bool) {
          entity.boolValue = item;
        }
      }
      entities.add(entity);
    }
    return RealmList<KeyValueEntity>(entities);
  }

// Helper function to convert _ApiResponseEntity back to ApiResponseHandler
static ApiResponseHandler convertToApiResponseHandler(ApiResponseEntity entity) {
  Map<String, dynamic> dataMap = _convertKeyValueEntitiesToMap(entity.data);
  return ApiResponseHandler(data: dataMap);
}

static Map<String, dynamic> _convertKeyValueEntitiesToMap(RealmList<KeyValueEntity> entities) {
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
    map[entity.key!] = value;
  }
  return map;
}

static List<dynamic> _convertKeyValueEntitiesToList(RealmList<KeyValueEntity> entities) {
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
