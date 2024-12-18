// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_date_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class DailyDateEntity extends _DailyDateEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  DailyDateEntity(
    String hijriDate,
    String event,
    String eventColor,
  ) {
    RealmObjectBase.set(this, 'hijriDate', hijriDate);
    RealmObjectBase.set(this, 'event', event);
    RealmObjectBase.set(this, 'eventColor', eventColor);
  }

  DailyDateEntity._();

  @override
  String get hijriDate =>
      RealmObjectBase.get<String>(this, 'hijriDate') as String;
  @override
  set hijriDate(String value) => RealmObjectBase.set(this, 'hijriDate', value);

  @override
  String get event => RealmObjectBase.get<String>(this, 'event') as String;
  @override
  set event(String value) => RealmObjectBase.set(this, 'event', value);

  @override
  String get eventColor =>
      RealmObjectBase.get<String>(this, 'eventColor') as String;
  @override
  set eventColor(String value) =>
      RealmObjectBase.set(this, 'eventColor', value);

  @override
  Stream<RealmObjectChanges<DailyDateEntity>> get changes =>
      RealmObjectBase.getChanges<DailyDateEntity>(this);

  @override
  Stream<RealmObjectChanges<DailyDateEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<DailyDateEntity>(this, keyPaths);

  @override
  DailyDateEntity freeze() =>
      RealmObjectBase.freezeObject<DailyDateEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'hijriDate': hijriDate.toEJson(),
      'event': event.toEJson(),
      'eventColor': eventColor.toEJson(),
    };
  }

  static EJsonValue _toEJson(DailyDateEntity value) => value.toEJson();
  static DailyDateEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'hijriDate': EJsonValue hijriDate,
        'event': EJsonValue event,
        'eventColor': EJsonValue eventColor,
      } =>
        DailyDateEntity(
          fromEJson(hijriDate),
          fromEJson(event),
          fromEJson(eventColor),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(DailyDateEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, DailyDateEntity, 'DailyDateEntity', [
      SchemaProperty('hijriDate', RealmPropertyType.string),
      SchemaProperty('event', RealmPropertyType.string),
      SchemaProperty('eventColor', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
