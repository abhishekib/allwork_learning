import 'package:realm/realm.dart';

part 'animated_text_entities.realm.dart';

@RealmModel()
class _MessageModelEntity {
  late List<_AnimatedTextEntity> animatedText;
}


@RealmModel()
class _AnimatedTextEntity {
  late String heading;
}

