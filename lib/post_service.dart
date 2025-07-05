import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:royal_wiki/detail_screen.dart';

class PostService {
  final String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
  final http.Client client;

  PostService({required this.client});

  Future<List<Post>> fetchPosts() async {
    final response = await client.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      debugPrint(response.body);
      final List posts = json.decode(response.body);
      debugPrint(posts.toString());

      return posts.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
