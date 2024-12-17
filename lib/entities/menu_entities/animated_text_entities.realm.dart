// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animated_text_entities.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class AnimatedTextEntity extends _AnimatedTextEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  AnimatedTextEntity(
    String heading,
  ) {
    RealmObjectBase.set(this, 'heading', heading);
  }

  AnimatedTextEntity._();

  @override
  String get heading => RealmObjectBase.get<String>(this, 'heading') as String;
  @override
  set heading(String value) => RealmObjectBase.set(this, 'heading', value);

  @override
  Stream<RealmObjectChanges<AnimatedTextEntity>> get changes =>
      RealmObjectBase.getChanges<AnimatedTextEntity>(this);

  @override
  Stream<RealmObjectChanges<AnimatedTextEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<AnimatedTextEntity>(this, keyPaths);

  @override
  AnimatedTextEntity freeze() =>
      RealmObjectBase.freezeObject<AnimatedTextEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'heading': heading.toEJson(),
    };
  }

  static EJsonValue _toEJson(AnimatedTextEntity value) => value.toEJson();
  static AnimatedTextEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'heading': EJsonValue heading,
      } =>
        AnimatedTextEntity(
          fromEJson(heading),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AnimatedTextEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, AnimatedTextEntity, 'AnimatedTextEntity', [
      SchemaProperty('heading', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class MessageModelEntity extends _MessageModelEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  MessageModelEntity({
    Iterable<AnimatedTextEntity> animatedText = const [],
  }) {
    RealmObjectBase.set<RealmList<AnimatedTextEntity>>(
        this, 'animatedText', RealmList<AnimatedTextEntity>(animatedText));
  }

  MessageModelEntity._();

  @override
  RealmList<AnimatedTextEntity> get animatedText =>
      RealmObjectBase.get<AnimatedTextEntity>(this, 'animatedText')
          as RealmList<AnimatedTextEntity>;
  @override
  set animatedText(covariant RealmList<AnimatedTextEntity> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<MessageModelEntity>> get changes =>
      RealmObjectBase.getChanges<MessageModelEntity>(this);

  @override
  Stream<RealmObjectChanges<MessageModelEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<MessageModelEntity>(this, keyPaths);

  @override
  MessageModelEntity freeze() =>
      RealmObjectBase.freezeObject<MessageModelEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'animatedText': animatedText.toEJson(),
    };
  }

  static EJsonValue _toEJson(MessageModelEntity value) => value.toEJson();
  static MessageModelEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return MessageModelEntity(
      animatedText: fromEJson(ejson['animatedText']),
    );
  }

  static final schema = () {
    RealmObjectBase.registerFactory(MessageModelEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, MessageModelEntity, 'MessageModelEntity', [
      SchemaProperty('animatedText', RealmPropertyType.object,
          linkTarget: 'AnimatedTextEntity',
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
