import 'dart:io';

import 'package:qwitter_flutter_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser extends User {
  // Singleton pattern instance
  static final AppUser _singleton = AppUser._internal();

  factory AppUser() {
    return _singleton;
  }

  AppUser._internal();

  AppUser copyUserData(User user) {
    id = user.id;
    username = user.username;
    email = user.email;
    fullName = user.fullName;
    birthDate = user.birthDate;
    password = user.password;
    profilePicture = user.profilePicture;
    usernameSuggestions = user.usernameSuggestions;
    isFollowed = user.isFollowed;
    followersCount = user.followersCount;
    followingCount = user.followingCount;
    createdAt = user.createdAt;
    profileBannerUrl = user.profileBannerUrl;
    url = user.url;
    description = user.description;
    isProtected = user.isProtected;
    isVerified = user.isVerified;
    token = user.token;

    return this;
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', id ?? '0');
    prefs.setString('username', username ?? '');
    prefs.setString('email', email ?? '');
    prefs.setString('full_name', fullName ?? '');
    prefs.setString('birth_date', birthDate ?? '');
    prefs.setString('password', password ?? '');

    // For saving the profile picture, you can store the file path.
    prefs.setString('profileImageUrl', profilePicture?.path ?? '');
    prefs.setString('token', token ?? '');

    //print'User data saved $username');
  }

  Future<AppUser?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // Create a User object from the retrieved data
    final appUser = AppUser();
    appUser.id = prefs.getString('user_id');
    appUser.username = prefs.getString('username');
    appUser.email = prefs.getString('email');
    appUser.fullName = prefs.getString('full_name');
    appUser.birthDate = prefs.getString('birth_date');
    appUser.password = prefs.getString('password');
    appUser.profilePicture =
        File(prefs.getString('profileImageUrl') ?? '');
    appUser.token = prefs.getString('token');

    return appUser;
  }

  Future<void> deleteUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(
        'username'); // This will remove data associated with the provided key
  }
}
