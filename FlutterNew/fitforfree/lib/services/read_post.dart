import 'package:fitforfree/models/post.dart';
import 'dart:convert';
import 'dart:io';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReadPost extends StatefulWidget {
  const ReadPost({super.key});
  @override
  State<ReadPost> createState() => _ReadPostState();
}

class _ReadPostState extends State<ReadPost> {
  final _postId = TextEditingController();

  final _comment = TextEditingController();
  bool _isPosted = false;
  @override
  void dispose() {
    _postId.dispose();
    _comment.dispose();
    super.dispose();
  }

  Future<void> postData(int postId) async {
    setState(() {
      _isPosted = true;
    });
    final accessToken = client.auth.currentSession?.accessToken;
    final String apiUrl =
        'http://192.227.152.231:3333/Blog/AddCommentToBlog/$postId/comments';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken"
      },
      body: jsonEncode(<String, String>{
        // 'postId': _postId.text,
        'comment': _comment.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _comment.clear();
        _isPosted = false;
      });
      debugPrint('Post Successful!');
    } else {
      setState(() {
        _isPosted = false;
      });
      debugPrint(response.body);
      // Request failed, handle the error
      debugPrint('Failed to post data. Error: ${response.statusCode}');
    }
  }

  String changeDate(String input) {
    return input.substring(0, 10);
  }

  ///We need to refresh this page
  Future<List<dynamic>> fetchPostList(int blogId) async {
    try {
      final accessToken = client.auth.currentSession?.accessToken;
      debugPrint(accessToken);
      if (accessToken == null) {
        throw Exception('Access token is null.');
      }

      final response = await http.get(
        Uri.parse(
            'http://192.227.152.231:3333/Blog/GetPostComments?blogId=$blogId'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data;
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
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Post post = arguments['postList'];

    return Scaffold(
      appBar: AppBar(title: Text(post.titleName)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      post.description,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: Colors.black,
                  ),
                  // Add your comments list here
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: post.postsComments.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(32),
                                bottomRight: Radius.circular(32))),
                        leading: GestureDetector(
                          onTap: () async {
                            debugPrint("Comment Tapped");
                          },
                          child: Container(
                            height: 10.0,
                            width: 10.0,
                            decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        title: Text(
                          post.postsComments[index]['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(post.postsComments[index]['comment']),
                        trailing: Text(
                          changeDate(post.postsComments[index]['updateDate']),
                          style: const TextStyle(fontSize: 8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add the text input and send button
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _comment,
                    decoration: const InputDecoration(
                      hintText: 'Type your comment...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isPosted
                      ? null
                      : () async {
                          await postData(post.id);
                          List<dynamic> updatedComment =
                              await fetchPostList(post.id);
                          setState(() {
                            post.postsComments = updatedComment;
                            debugPrint(post.postsComments.toString());
                          });
                        },
                  child: _isPosted
                      ? 
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
