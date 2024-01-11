import 'dart:convert';
import 'dart:io';

import 'package:fitforfree/models/post.dart';
import 'package:fitforfree/services/add_post.dart';
import 'package:fitforfree/services/read_post.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  late Future<List<Post>> _postList;

  @override
  void initState() {
    super.initState();
    _postList = fetchPostList();
  }

  String someConcat(String text) {
    if (text.length > 30) {
      return text.substring(0, 30);
    } else
      return text;
  }
  Future<void> deleteMyPost(int postId) async {
  try {
    final accessToken = client.auth.currentSession?.accessToken;
    debugPrint(accessToken);
    
    if (accessToken == null) {
      throw Exception('Access token is null.');
    }

    final response = await http.delete(
      Uri.parse("http://192.227.152.231:3333/Blog/DeleteMyPost/deletePost?postId=$postId"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      },
    );

    if (response.statusCode == 200) {
      debugPrint("Success");
      
    } else if (response.statusCode == 404) {
      throw Exception("Post not found"); // Handle specific status codes
    } else {
      throw Exception("Failed to delete post. Status code: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("Error deleting post: $e");
    throw Exception("Failed to delete post");
  }
}

  Future<List<Post>> fetchPostList() async {
    try {
      final accessToken = client.auth.currentSession?.accessToken;
      debugPrint(accessToken);
      if (accessToken == null) {
        throw Exception('Access token is null.');
      }

      final response = await http.get(
        Uri.parse('http://192.227.152.231:3333/Blog/getallpostwithcomments'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Post> postList = data.map((item) => Post.fromJson(item)).toList();
        return postList;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Forum')),
        shadowColor: Colors.black,
      ),
      body: FutureBuilder<List<Post>>(
        future: _postList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(
              color: Colors.orange,
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Post> postList = snapshot.data!;
            return ListView.builder(
              itemCount: postList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ReadPost();
                        },
                        settings: RouteSettings(
                            arguments: {'postList': postList[index]}),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.orange,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            postList[index].titleName,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Created by: ${postList[index].author}\n\n${someConcat(postList[index].description)}...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const SizedBox(
                              width: 30,
                              height: 30,
                            ),
                            postList[index].author == my_username
                                ? IconButton(
                                    onPressed: () async {
                                      await deleteMyPost(postList[index].id);
                                      setState(() {
                                        _postList = fetchPostList();
                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Colors.white,
                                  )
                                : Container(),
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              child: Text(
                                "comments: ${postList[index].postsComments.length}",
                                style: const TextStyle(color: Colors.orange),
                              ),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(
                              width: 3,
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.black,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPost()),
          );
          if (result == null) {
            setState(() {});
          } else if (result) {
            setState(() {
              _postList = fetchPostList();
            });
          }
        },
        child: const Icon(
          Icons.add_box_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
