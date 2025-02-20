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
    String categoryName,
    String categoryType,
  ) {
    RealmObjectBase.set(this, 'audioUrl', audioUrl);
    RealmObjectBase.set(this, 'audioDownloadPath', audioDownloadPath);
    RealmObjectBase.set(this, 'categoryName', categoryName);
    RealmObjectBase.set(this, 'categoryType', categoryType);
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
  String get categoryName =>
      RealmObjectBase.get<String>(this, 'categoryName') as String;
  @override
  set categoryName(String value) =>
      RealmObjectBase.set(this, 'categoryName', value);

  @override
  String get categoryType =>
      RealmObjectBase.get<String>(this, 'categoryType') as String;
  @override
  set categoryType(String value) =>
      RealmObjectBase.set(this, 'categoryType', value);

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
      'categoryName': categoryName.toEJson(),
      'categoryType': categoryType.toEJson(),
    };
  }

  static EJsonValue _toEJson(AudioDownloadMapping value) => value.toEJson();
  static AudioDownloadMapping _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'audioUrl': EJsonValue audioUrl,
        'audioDownloadPath': EJsonValue audioDownloadPath,
        'categoryName': EJsonValue categoryName,
        'categoryType': EJsonValue categoryType,
      } =>
        AudioDownloadMapping(
          fromEJson(audioUrl),
          fromEJson(audioDownloadPath),
          fromEJson(categoryName),
          fromEJson(categoryType),
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
      SchemaProperty('categoryName', RealmPropertyType.string),
      SchemaProperty('categoryType', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
