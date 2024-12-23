import 'package:allwork/entities/menu_detail_entity.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/modals/category_response.dart';
import 'package:allwork/modals/content_data.dart';

class MenuDetailsHelpers {
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
    return ContentDataEntity(contentData.type, contentData.audiourl,
        lyricsEntities:
            contentData.lyrics.map((lyric) => _toLyricsEntity(lyric)).toList());
  }

  static ContentData _toContentData(ContentDataEntity contentDataEntity) {
    return ContentData(
        type: contentDataEntity.type,
        audiourl: contentDataEntity.audiourl,
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

  static CategoryResponse toCategoryResponse(
      MenuDetailEntity menuDetailEntity) {
    Map<String, List<Category>> categories = Map.fromEntries(menuDetailEntity
        .categoryGroups
        .map((categoryGroupEntity) => _toMapEntry(categoryGroupEntity)));
    return CategoryResponse(categories: categories);
  }
}
