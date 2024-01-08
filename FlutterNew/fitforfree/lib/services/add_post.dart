import 'dart:convert';
import 'dart:io';

import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AddPost extends StatefulWidget
 
{
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
  Future<void> postData() async {
    final accessToken = client.auth.currentSession?.accessToken;
    const String apiUrl = 'http://192.227.152.231:3333/Blog/CreatePost'; // Replace with your actual base URL

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      },
      body: jsonEncode(<String, String>{
        'titleName': _title.text,
        'description': _description.text,
      }),
    );

    if (response.statusCode == 200) {
      // Request was successful, you can handle the response here
      debugPrint('Post Successful!');
    } else {
      // Request failed, handle the error
      debugPrint('Failed to post data. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        shadowColor: Colors.black,
      ),
      body: Material(
        child: SingleChildScrollView (
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _title,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter title of your post",
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextField(
                controller: _description,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter the body",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await postData();
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text('Posted ^_^'),
                              backgroundColor: Color.fromARGB(255, 4, 213, 77),
                              
                            ),
                );
                
              },
              child: const Text("Add Post"),
            ),
          ],
        ),
      ),
      )
    );
  }
}