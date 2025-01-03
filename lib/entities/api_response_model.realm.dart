// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class MenuDetailEntity extends _MenuDetailEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  MenuDetailEntity(
    String endpoint, {
    ApiResponseEntity? categoryGroups,
  }) {
    RealmObjectBase.set(this, 'endpoint', endpoint);
    RealmObjectBase.set(this, 'categoryGroups', categoryGroups);
  }

  MenuDetailEntity._();

  @override
  String get endpoint =>
      RealmObjectBase.get<String>(this, 'endpoint') as String;
  @override
  set endpoint(String value) => RealmObjectBase.set(this, 'endpoint', value);

  @override
  ApiResponseEntity? get categoryGroups =>
      RealmObjectBase.get<ApiResponseEntity>(this, 'categoryGroups')
          as ApiResponseEntity?;
  @override
  set categoryGroups(covariant ApiResponseEntity? value) =>
      RealmObjectBase.set(this, 'categoryGroups', value);

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
          optional: true, linkTarget: 'ApiResponseEntity'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ApiResponseEntity extends _ApiResponseEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  ApiResponseEntity(
    String id, {
    Iterable<KeyValueEntity> data = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set<RealmList<KeyValueEntity>>(
        this, 'data', RealmList<KeyValueEntity>(data));
  }

  ApiResponseEntity._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  RealmList<KeyValueEntity> get data =>
      RealmObjectBase.get<KeyValueEntity>(this, 'data')
          as RealmList<KeyValueEntity>;
  @override
  set data(covariant RealmList<KeyValueEntity> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<ApiResponseEntity>> get changes =>
      RealmObjectBase.getChanges<ApiResponseEntity>(this);

  @override
  Stream<RealmObjectChanges<ApiResponseEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ApiResponseEntity>(this, keyPaths);

  @override
  ApiResponseEntity freeze() =>
      RealmObjectBase.freezeObject<ApiResponseEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'data': data.toEJson(),
    };
  }

  static EJsonValue _toEJson(ApiResponseEntity value) => value.toEJson();
  static ApiResponseEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
      } =>
        ApiResponseEntity(
          fromEJson(id),
          data: fromEJson(ejson['data']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ApiResponseEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ApiResponseEntity, 'ApiResponseEntity', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('data', RealmPropertyType.object,
          linkTarget: 'KeyValueEntity',
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class KeyValueEntity extends _KeyValueEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  KeyValueEntity(
    String key, {
    String? stringValue,
    int? intValue,
    double? doubleValue,
    bool? boolValue,
    Iterable<KeyValueEntity> nestedValues = const [],
    Iterable<KeyValueEntity> listValues = const [],
  }) {
    RealmObjectBase.set(this, 'key', key);
    RealmObjectBase.set(this, 'stringValue', stringValue);
    RealmObjectBase.set(this, 'intValue', intValue);
    RealmObjectBase.set(this, 'doubleValue', doubleValue);
    RealmObjectBase.set(this, 'boolValue', boolValue);
    RealmObjectBase.set<RealmList<KeyValueEntity>>(
        this, 'nestedValues', RealmList<KeyValueEntity>(nestedValues));
    RealmObjectBase.set<RealmList<KeyValueEntity>>(
        this, 'listValues', RealmList<KeyValueEntity>(listValues));
  }

  KeyValueEntity._();

  @override
  String get key => RealmObjectBase.get<String>(this, 'key') as String;
  @override
  set key(String value) => RealmObjectBase.set(this, 'key', value);

  @override
  String? get stringValue =>
      RealmObjectBase.get<String>(this, 'stringValue') as String?;
  @override
  set stringValue(String? value) =>
      RealmObjectBase.set(this, 'stringValue', value);

  @override
  int? get intValue => RealmObjectBase.get<int>(this, 'intValue') as int?;
  @override
  set intValue(int? value) => RealmObjectBase.set(this, 'intValue', value);

  @override
  double? get doubleValue =>
      RealmObjectBase.get<double>(this, 'doubleValue') as double?;
  @override
  set doubleValue(double? value) =>
      RealmObjectBase.set(this, 'doubleValue', value);

  @override
  bool? get boolValue => RealmObjectBase.get<bool>(this, 'boolValue') as bool?;
  @override
  set boolValue(bool? value) => RealmObjectBase.set(this, 'boolValue', value);

  @override
  RealmList<KeyValueEntity> get nestedValues =>
      RealmObjectBase.get<KeyValueEntity>(this, 'nestedValues')
          as RealmList<KeyValueEntity>;
  @override
  set nestedValues(covariant RealmList<KeyValueEntity> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<KeyValueEntity> get listValues =>
      RealmObjectBase.get<KeyValueEntity>(this, 'listValues')
          as RealmList<KeyValueEntity>;
  @override
  set listValues(covariant RealmList<KeyValueEntity> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<KeyValueEntity>> get changes =>
      RealmObjectBase.getChanges<KeyValueEntity>(this);

  @override
  Stream<RealmObjectChanges<KeyValueEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<KeyValueEntity>(this, keyPaths);

  @override
  KeyValueEntity freeze() => RealmObjectBase.freezeObject<KeyValueEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'key': key.toEJson(),
      'stringValue': stringValue.toEJson(),
      'intValue': intValue.toEJson(),
      'doubleValue': doubleValue.toEJson(),
      'boolValue': boolValue.toEJson(),
      'nestedValues': nestedValues.toEJson(),
      'listValues': listValues.toEJson(),
    };
  }

  static EJsonValue _toEJson(KeyValueEntity value) => value.toEJson();
  static KeyValueEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'key': EJsonValue key,
      } =>
        KeyValueEntity(
          fromEJson(key),
          stringValue: fromEJson(ejson['stringValue']),
          intValue: fromEJson(ejson['intValue']),
          doubleValue: fromEJson(ejson['doubleValue']),
          boolValue: fromEJson(ejson['boolValue']),
          nestedValues: fromEJson(ejson['nestedValues']),
          listValues: fromEJson(ejson['listValues']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(KeyValueEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, KeyValueEntity, 'KeyValueEntity', [
      SchemaProperty('key', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('stringValue', RealmPropertyType.string, optional: true),
      SchemaProperty('intValue', RealmPropertyType.int, optional: true),
      SchemaProperty('doubleValue', RealmPropertyType.double, optional: true),
      SchemaProperty('boolValue', RealmPropertyType.bool, optional: true),
      SchemaProperty('nestedValues', RealmPropertyType.object,
          linkTarget: 'KeyValueEntity',
          collectionType: RealmCollectionType.list),
      SchemaProperty('listValues', RealmPropertyType.object,
          linkTarget: 'KeyValueEntity',
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
