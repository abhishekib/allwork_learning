// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ReminderEntity extends _ReminderEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  ReminderEntity(
    int id,
    String title,
    DateTime createdAt,
    String scheduledTimeZone,
    DateTime scheduledAt,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'scheduledTimeZone', scheduledTimeZone);
    RealmObjectBase.set(this, 'scheduledAt', scheduledAt);
  }

  ReminderEntity._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  String get scheduledTimeZone =>
      RealmObjectBase.get<String>(this, 'scheduledTimeZone') as String;
  @override
  set scheduledTimeZone(String value) =>
      RealmObjectBase.set(this, 'scheduledTimeZone', value);

  @override
  DateTime get scheduledAt =>
      RealmObjectBase.get<DateTime>(this, 'scheduledAt') as DateTime;
  @override
  set scheduledAt(DateTime value) =>
      RealmObjectBase.set(this, 'scheduledAt', value);

  @override
  Stream<RealmObjectChanges<ReminderEntity>> get changes =>
      RealmObjectBase.getChanges<ReminderEntity>(this);

  @override
  Stream<RealmObjectChanges<ReminderEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ReminderEntity>(this, keyPaths);

  @override
  ReminderEntity freeze() => RealmObjectBase.freezeObject<ReminderEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'title': title.toEJson(),
      'createdAt': createdAt.toEJson(),
      'scheduledTimeZone': scheduledTimeZone.toEJson(),
      'scheduledAt': scheduledAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(ReminderEntity value) => value.toEJson();
  static ReminderEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'title': EJsonValue title,
        'createdAt': EJsonValue createdAt,
        'scheduledTimeZone': EJsonValue scheduledTimeZone,
        'scheduledAt': EJsonValue scheduledAt,
      } =>
        ReminderEntity(
          fromEJson(id),
          fromEJson(title),
          fromEJson(createdAt),
          fromEJson(scheduledTimeZone),
          fromEJson(scheduledAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ReminderEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ReminderEntity, 'ReminderEntity', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('scheduledTimeZone', RealmPropertyType.string),
      SchemaProperty('scheduledAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
