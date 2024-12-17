// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_detail_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class MenuDetailEntity extends _MenuDetailEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  MenuDetailEntity(
    String endpoint, {
    Iterable<CategoryGroupEntity> categoryGroups = const [],
  }) {
    RealmObjectBase.set(this, 'endpoint', endpoint);
    RealmObjectBase.set<RealmList<CategoryGroupEntity>>(
        this, 'categoryGroups', RealmList<CategoryGroupEntity>(categoryGroups));
  }

  MenuDetailEntity._();

  @override
  String get endpoint =>
      RealmObjectBase.get<String>(this, 'endpoint') as String;
  @override
  set endpoint(String value) => RealmObjectBase.set(this, 'endpoint', value);

  @override
  RealmList<CategoryGroupEntity> get categoryGroups =>
      RealmObjectBase.get<CategoryGroupEntity>(this, 'categoryGroups')
          as RealmList<CategoryGroupEntity>;
  @override
  set categoryGroups(covariant RealmList<CategoryGroupEntity> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<MenuDetailEntity>> get changes =>
      RealmObjectBase.getChanges<MenuDetailEntity>(this);

  @override
  Stream<RealmObjectChanges<MenuDetailEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<MenuDetailEntity>(this, keyPaths);

  @override
  MenuDetailEntity freeze() =>
      RealmObjectBase.freezeObject<MenuDetailEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'endpoint': endpoint.toEJson(),
      'categoryGroups': categoryGroups.toEJson(),
    };
  }

  static EJsonValue _toEJson(MenuDetailEntity value) => value.toEJson();
  static MenuDetailEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'endpoint': EJsonValue endpoint,
      } =>
        MenuDetailEntity(
          fromEJson(endpoint),
          categoryGroups: fromEJson(ejson['categoryGroups']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(MenuDetailEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, MenuDetailEntity, 'MenuDetailEntity', [
      SchemaProperty('endpoint', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('categoryGroups', RealmPropertyType.object,
          linkTarget: 'CategoryGroupEntity',
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class CategoryGroupEntity extends _CategoryGroupEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  CategoryGroupEntity(
    String groupName, {
    Iterable<CategoryEntity> categoryEntities = const [],
  }) {
    RealmObjectBase.set(this, 'groupName', groupName);
    RealmObjectBase.set<RealmList<CategoryEntity>>(
        this, 'categoryEntities', RealmList<CategoryEntity>(categoryEntities));
  }

  CategoryGroupEntity._();

  @override
  String get groupName =>
      RealmObjectBase.get<String>(this, 'groupName') as String;
  @override
  set groupName(String value) => RealmObjectBase.set(this, 'groupName', value);

  @override
  RealmList<CategoryEntity> get categoryEntities =>
      RealmObjectBase.get<CategoryEntity>(this, 'categoryEntities')
          as RealmList<CategoryEntity>;
  @override
  set categoryEntities(covariant RealmList<CategoryEntity> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<CategoryGroupEntity>> get changes =>
      RealmObjectBase.getChanges<CategoryGroupEntity>(this);

  @override
  Stream<RealmObjectChanges<CategoryGroupEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<CategoryGroupEntity>(this, keyPaths);

  @override
  CategoryGroupEntity freeze() =>
      RealmObjectBase.freezeObject<CategoryGroupEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'groupName': groupName.toEJson(),
      'categoryEntities': categoryEntities.toEJson(),
    };
  }

  static EJsonValue _toEJson(CategoryGroupEntity value) => value.toEJson();
  static CategoryGroupEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'groupName': EJsonValue groupName,
      } =>
        CategoryGroupEntity(
          fromEJson(groupName),
          categoryEntities: fromEJson(ejson['categoryEntities']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(CategoryGroupEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, CategoryGroupEntity, 'CategoryGroupEntity', [
      SchemaProperty('groupName', RealmPropertyType.string),
      SchemaProperty('categoryEntities', RealmPropertyType.object,
          linkTarget: 'CategoryEntity',
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class CategoryEntity extends _CategoryEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  CategoryEntity(
    int id,
    String category,
    String title, {
    String? isFav,
    Iterable<ContentDataEntity> cdataEntities = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'isFav', isFav);
    RealmObjectBase.set<RealmList<ContentDataEntity>>(
        this, 'cdataEntities', RealmList<ContentDataEntity>(cdataEntities));
  }

  CategoryEntity._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get category =>
      RealmObjectBase.get<String>(this, 'category') as String;
  @override
  set category(String value) => RealmObjectBase.set(this, 'category', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String? get isFav => RealmObjectBase.get<String>(this, 'isFav') as String?;
  @override
  set isFav(String? value) => RealmObjectBase.set(this, 'isFav', value);

  @override
  RealmList<ContentDataEntity> get cdataEntities =>
      RealmObjectBase.get<ContentDataEntity>(this, 'cdataEntities')
          as RealmList<ContentDataEntity>;
  @override
  set cdataEntities(covariant RealmList<ContentDataEntity> value) =>
      throw RealmUnsupportedSetError();

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
      'id': id.toEJson(),
      'category': category.toEJson(),
      'title': title.toEJson(),
      'isFav': isFav.toEJson(),
      'cdataEntities': cdataEntities.toEJson(),
    };
  }

  static EJsonValue _toEJson(CategoryEntity value) => value.toEJson();
  static CategoryEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'category': EJsonValue category,
        'title': EJsonValue title,
      } =>
        CategoryEntity(
          fromEJson(id),
          fromEJson(category),
          fromEJson(title),
          isFav: fromEJson(ejson['isFav']),
          cdataEntities: fromEJson(ejson['cdataEntities']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(CategoryEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, CategoryEntity, 'CategoryEntity', [
      SchemaProperty('id', RealmPropertyType.int),
      SchemaProperty('category', RealmPropertyType.string),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('isFav', RealmPropertyType.string, optional: true),
      SchemaProperty('cdataEntities', RealmPropertyType.object,
          linkTarget: 'ContentDataEntity',
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ContentDataEntity extends _ContentDataEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  ContentDataEntity(
    String type,
    String audiourl, {
    Iterable<LyricsEntity> lyricsEntities = const [],
  }) {
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'audiourl', audiourl);
    RealmObjectBase.set<RealmList<LyricsEntity>>(
        this, 'lyricsEntities', RealmList<LyricsEntity>(lyricsEntities));
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
  RealmList<LyricsEntity> get lyricsEntities =>
      RealmObjectBase.get<LyricsEntity>(this, 'lyricsEntities')
          as RealmList<LyricsEntity>;
  @override
  set lyricsEntities(covariant RealmList<LyricsEntity> value) =>
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
      'lyricsEntities': lyricsEntities.toEJson(),
    };
  }

  static EJsonValue _toEJson(ContentDataEntity value) => value.toEJson();
  static ContentDataEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'type': EJsonValue type,
        'audiourl': EJsonValue audiourl,
      } =>
        ContentDataEntity(
          fromEJson(type),
          fromEJson(audiourl),
          lyricsEntities: fromEJson(ejson['lyricsEntities']),
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
      SchemaProperty('lyricsEntities', RealmPropertyType.object,
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
    String transliteration,
    String translation,
  ) {
    RealmObjectBase.set(this, 'time', time);
    RealmObjectBase.set(this, 'arabic', arabic);
    RealmObjectBase.set(this, 'transliteration', transliteration);
    RealmObjectBase.set(this, 'translation', translation);
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
  String get transliteration =>
      RealmObjectBase.get<String>(this, 'transliteration') as String;
  @override
  set transliteration(String value) =>
      RealmObjectBase.set(this, 'transliteration', value);

  @override
  String get translation =>
      RealmObjectBase.get<String>(this, 'translation') as String;
  @override
  set translation(String value) =>
      RealmObjectBase.set(this, 'translation', value);

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
      'transliteration': transliteration.toEJson(),
      'translation': translation.toEJson(),
    };
  }

  static EJsonValue _toEJson(LyricsEntity value) => value.toEJson();
  static LyricsEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'time': EJsonValue time,
        'arabic': EJsonValue arabic,
        'transliteration': EJsonValue transliteration,
        'translation': EJsonValue translation,
      } =>
        LyricsEntity(
          fromEJson(time),
          fromEJson(arabic),
          fromEJson(transliteration),
          fromEJson(translation),
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
      SchemaProperty('transliteration', RealmPropertyType.string),
      SchemaProperty('translation', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
