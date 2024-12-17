import 'package:realm/realm.dart';
part 'menu_list_entity.realm.dart';

@RealmModel()
class _MenuListEntity {
  late List<String> items;
}
