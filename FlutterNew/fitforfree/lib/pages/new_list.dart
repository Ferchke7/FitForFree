import 'dart:convert';
import 'dart:io';

import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsList extends StatefulWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  late Future<List<Map<String, dynamic>>> _newsList;

  @override
  void initState() {
    super.initState();
    _newsList = fetchNewsList();
  }

  Future<List<Map<String, dynamic>>> fetchNewsList() async {
    try {
      final accessToken = client.auth.currentSession?.accessToken;
      print(accessToken);
      if (accessToken == null) {
        // Handle the case where the access token is not available
        throw Exception('Access token is null.');
      }

      final response = await http.get(
        Uri.parse('http://192.227.152.231:3333/ForumView'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print('Error fetching news: $e');
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _newsList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> newsList = snapshot.data!;
          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(newsList[index]['newsText']),
                subtitle: Text('Created by: ${newsList[index]['createdBy']}'),
              );
            },
          );
        }
      },
    );
  }
}
