import 'dart:convert';
import 'dart:io';
import 'package:fitforfree/models/user_info.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  late Future<UserInfo> _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = fetchUserInfo();
  }

  static Future<UserInfo> fetchUserInfo() async {
    final accessToken = client.auth.currentSession?.accessToken;
    final response = await http.get(
      Uri.parse('http://192.227.152.231:3333/UsersInfo/currentUser'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UserInfo.fromJson(data);
    } else {
      throw Exception('Failed to load user information');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserInfo>(
      future: _userInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(); // Replace with your loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userInfo = snapshot.data!;
      
          return UserAccountsDrawerHeader(
            
            accountName: Text(userInfo.name),
            accountEmail: Text(userInfo.email),
            
            decoration: const BoxDecoration(
              color: Colors.black54
            ),
          );
          
        }
      },
    );
  }
}
