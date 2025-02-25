// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_reminder_deep_link_data_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class BookmarkDataEntity extends _BookmarkDataEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  BookmarkDataEntity(
    String title,
    int lyricsType,
    int lyricsIndex, {
    CategoryEntity? category,
  }) {
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'lyricsType', lyricsType);
    RealmObjectBase.set(this, 'lyricsIndex', lyricsIndex);
  }

  BookmarkDataEntity._();

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  CategoryEntity? get category =>
      RealmObjectBase.get<CategoryEntity>(this, 'category') as CategoryEntity?;
  @override
  set category(covariant CategoryEntity? value) =>
      RealmObjectBase.set(this, 'category', value);

  @override
  int get lyricsType => RealmObjectBase.get<int>(this, 'lyricsType') as int;
  @override
  set lyricsType(int value) => RealmObjectBase.set(this, 'lyricsType', value);

  @override
  int get lyricsIndex => RealmObjectBase.get<int>(this, 'lyricsIndex') as int;
  @override
  set lyricsIndex(int value) => RealmObjectBase.set(this, 'lyricsIndex', value);

  @override
  Stream<RealmObjectChanges<BookmarkDataEntity>> get changes =>
      RealmObjectBase.getChanges<BookmarkDataEntity>(this);

  @override
  Stream<RealmObjectChanges<BookmarkDataEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<BookmarkDataEntity>(this, keyPaths);

  @override
  BookmarkDataEntity freeze() =>
      RealmObjectBase.freezeObject<BookmarkDataEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'title': title.toEJson(),
      'category': category.toEJson(),
      'lyricsType': lyricsType.toEJson(),
      'lyricsIndex': lyricsIndex.toEJson(),
    };
  }

  static EJsonValue _toEJson(BookmarkDataEntity value) => value.toEJson();
  static BookmarkDataEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'title': EJsonValue title,
        'lyricsType': EJsonValue lyricsType,
        'lyricsIndex': EJsonValue lyricsIndex,
      } =>
        BookmarkDataEntity(
          fromEJson(title),
          fromEJson(lyricsType),
          fromEJson(lyricsIndex),
          category: fromEJson(ejson['category']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(BookmarkDataEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, BookmarkDataEntity, 'BookmarkDataEntity', [
      SchemaProperty('title', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('category', RealmPropertyType.object,
          optional: true, linkTarget: 'CategoryEntity'),
      SchemaProperty('lyricsType', RealmPropertyType.int),
      SchemaProperty('lyricsIndex', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ReminderDataEntity extends _ReminderDataEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  ReminderDataEntity(
    String title, {
    CategoryEntity? category,
  }) {
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'category', category);
  }

  ReminderDataEntity._();

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  CategoryEntity? get category =>
      RealmObjectBase.get<CategoryEntity>(this, 'category') as CategoryEntity?;
  @override
  set category(covariant CategoryEntity? value) =>
      RealmObjectBase.set(this, 'category', value);

  @override
  Stream<RealmObjectChanges<ReminderDataEntity>> get changes =>
      RealmObjectBase.getChanges<ReminderDataEntity>(this);

  @override
  Stream<RealmObjectChanges<ReminderDataEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ReminderDataEntity>(this, keyPaths);

  @override
  ReminderDataEntity freeze() =>
      RealmObjectBase.freezeObject<ReminderDataEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'title': title.toEJson(),
      'category': category.toEJson(),
    };
  }

  static EJsonValue _toEJson(ReminderDataEntity value) => value.toEJson();
  static ReminderDataEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'title': EJsonValue title,
      } =>
        ReminderDataEntity(
          fromEJson(title),
          category: fromEJson(ejson['category']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ReminderDataEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ReminderDataEntity, 'ReminderDataEntity', [
      SchemaProperty('title', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('category', RealmPropertyType.object,
          optional: true, linkTarget: 'CategoryEntity'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class DeepLinkDataEntity extends _DeepLinkDataEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  DeepLinkDataEntity(
    String endpoint, {
    CategoryEntity? category,
  }) {
    RealmObjectBase.set(this, 'endpoint', endpoint);
    RealmObjectBase.set(this, 'category', category);
  }

  DeepLinkDataEntity._();

  @override
  String get endpoint =>
      RealmObjectBase.get<String>(this, 'endpoint') as String;
  @override
  set endpoint(String value) => RealmObjectBase.set(this, 'endpoint', value);

  @override
  CategoryEntity? get category =>
      RealmObjectBase.get<CategoryEntity>(this, 'category') as CategoryEntity?;
  @override
  set category(covariant CategoryEntity? value) =>
      RealmObjectBase.set(this, 'category', value);

  @override
  Stream<RealmObjectChanges<DeepLinkDataEntity>> get changes =>
      RealmObjectBase.getChanges<DeepLinkDataEntity>(this);

  @override
  Stream<RealmObjectChanges<DeepLinkDataEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<DeepLinkDataEntity>(this, keyPaths);

  @override
  DeepLinkDataEntity freeze() =>
      RealmObjectBase.freezeObject<DeepLinkDataEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'endpoint': endpoint.toEJson(),
      'category': category.toEJson(),
    };
  }

  static EJsonValue _toEJson(DeepLinkDataEntity value) => value.toEJson();
  static DeepLinkDataEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'endpoint': EJsonValue endpoint,
      } =>
        DeepLinkDataEntity(
          fromEJson(endpoint),
          category: fromEJson(ejson['category']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(DeepLinkDataEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, DeepLinkDataEntity, 'DeepLinkDataEntity', [
      SchemaProperty('endpoint', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('category', RealmPropertyType.object,
          optional: true, linkTarget: 'CategoryEntity'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class CategoryEntity extends _CategoryEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  CategoryEntity(
    String category,
    String postType,
    int id,
    String menuItem,
    String title,
    String link,
    String isFav,
    String data, {
    Iterable<ContentDataEntity> cData = const [],
  }) {
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'postType', postType);
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'menuItem', menuItem);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'link', link);
    RealmObjectBase.set(this, 'isFav', isFav);
    RealmObjectBase.set<RealmList<ContentDataEntity>>(
        this, 'cData', RealmList<ContentDataEntity>(cData));
    RealmObjectBase.set(this, 'data', data);
  }

  CategoryEntity._();

  @override
  String get category =>
      RealmObjectBase.get<String>(this, 'category') as String;
  @override
  set category(String value) => RealmObjectBase.set(this, 'category', value);

  @override
  String get postType =>
      RealmObjectBase.get<String>(this, 'postType') as String;
  @override
  set postType(String value) => RealmObjectBase.set(this, 'postType', value);

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get menuItem =>
      RealmObjectBase.get<String>(this, 'menuItem') as String;
  @override
  set menuItem(String value) => RealmObjectBase.set(this, 'menuItem', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get link => RealmObjectBase.get<String>(this, 'link') as String;
  @override
  set link(String value) => RealmObjectBase.set(this, 'link', value);

  @override
  String get isFav => RealmObjectBase.get<String>(this, 'isFav') as String;
  @override
  set isFav(String value) => RealmObjectBase.set(this, 'isFav', value);

  @override
  RealmList<ContentDataEntity> get cData =>
      RealmObjectBase.get<ContentDataEntity>(this, 'cData')
          as RealmList<ContentDataEntity>;
  @override
  set cData(covariant RealmList<ContentDataEntity> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get data => RealmObjectBase.get<String>(this, 'data') as String;
  @override
  set data(String value) => RealmObjectBase.set(this, 'data', value);

  @override
  Stream<RealmObjectChanges<CategoryEntity>> get changes =>
      RealmObjectBase.getChanges<CategoryEntity>(this);

  @override
  Stream<RealmObjectChanges<CategoryEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<CategoryEntity>(this, keyPaths);

  @override
  CategoryEntity freeze() => RealmObjectBase.freezeObject<CategoryEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'category': category.toEJson(),
      'postType': postType.toEJson(),
      'id': id.toEJson(),
      'menuItem': menuItem.toEJson(),
      'title': title.toEJson(),
      'link': link.toEJson(),
      'isFav': isFav.toEJson(),
      'cData': cData.toEJson(),
      'data': data.toEJson(),
    };
  }

  static EJsonValue _toEJson(CategoryEntity value) => value.toEJson();
  static CategoryEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'category': EJsonValue category,
        'postType': EJsonValue postType,
        'id': EJsonValue id,
        'menuItem': EJsonValue menuItem,
        'title': EJsonValue title,
        'link': EJsonValue link,
        'isFav': EJsonValue isFav,
        'data': EJsonValue data,
      } =>
        CategoryEntity(
          fromEJson(category),
          fromEJson(postType),
          fromEJson(id),
          fromEJson(menuItem),
          fromEJson(title),
          fromEJson(link),
          fromEJson(isFav),
          fromEJson(data),
          cData: fromEJson(ejson['cData']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(CategoryEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, CategoryEntity, 'CategoryEntity', [
      SchemaProperty('category', RealmPropertyType.string),
      SchemaProperty('postType', RealmPropertyType.string),
      SchemaProperty('id', RealmPropertyType.int),
      SchemaProperty('menuItem', RealmPropertyType.string),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('link', RealmPropertyType.string),
      SchemaProperty('isFav', RealmPropertyType.string),
      SchemaProperty('cData', RealmPropertyType.object,
          linkTarget: 'ContentDataEntity',
          collectionType: RealmCollectionType.list),
      SchemaProperty('data', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ContentDataEntity extends _ContentDataEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  ContentDataEntity(
    String type,
    String audiourl,
    String offlineAudioPath, {
    Iterable<LyricsEntity> lyrics = const [],
  }) {
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'audiourl', audiourl);
    RealmObjectBase.set(this, 'offlineAudioPath', offlineAudioPath);
    RealmObjectBase.set<RealmList<LyricsEntity>>(
        this, 'lyrics', RealmList<LyricsEntity>(lyrics));
  }

  ContentDataEntity._();

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  String get audiourl =>
      RealmObjectBase.get<String>(this, 'audiourl') as String;
  @override
  set audiourl(String value) => RealmObjectBase.set(this, 'audiourl', value);

  @override
  String get offlineAudioPath =>
      RealmObjectBase.get<String>(this, 'offlineAudioPath') as String;
  @override
  set offlineAudioPath(String value) =>
      RealmObjectBase.set(this, 'offlineAudioPath', value);

  @override
  RealmList<LyricsEntity> get lyrics =>
      RealmObjectBase.get<LyricsEntity>(this, 'lyrics')
          as RealmList<LyricsEntity>;
  @override
  set lyrics(covariant RealmList<LyricsEntity> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<ContentDataEntity>> get changes =>
      RealmObjectBase.getChanges<ContentDataEntity>(this);

  @override
  Stream<RealmObjectChanges<ContentDataEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ContentDataEntity>(this, keyPaths);

  @override
  ContentDataEntity freeze() =>
      RealmObjectBase.freezeObject<ContentDataEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'type': type.toEJson(),
      'audiourl': audiourl.toEJson(),
      'offlineAudioPath': offlineAudioPath.toEJson(),
      'lyrics': lyrics.toEJson(),
    };
  }

  static EJsonValue _toEJson(ContentDataEntity value) => value.toEJson();
  static ContentDataEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'type': EJsonValue type,
        'audiourl': EJsonValue audiourl,
        'offlineAudioPath': EJsonValue offlineAudioPath,
      } =>
        ContentDataEntity(
          fromEJson(type),
          fromEJson(audiourl),
          fromEJson(offlineAudioPath),
          lyrics: fromEJson(ejson['lyrics']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ContentDataEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ContentDataEntity, 'ContentDataEntity', [
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('audiourl', RealmPropertyType.string),
      SchemaProperty('offlineAudioPath', RealmPropertyType.string),
      SchemaProperty('lyrics', RealmPropertyType.object,
          linkTarget: 'LyricsEntity', collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class LyricsEntity extends _LyricsEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  LyricsEntity(
    String time,
    String arabic,
    String translitration,
    String translation,
    String english,
  ) {
    RealmObjectBase.set(this, 'time', time);
    RealmObjectBase.set(this, 'arabic', arabic);
    RealmObjectBase.set(this, 'translitration', translitration);
    RealmObjectBase.set(this, 'translation', translation);
    RealmObjectBase.set(this, 'english', english);
  }

  LyricsEntity._();

  @override
  String get time => RealmObjectBase.get<String>(this, 'time') as String;
  @override
  set time(String value) => RealmObjectBase.set(this, 'time', value);

  @override
  String get arabic => RealmObjectBase.get<String>(this, 'arabic') as String;
  @override
  set arabic(String value) => RealmObjectBase.set(this, 'arabic', value);

  @override
  String get translitration =>
      RealmObjectBase.get<String>(this, 'translitration') as String;
  @override
  set translitration(String value) =>
      RealmObjectBase.set(this, 'translitration', value);

  @override
  String get translation =>
      RealmObjectBase.get<String>(this, 'translation') as String;
  @override
  set translation(String value) =>
      RealmObjectBase.set(this, 'translation', value);

  @override
  String get english => RealmObjectBase.get<String>(this, 'english') as String;
  @override
  set english(String value) => RealmObjectBase.set(this, 'english', value);

  @override
  Stream<RealmObjectChanges<LyricsEntity>> get changes =>
      RealmObjectBase.getChanges<LyricsEntity>(this);

  @override
  Stream<RealmObjectChanges<LyricsEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<LyricsEntity>(this, keyPaths);

  @override
  LyricsEntity freeze() => RealmObjectBase.freezeObject<LyricsEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'time': time.toEJson(),
      'arabic': arabic.toEJson(),
      'translitration': translitration.toEJson(),
      'translation': translation.toEJson(),
      'english': english.toEJson(),
    };
  }

  static EJsonValue _toEJson(LyricsEntity value) => value.toEJson();
  static LyricsEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'time': EJsonValue time,
        'arabic': EJsonValue arabic,
        'translitration': EJsonValue translitration,
        'translation': EJsonValue translation,
        'english': EJsonValue english,
      } =>
        LyricsEntity(
          fromEJson(time),
          fromEJson(arabic),
          fromEJson(translitration),
          fromEJson(translation),
          fromEJson(english),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(LyricsEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, LyricsEntity, 'LyricsEntity', [
      SchemaProperty('time', RealmPropertyType.string),
      SchemaProperty('arabic', RealmPropertyType.string),
      SchemaProperty('translitration', RealmPropertyType.string),
      SchemaProperty('translation', RealmPropertyType.string),
      SchemaProperty('english', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
