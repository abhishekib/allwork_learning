// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_list_gujrati_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class MenuListGujratiEntity extends _MenuListGujratiEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  MenuListGujratiEntity({
    Iterable<String> items = const [],
  }) {
    RealmObjectBase.set<RealmList<String>>(
        this, 'items', RealmList<String>(items));
  }

  MenuListGujratiEntity._();

  @override
  RealmList<String> get items =>
      RealmObjectBase.get<String>(this, 'items') as RealmList<String>;
  @override
  set items(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<MenuListGujratiEntity>> get changes =>
      RealmObjectBase.getChanges<MenuListGujratiEntity>(this);

  @override
  Stream<RealmObjectChanges<MenuListGujratiEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<MenuListGujratiEntity>(this, keyPaths);

  @override
  MenuListGujratiEntity freeze() =>
      RealmObjectBase.freezeObject<MenuListGujratiEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'items': items.toEJson(),
    };
  }

  static EJsonValue _toEJson(MenuListGujratiEntity value) => value.toEJson();
  static MenuListGujratiEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return MenuListGujratiEntity(
      items: fromEJson(ejson['items']),
    );
  }

  static final schema = () {
    RealmObjectBase.registerFactory(MenuListGujratiEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, MenuListGujratiEntity,
        'MenuListGujratiEntity', [
      SchemaProperty('items', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
