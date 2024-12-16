// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_time_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class PrayerTimeEntity extends _PrayerTimeEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  PrayerTimeEntity(
    String fajr,
    String sunrise,
    String dhuhr,
    String sunset,
    String maghrib,
  ) {
    RealmObjectBase.set(this, 'fajr', fajr);
    RealmObjectBase.set(this, 'sunrise', sunrise);
    RealmObjectBase.set(this, 'dhuhr', dhuhr);
    RealmObjectBase.set(this, 'sunset', sunset);
    RealmObjectBase.set(this, 'maghrib', maghrib);
  }

  PrayerTimeEntity._();

  @override
  String get fajr => RealmObjectBase.get<String>(this, 'fajr') as String;
  @override
  set fajr(String value) => RealmObjectBase.set(this, 'fajr', value);

  @override
  String get sunrise => RealmObjectBase.get<String>(this, 'sunrise') as String;
  @override
  set sunrise(String value) => RealmObjectBase.set(this, 'sunrise', value);

  @override
  String get dhuhr => RealmObjectBase.get<String>(this, 'dhuhr') as String;
  @override
  set dhuhr(String value) => RealmObjectBase.set(this, 'dhuhr', value);

  @override
  String get sunset => RealmObjectBase.get<String>(this, 'sunset') as String;
  @override
  set sunset(String value) => RealmObjectBase.set(this, 'sunset', value);

  @override
  String get maghrib => RealmObjectBase.get<String>(this, 'maghrib') as String;
  @override
  set maghrib(String value) => RealmObjectBase.set(this, 'maghrib', value);

  @override
  Stream<RealmObjectChanges<PrayerTimeEntity>> get changes =>
      RealmObjectBase.getChanges<PrayerTimeEntity>(this);

  @override
  Stream<RealmObjectChanges<PrayerTimeEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PrayerTimeEntity>(this, keyPaths);

  @override
  PrayerTimeEntity freeze() =>
      RealmObjectBase.freezeObject<PrayerTimeEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'fajr': fajr.toEJson(),
      'sunrise': sunrise.toEJson(),
      'dhuhr': dhuhr.toEJson(),
      'sunset': sunset.toEJson(),
      'maghrib': maghrib.toEJson(),
    };
  }

  static EJsonValue _toEJson(PrayerTimeEntity value) => value.toEJson();
  static PrayerTimeEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'fajr': EJsonValue fajr,
        'sunrise': EJsonValue sunrise,
        'dhuhr': EJsonValue dhuhr,
        'sunset': EJsonValue sunset,
        'maghrib': EJsonValue maghrib,
      } =>
        PrayerTimeEntity(
          fromEJson(fajr),
          fromEJson(sunrise),
          fromEJson(dhuhr),
          fromEJson(sunset),
          fromEJson(maghrib),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PrayerTimeEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, PrayerTimeEntity, 'PrayerTimeEntity', [
      SchemaProperty('fajr', RealmPropertyType.string),
      SchemaProperty('sunrise', RealmPropertyType.string),
      SchemaProperty('dhuhr', RealmPropertyType.string),
      SchemaProperty('sunset', RealmPropertyType.string),
      SchemaProperty('maghrib', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
