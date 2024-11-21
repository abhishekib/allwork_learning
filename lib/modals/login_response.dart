class LoginResponse {
  final Message message;
  final String type;

  LoginResponse({required this.message, required this.type});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: Message.fromJson(json['message']),
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
