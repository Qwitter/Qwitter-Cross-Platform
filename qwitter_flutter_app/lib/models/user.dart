import 'dart:io';

class User {
  String? id;
  String? token;
  String? username;
  String? email;
  String? fullName;
  String? birthDate;
  String? password;
  List? usernameSuggestions;
  File? profilePicture;
  bool? isFollowed;
  int? followersCount;
  int? followingCount;
  String? createdAt;
  File? profileBannerUrl;
  String? url;
  String? description;
  bool? isProtected;
  bool? isVerified;

  User({
    this.id,
    this.username,
    this.email,
    this.fullName,
    this.birthDate,
    this.password,
    this.usernameSuggestions,
    this.profilePicture,
    this.isFollowed,
    this.followersCount,
    this.followingCount,
    this.createdAt,
    this.profileBannerUrl,
    this.url,
    this.description,
    this.isProtected,
    this.isVerified,
  });

  // Add all setters and return user


  User setToken(String? token) {
    this.token = token;
    return this;
  }

  User setId(String? id) {
    this.id = id;
    return this;
  }

  User setUsername(String? username) {
    this.username = username;
    return this;
  }

  User setEmail(String? email) {
    this.email = email;
    return this;
  }

  User setFullName(String? fullName) {
    this.fullName = fullName;
    return this;
  }

  User setBirthDate(String? birthDate) {
    this.birthDate = birthDate;
    return this;
  }

  User setPassword(String? password) {
    this.password = password;
    return this;
  }

  User setProfilePicture(File? profilePicture) {
    this.profilePicture = profilePicture;
    return this;
  }

  User setUsernameSuggestions(List? usernameSuggestions) {
    this.usernameSuggestions = usernameSuggestions;
    return this;
  }

  // Add all getters

  String? get getToken {
    return token;
  }

  String? get getId {
    return id;
  }

  String? get getUsername {
    return username;
  }

  String? get getEmail {
    return email;
  }

  String? get getFullName {
    return fullName;
  }

  String? get getBirthDate {
    return birthDate;
  }

  String? get getPassword {
    return password;
  }

  File? get getProfilePicture {
    return profilePicture;
  }

  List? get getUsernameSuggestions {
    return usernameSuggestions;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['userName'],
      email: json['email'],
      fullName: json['name'],
      birthDate: json['birthDate'],
      password: json['password'],
      isFollowed: false,
      profilePicture: File(
        json['profileImageUrl'] ?? "",
      ),
      followersCount: json['followersCount'],
      followingCount: json['followingCount'],
      createdAt: json['createdAt'],
      profileBannerUrl: File(
        json['profileBannerUrl'] ?? "",
      ),
      url: json['url'],
      description: json['description'],
      isProtected: json['isProtected'],
      isVerified: json['isVerified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      'birth_date': birthDate,
      'password': password,
      'profile_picture_path': profilePicture!.path,
      'isProtected': isProtected,
      'isVerified': isVerified,
      'description': description,
      'followersCount':followersCount,
      'followingCount':followingCount,
      'createdAt': createdAt,
      // 'profileImageUrl':
    };
  }
}
