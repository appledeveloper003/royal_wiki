import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:royal_wiki/detail_screen.dart';
import 'package:royal_wiki/post_service.dart';
import 'dart:convert';

import 'post_service_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.\
// @GenerateMocks([http.Client])

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late PostService postService;
  final mockHttpClient = MockClient();

  //late MockHttpClient mockHttpClient;

  setUp(() {
    // mockHttpClient = MockHttpClient();
    postService = PostService(client: mockHttpClient);
  });

  group('PostService', () {
    test(
        'fetchPosts returns a list of posts if the http call completes successfully',
        () async {
      // Define the mock response
      final mockResponse = [
        {'userId': 1, 'id': 1, 'title': 'Test Title 1', 'body': 'Test Body 1'},
        {'userId': 2, 'id': 2, 'title': 'Test Title 2', 'body': 'Test Body 2'},
      ];

      // Configure the mock to return a successful response with the mock data
      when(mockHttpClient
              .get(Uri.parse('https://jsonplaceholder.typicode.com/posts')))
          .thenAnswer(
              (_) async => http.Response(jsonEncode(mockResponse), 200));

      // Call the service method
      final posts = await postService.fetchPosts();

      // Assert that the returned data matches the mock data
      expect(posts.length, 2);
      expect(posts.first.title, "Test Title 1");
      expect(posts, isA<List<Post>>());
    });

    test(
        'fetchPosts throws an exception if the http call completes with an error',
        () async {
      // Configure the mock to return an error response
      when(mockHttpClient
              .get(Uri.parse('https://jsonplaceholder.typicode.com/posts')))
          .thenAnswer((_) async => http.Response('Error', 404));

      final posts1 = postService.fetchPosts();

      // Assert that the returned data matches the mock data
      expect(posts1, throwsA(isA<Exception>()));

      // Assert that calling the service method throws an exception
      // expect(() => postService.fetchPosts(), throwsA(isA<Exception>()));
    });
  });
}
