// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_list_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class MenuListEntity extends _MenuListEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  MenuListEntity({
    Iterable<String> items = const [],
  }) {
    RealmObjectBase.set<RealmList<String>>(
        this, 'items', RealmList<String>(items));
  }

  MenuListEntity._();

  @override
  RealmList<String> get items =>
      RealmObjectBase.get<String>(this, 'items') as RealmList<String>;
  @override
  set items(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<MenuListEntity>> get changes =>
      RealmObjectBase.getChanges<MenuListEntity>(this);

  @override
  Stream<RealmObjectChanges<MenuListEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<MenuListEntity>(this, keyPaths);

  @override
  MenuListEntity freeze() => RealmObjectBase.freezeObject<MenuListEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'items': items.toEJson(),
    };
  }

  static EJsonValue _toEJson(MenuListEntity value) => value.toEJson();
  static MenuListEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return MenuListEntity(
      items: fromEJson(ejson['items']),
    );
  }

  static final schema = () {
    RealmObjectBase.registerFactory(MenuListEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, MenuListEntity, 'MenuListEntity', [
      SchemaProperty('items', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
