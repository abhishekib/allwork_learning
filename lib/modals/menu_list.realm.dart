// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_list.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmMenuList extends _RealmMenuList
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmMenuList(
    ObjectId id, {
    Iterable<String> items = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set<RealmList<String>>(
        this, 'items', RealmList<String>(items));
  }

  RealmMenuList._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  RealmList<String> get items =>
      RealmObjectBase.get<String>(this, 'items') as RealmList<String>;
  @override
  set items(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<RealmMenuList>> get changes =>
      RealmObjectBase.getChanges<RealmMenuList>(this);

  @override
  Stream<RealmObjectChanges<RealmMenuList>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<RealmMenuList>(this, keyPaths);

  @override
  RealmMenuList freeze() => RealmObjectBase.freezeObject<RealmMenuList>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'items': items.toEJson(),
    };
  }

  static EJsonValue _toEJson(RealmMenuList value) => value.toEJson();
  static RealmMenuList _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
      } =>
        RealmMenuList(
          fromEJson(id),
          items: fromEJson(ejson['items']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(RealmMenuList._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, RealmMenuList, 'RealmMenuList', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('items', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
