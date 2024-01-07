import 'dart:convert';
import 'dart:io';

import 'package:fitforfree/models/post.dart';
import 'package:fitforfree/services/add_post.dart';
import 'package:fitforfree/services/read_post.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsList extends StatefulWidget {
  const NewsList({Key? key}) : super(key: key);

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

  Future<List<Post>> fetchPostList() async {
    try {
      final accessToken = client.auth.currentSession?.accessToken;
      print(accessToken);
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
      print('Error fetching posts: $e');
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
           child: Text('Forum')
        ),
        shadowColor: Colors.black,
      ),
      body: FutureBuilder<List<Post>>(
        future: _postList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Post> postList = snapshot.data!;
            return ListView.builder(
              itemCount: postList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                      Navigator.push
                      (context, MaterialPageRoute(builder: (context) 
                      {return const ReadPost();},
                      settings: RouteSettings(arguments: {'postList': postList[index]}
                      ),
                      ),
                      );
                  },
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ListTile(
                        
                        title: Text(postList[index].titleName),
                        subtitle: Text(
                          'Created by: ${postList[index].author}\n${postList[index].likes}\n${postList[index].description}',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          // TextButton(
                          //   child: Text("♥  ${postList[index].likes}"),
                          //   onPressed: () {
                          //     },
                              
                          // ), 
                          const SizedBox(width: 3,height: 10,),
                          TextButton(
                            child: Text("comments: ${postList[index].postsComments.length}"),
                            onPressed: () {/* ... */},
                          ),
                          const SizedBox(width: 3, height: 10,),
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
        backgroundColor: Color.fromARGB(255, 12, 47, 173),
        onPressed: () async {
           final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPost()),
                );
           if (result) {
            setState(() {
              _postList = fetchPostList();
            });
           }
          },
          
        child: const Icon(Icons.add_box_outlined, color: Colors.white,),
      ),
    );
  }
}
