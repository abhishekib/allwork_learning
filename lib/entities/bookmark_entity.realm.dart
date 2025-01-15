// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class BookmarkEntity extends _BookmarkEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  BookmarkEntity(
    String title,
  ) {
    RealmObjectBase.set(this, 'title', title);
  }

  BookmarkEntity._();

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  Stream<RealmObjectChanges<BookmarkEntity>> get changes =>
      RealmObjectBase.getChanges<BookmarkEntity>(this);

  @override
  Stream<RealmObjectChanges<BookmarkEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<BookmarkEntity>(this, keyPaths);

  @override
  BookmarkEntity freeze() => RealmObjectBase.freezeObject<BookmarkEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'title': title.toEJson(),
    };
  }

  static EJsonValue _toEJson(BookmarkEntity value) => value.toEJson();
  static BookmarkEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'title': EJsonValue title,
      } =>
        BookmarkEntity(
          fromEJson(title),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(BookmarkEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, BookmarkEntity, 'BookmarkEntity', [
      SchemaProperty('title', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
