import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:royal_wiki/detail_screen.dart';

import 'post_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final httpCL = MockClient();

  group('PostService', () {
    test("description", () async {
      final mockres = [
        {'userId': 1, 'id': 1, 'title': 'Test Title 1', 'body': 'Test Body 1'},
        {'userId': 2, 'id': 2, 'title': 'Test Title 2', 'body': 'Test Body 2'},
      ];
      final mpc = PostServicee(client: httpCL);
      when(httpCL.get(Uri.parse('https://jsonplaceholder.typicode.com/posts')))
          .thenAnswer((_) async => http.Response(jsonEncode(mockres), 200));

      final res = await mpc.getPosts();

      expect(res, isA<List<Post>>());
    });

    test("failure", () async {
      final mpc = PostServicee(client: httpCL);
      when(httpCL.get(Uri.parse('https://jsonplaceholder.typicode.com/posts')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final res1 = mpc.getPosts();

      expect(res1, throwsA(isA<Exception>()));
    });
  });
}
