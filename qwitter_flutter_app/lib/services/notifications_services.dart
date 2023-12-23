
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/notification.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationsServices{
  static AppUser user = AppUser();
  static Map<String, String> cookies = {};
  static const String _baseUrl = 'http://back.qwitter.cloudns.org:3000';

  static Future<http.Response> getNotificationsResponse() async {
    user.getUserData();
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final url =
        Uri.parse('$_baseUrl/api/v1/Notifications');

    //print(user.token);

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'authorization': 'Bearer ${user.token}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    return response;
  }


  static Future<List<QwitterNotification>> getNotifications() async {
    try {
      final response = await getNotificationsResponse();
      print("scode: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> notificationList = jsonBody["notifications"] as List<dynamic>;

        print('N_List ${notificationList}');
        List<QwitterNotification> notifications =
            notificationList.map((notification) => QwitterNotification.fromJson(notification  )).toList();


        print('${notifications.length} - ${notificationList.length} Notifications fetched');


        return notifications;
        // return;
      } else {
        //print('Failed to fetch tweets: ${response.statusCode}');
        return [];
        // return;
      }
    } catch (error, stackTrace) {
      print('Error fetching notifications: $error');
      print('StackTrace: $stackTrace');
      return [];
      // return;
    }
  }

}