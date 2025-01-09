class LoginResponse {
  final Message? message;
  final String? type;

  final String? status;
  final User? user;

  LoginResponse({this.message, this.type, this.status, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('status') && json.containsKey('user')) {

      return LoginResponse(
        status: json['status'] as String,
        user: User.fromJson(json['user']),
      );
    } else if (json.containsKey('message') || json.containsKey('type')) {

      return LoginResponse(
        message:
            json['message'] != null ? Message.fromJson(json['message']) : null,
        type: json['type'] ?? '',
      );
    } else {
      throw Exception('Unsupported response format');
    }
  }
}

class DeleteResponse {
  String message;
  String type;

  DeleteResponse({required this.message, required this.type});

  factory DeleteResponse.fromJson(Map<String, dynamic> json) {
    return DeleteResponse(
      message: json['msg'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class Message {
  final Data data;
  final int id;
  final Map<String, dynamic> caps;
  final String capKey;
  final List<String> roles;
  final Map<String, dynamic> allcaps;

  Message({
    required this.data,
    required this.id,
    required this.caps,
    required this.capKey,
    required this.roles,
    required this.allcaps,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      data: Data.fromJson(json['data']),
      id: json['ID'],
      caps: json['caps'] ?? {},
      capKey: json['cap_key'] ?? '',
      roles: List<String>.from(json['roles']),
      allcaps: json['allcaps'] ?? {},
    );
  }
}

class Data {
  final String id;
  final String userLogin;
  final String userPass;
  final String userNicename;
  final String userEmail;
  final String userUrl;
  final String userRegistered;
  final String userActivationKey;
  final String userStatus;
  final String displayName;

  Data({
    required this.id,
    required this.userLogin,
    required this.userPass,
    required this.userNicename,
    required this.userEmail,
    required this.userUrl,
    required this.userRegistered,
    required this.userActivationKey,
    required this.userStatus,
    required this.displayName,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['ID'] ?? '',
      userLogin: json['user_login'] ?? '',
      userPass: json['user_pass'] ?? '',
      userNicename: json['user_nicename'] ?? '',
      userEmail: json['user_email'] ?? '',
      userUrl: json['user_url'] ?? '',
      userRegistered: json['user_registered'] ?? '',
      userActivationKey: json['user_activation_key'] ?? '',
      userStatus: json['user_status'] ?? '',
      displayName: json['display_name'] ?? '',
    );
  }
}

class User {
  final String userId;
  final String email;
  final String name;

  User({required this.userId, required this.email, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }
}
