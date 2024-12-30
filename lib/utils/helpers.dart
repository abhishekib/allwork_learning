import 'dart:developer';

import 'package:allwork/entities/menu_detail_entity.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/category_response.dart';
import 'package:allwork/modals/category_response2.dart';
import 'package:allwork/modals/content_data.dart';
import 'dart:math';
import 'dart:developer' as developer;

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
        cdataEntities: category.cdata
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

    log("Data saved is: $result");

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
}
