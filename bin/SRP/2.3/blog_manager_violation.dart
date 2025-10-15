class BlogPost {
  String id;
  String title;
  String content;
  String authorId;
  DateTime publishedAt;
  List<String> tags;

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.publishedAt,
    required this.tags,
  });
}

class BlogManager {
  List<BlogPost> posts = [];

  bool isValidPost(BlogPost post) {
    return post.title.isNotEmpty &&
        post.content.length > 100 &&
        post.tags.isNotEmpty;
  }

  String formatForDisplay(BlogPost post) {
    final tagString = post.tags.join(', ');
    return '''
Title: ${post.title}
Author: ${post.authorId}
Published: ${post.publishedAt.toIso8601String()}
Tags: $tagString
Content: ${post.content.substring(0, 100)}...
''';
  }

  List<BlogPost> searchByTag(String tag) {
    return posts
        .where(
          (post) =>
              post.tags.any((t) => t.toLowerCase().contains(tag.toLowerCase())),
        )
        .toList();
  }

  List<BlogPost> searchByAuthor(String authorId) {
    return posts.where((post) => post.authorId == authorId).toList();
  }

  void savePost(BlogPost post) {
    posts.add(post);
    print('Saving post ${post.id} to database');
  }

  void deletePost(String postId) {
    posts.removeWhere((post) => post.id == postId);
    print('Deleting post $postId from database');
  }

  void notifySubscribers(BlogPost post) {
    print('Sending email notification for new post: ${post.title}');
  }

  void trackPostView(String postId) {
    print('Tracking view for post $postId');
  }

  void trackPostShare(String postId, String platform) {
    print('Tracking share for post $postId on $platform');
  }
}

// Usage example showing the violation
void main() {
  final blog = BlogManager();
  final post = BlogPost(
    id: 'post-001',
    title: 'Learning SOLID Principles',
    content:
        'This is a comprehensive guide to SOLID principles that will help you write better, more maintainable code. The principles are fundamental to object-oriented design...',
    authorId: 'author-123',
    publishedAt: DateTime.now(),
    tags: ['programming', 'solid', 'design-patterns'],
  );

  if (blog.isValidPost(post)) {
    blog.savePost(post);
    blog.notifySubscribers(post);
    blog.trackPostView(post.id);

    final formatted = blog.formatForDisplay(post);
    print(formatted);

    final relatedPosts = blog.searchByTag('programming');
    print('Found ${relatedPosts.length} related posts');
  }
}
