mixin Reviewable {
  final List<Map<String, dynamic>> _reviews = [];

  void addReview(String userId, int rating, String comment) {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }
    _reviews.add({
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'date': DateTime.now(),
      'helpful': 0,
    });
    print('Review added: $rating stars - "$comment"');
  }

  List<Map<String, dynamic>> getReviews() => List.unmodifiable(_reviews);

  double getAverageRating() {
    if (_reviews.isEmpty) return 0.0;
    var sum = _reviews.fold(0, (total, review) => total + (review['rating'] as int));
    return (sum / _reviews.length * 10).round() / 10; // Round to 1 decimal
  }

  int getReviewCount() => _reviews.length;

  void markReviewHelpful(int reviewIndex) {
    if (reviewIndex >= 0 && reviewIndex < _reviews.length) {
      _reviews[reviewIndex]['helpful'] = (_reviews[reviewIndex]['helpful'] as int) + 1;
    }
  }
}