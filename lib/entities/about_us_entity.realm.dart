// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_us_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class AboutUsEntity extends _AboutUsEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  AboutUsEntity(
    String data,
  ) {
    RealmObjectBase.set(this, 'data', data);
  }

  AboutUsEntity._();

  @override
  String get data => RealmObjectBase.get<String>(this, 'data') as String;
  @override
  set data(String value) => RealmObjectBase.set(this, 'data', value);

  @override
  Stream<RealmObjectChanges<AboutUsEntity>> get changes =>
      RealmObjectBase.getChanges<AboutUsEntity>(this);

  @override
  Stream<RealmObjectChanges<AboutUsEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<AboutUsEntity>(this, keyPaths);

  @override
  AboutUsEntity freeze() => RealmObjectBase.freezeObject<AboutUsEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'data': data.toEJson(),
    };
  }

  static EJsonValue _toEJson(AboutUsEntity value) => value.toEJson();
  static AboutUsEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'data': EJsonValue data,
      } =>
        AboutUsEntity(
          fromEJson(data),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AboutUsEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, AboutUsEntity, 'AboutUsEntity', [
      SchemaProperty('data', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
