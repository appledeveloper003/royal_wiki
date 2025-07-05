import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:royal_wiki/post_service.dart';

Future<List<Post>> getPosts() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final List posts = json.decode(response.body);
    return posts.map((e) => Post.fromJson(e)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        userId: json['userId'] as int,
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String);
  }
}

class DetailScreen extends StatefulWidget {
  final PostService postService;
  const DetailScreen({super.key, required this.postService});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    //final client = PostService(client: http.Client());
    posts = widget.postService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        // iconTheme: IconThemeData(
        //   color: Colors.black, //change your color here
        // ),
        // leading: InkWell(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: const Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.black54,
        //   ),
        // ),
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: posts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final posts = snapshot.data!;
              return buildPosts(posts);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Widget buildPosts(List<Post> posts) {
  return ListView.builder(
    itemCount: posts.length,
    itemBuilder: (context, index) {
      final post = posts[index];
      return Container(
        // color: Colors.grey.shade300,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        // height: 80,
        // width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Text(post.id.toString()),
                Text(post.title),
                // Expanded(flex: 1, child: Text(post.id.toString())),
                // Expanded(flex: 8, child: Text(post.title)),
              ],
            ),
            Divider(
              color: Colors.grey[200],
            )
          ],
        ),
      );
    },
  );
}

class PostServicee {
  final String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
  final http.Client client;
  PostServicee({required this.client});

  Future<List<Post>> getPosts() async {
    final urll = Uri.parse(apiUrl);

    final response = await client.get(urll);
    if (response.statusCode == 200) {
      final posts = jsonDecode(response.body) as List<dynamic>;
      return posts.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception("Error while fetchimg");
    }
  }
}

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  late Future<List<Post>> posts;
  @override
  void initState() {
    super.initState();
    final client = PostServicee(client: http.Client());
    posts = client.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: FutureBuilder(
          future: posts,
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return CircularProgressIndicator();
            // }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final post = snapshot.data?[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => SelectedPost(
                                  selectedPost: post,
                                )));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text("${post?.id}"),
                                ),
                                Expanded(
                                    flex: 9, child: Text(post?.title ?? "")),
                              ],
                            ),
                            Divider()
                          ],
                        ),
                      ),
                    );
                  });
            }
            if (snapshot.hasError) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Error in fetching posts"),
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class SelectedPost extends StatelessWidget {
  final Post? selectedPost;
  const SelectedPost({super.key, this.selectedPost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(selectedPost?.title ?? ""),
              Text(selectedPost?.body ?? "")
            ],
          ),
        ),
      ),
    );
  }
}

/*

Generate mocks 

https://stackoverflow.com/questions/75893800/mocking-http-client-calls-in-flutter-test
*/
/*
GestureDetector class is very broad. you can detect every type of interaction the user has with the screen or widget using it. it includes pinch, swipe, touch, plus custom gestures.

InkWell has a limited number of gestures to detect but it gives you ways to decorate the widget. you can decorate


https://medium.com/@hustlewithflutter1406/flutter-gesturedetector-vs-inkwell-what-is-the-difference-9d3b9d68f931


Ref: https://stackoverflow.com/questions/56725308/inkwell-vs-gesturedetector-what-is-the-difference
*/
