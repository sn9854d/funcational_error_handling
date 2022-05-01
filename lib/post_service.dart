import 'dart:convert';

import 'dart:io';

class FakeHttpClient {
  Future<String> getResponseBody() async {
    await Future.delayed(const Duration(milliseconds: 500));
    //! No Internet Connection
    // throw const SocketException('No Internet');
    //! 404
    // throw const HttpException('404');

    //! Invalid JSON (throws FormatException)
    // throw const FileSystemException();
    // return 'abcd';
    return '{"userId":1,"id":1,"title":"nice title","body":"cool body"}';
  }
}

class PostService {
  final httpClient = FakeHttpClient();
  Future<Post> getOnePost() async {
    try {
      final responseBody = await httpClient.getResponseBody();
      return Post.fromJson(responseBody);
    } on SocketException {
      throw Failure('No Internet connection 😑');
    } on HttpException {
      throw Failure("Couldn't find the post 😱");
    } on FormatException {
      throw Failure("Bad response format 👎");
    }
  }
}

class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;
  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  Post copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) {
    return Post(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      userId: map['userId']?.toInt() ?? 0,
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(userId: $userId, id: $id, title: $title, body: $body)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.userId == userId &&
        other.id == id &&
        other.title == title &&
        other.body == body;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ id.hashCode ^ title.hashCode ^ body.hashCode;
  }
}
