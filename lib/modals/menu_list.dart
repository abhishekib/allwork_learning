import 'package:realm/realm.dart';

part 'menu_list.realm.dart';

/// Non-Realm `MenuList` class for API interaction
class MenuList {
  final List<String> items;

  MenuList({required this.items});

  factory MenuList.fromJson(Map<String, dynamic> json) {
    return MenuList(
      items: List<String>.from(json['data']),
    );
  }

  factory MenuList.fromRealm(RealmMenuList realmModel) {
    return MenuList(
      items: realmModel.items,
    );
  }

  RealmMenuList toRealmModel() {
    return RealmMenuList(
      ObjectId(), // Positional argument for 'id'
      items: items, // Named parameter for 'items'
    );
  }
}

@RealmModel()
class _RealmMenuList {
  @PrimaryKey()
  late ObjectId id;
  late List<String> items;
}
