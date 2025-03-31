// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_download_mapping_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class AudioDownloadMapping extends _AudioDownloadMapping
    with RealmEntity, RealmObjectBase, RealmObject {
  AudioDownloadMapping(
    String audioName,
    String audioDownloadPath,
    String categoryName,
    String categoryType, {
    Iterable<String> sourceUrls = const [],
  }) {
    RealmObjectBase.set(this, 'audioName', audioName);
    RealmObjectBase.set<RealmList<String>>(
        this, 'sourceUrls', RealmList<String>(sourceUrls));
    RealmObjectBase.set(this, 'audioDownloadPath', audioDownloadPath);
    RealmObjectBase.set(this, 'categoryName', categoryName);
    RealmObjectBase.set(this, 'categoryType', categoryType);
  }

  AudioDownloadMapping._();

  @override
  String get audioName =>
      RealmObjectBase.get<String>(this, 'audioName') as String;
  @override
  set audioName(String value) => RealmObjectBase.set(this, 'audioName', value);

  @override
  RealmList<String> get sourceUrls =>
      RealmObjectBase.get<String>(this, 'sourceUrls') as RealmList<String>;
  @override
  set sourceUrls(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

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
      'audioName': audioName.toEJson(),
      'sourceUrls': sourceUrls.toEJson(),
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
        'audioName': EJsonValue audioName,
        'audioDownloadPath': EJsonValue audioDownloadPath,
        'categoryName': EJsonValue categoryName,
        'categoryType': EJsonValue categoryType,
      } =>
        AudioDownloadMapping(
          fromEJson(audioName),
          fromEJson(audioDownloadPath),
          fromEJson(categoryName),
          fromEJson(categoryType),
          sourceUrls: fromEJson(ejson['sourceUrls']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AudioDownloadMapping._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, AudioDownloadMapping, 'AudioDownloadMapping', [
      SchemaProperty('audioName', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('sourceUrls', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('audioDownloadPath', RealmPropertyType.string),
      SchemaProperty('categoryName', RealmPropertyType.string),
      SchemaProperty('categoryType', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
