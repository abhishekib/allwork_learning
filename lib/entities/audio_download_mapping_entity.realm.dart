// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_download_mapping_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class AudioDownloadMapping extends _AudioDownloadMapping
    with RealmEntity, RealmObjectBase, RealmObject {
  AudioDownloadMapping(
    String audioUrl,
    String audioDownloadPath,
  ) {
    RealmObjectBase.set(this, 'audioUrl', audioUrl);
    RealmObjectBase.set(this, 'audioDownloadPath', audioDownloadPath);
  }

  AudioDownloadMapping._();

  @override
  String get audioUrl =>
      RealmObjectBase.get<String>(this, 'audioUrl') as String;
  @override
  set audioUrl(String value) => RealmObjectBase.set(this, 'audioUrl', value);

  @override
  String get audioDownloadPath =>
      RealmObjectBase.get<String>(this, 'audioDownloadPath') as String;
  @override
  set audioDownloadPath(String value) =>
      RealmObjectBase.set(this, 'audioDownloadPath', value);

  @override
  Stream<RealmObjectChanges<AudioDownloadMapping>> get changes =>
      RealmObjectBase.getChanges<AudioDownloadMapping>(this);

  @override
  Stream<RealmObjectChanges<AudioDownloadMapping>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<AudioDownloadMapping>(this, keyPaths);

  @override
  AudioDownloadMapping freeze() =>
      RealmObjectBase.freezeObject<AudioDownloadMapping>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'audioUrl': audioUrl.toEJson(),
      'audioDownloadPath': audioDownloadPath.toEJson(),
    };
  }

  static EJsonValue _toEJson(AudioDownloadMapping value) => value.toEJson();
  static AudioDownloadMapping _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'audioUrl': EJsonValue audioUrl,
        'audioDownloadPath': EJsonValue audioDownloadPath,
      } =>
        AudioDownloadMapping(
          fromEJson(audioUrl),
          fromEJson(audioDownloadPath),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AudioDownloadMapping._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, AudioDownloadMapping, 'AudioDownloadMapping', [
      SchemaProperty('audioUrl', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('audioDownloadPath', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
