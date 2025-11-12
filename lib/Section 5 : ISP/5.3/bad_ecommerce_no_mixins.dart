import 'dart:io';

abstract class Shippable {
  String getShippingAddress();

  void setShippingAddress(String address);

  double calculateShippingCost();

  String getTrackingNumber();
}

abstract class Reviewable {
  void addReview(String userId, int rating, String comment);

  List<Map<String, dynamic>> getReviews();

  double getAverageRating();
}

abstract class Returnable {
  bool canReturn();

  int getReturnWindowDays();

  void initiateReturn(String reason);
}

abstract class Downloadable {
  String getDownloadUrl();

  int getFileSize();

  void download(String path);
}

class PhysicalBook implements Shippable, Reviewable, Returnable {
  String title;
  String author;
  double price;
  String _shippingAddress = '';
  final String _trackingNumber = '';
  final List<Map<String, dynamic>> _reviews = [];

  PhysicalBook(this.title, this.author, this.price);

  @override
  String getShippingAddress() => _shippingAddress;

  @override
  void setShippingAddress(String address) {
    _shippingAddress = address;
  }

  @override
  double calculateShippingCost() {
    return 5.99;
  }

  @override
  String getTrackingNumber() => _trackingNumber;

  @override
  void addReview(String userId, int rating, String comment) {
    _reviews.add({
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'date': DateTime.now(),
    });
  }

  @override
  List<Map<String, dynamic>> getReviews() => _reviews;

  @override
  double getAverageRating() {
    if (_reviews.isEmpty) return 0.0;
    var sum = _reviews.fold(
      0,
      (total, review) => total + (review['rating'] as int),
    );
    return sum / _reviews.length;
  }

  @override
  bool canReturn() => true;

  @override
  int getReturnWindowDays() => 30;

  @override
  void initiateReturn(String reason) {
    print('Return initiated for $title. Reason: $reason');
  }
}

class EBook implements Downloadable, Reviewable {
  String title;
  String author;
  double price;
  String _downloadUrl = '';
  int _fileSize = 0;
  List<Map<String, dynamic>> _reviews = [];

  EBook(this.title, this.author, this.price, this._downloadUrl, this._fileSize);

  @override
  String getDownloadUrl() => _downloadUrl;

  @override
  int getFileSize() => _fileSize;

  @override
  void download(String path) {
    print('Downloading $title to $path...');
  }

  @override
  void addReview(String userId, int rating, String comment) {
    _reviews.add({
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'date': DateTime.now(),
    });
  }

  @override
  List<Map<String, dynamic>> getReviews() => _reviews;

  @override
  double getAverageRating() {
    if (_reviews.isEmpty) return 0.0;
    var sum = _reviews.fold(
      0,
      (total, review) => total + (review['rating'] as int),
    );
    return sum / _reviews.length;
  }
}

class Clothing implements Shippable, Reviewable, Returnable {
  String name;
  String size;
  String color;
  double price;
  String _shippingAddress = '';
  final String _trackingNumber = '';
  final List<Map<String, dynamic>> _reviews = [];

  Clothing(this.name, this.size, this.color, this.price);

  @override
  String getShippingAddress() => _shippingAddress;

  @override
  void setShippingAddress(String address) {
    _shippingAddress = address;
  }

  @override
  double calculateShippingCost() {
    return 5.99;
  }

  @override
  String getTrackingNumber() => _trackingNumber;

  @override
  void addReview(String userId, int rating, String comment) {
    _reviews.add({
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'date': DateTime.now(),
    });
  }

  @override
  List<Map<String, dynamic>> getReviews() => _reviews;

  @override
  double getAverageRating() {
    if (_reviews.isEmpty) return 0.0;
    var sum = _reviews.fold(
      0,
      (total, review) => total + (review['rating'] as int),
    );
    return sum / _reviews.length;
  }

  @override
  bool canReturn() => true;

  @override
  int getReturnWindowDays() => 60;

  @override
  void initiateReturn(String reason) {
    print('Return initiated for $name. Reason: $reason');
  }
}

void main() {
  var book = PhysicalBook('Clean Code', 'Robert Martin', 29.99);
  var ebook = EBook(
    'Design Patterns',
    'Gang of Four',
    19.99,
    'https://example.com/download',
    5242880,
  );
  var shirt = Clothing('T-Shirt', 'L', 'Blue', 24.99);

  book.addReview('user1', 5, 'Great book!');
  ebook.addReview('user2', 4, 'Very helpful');
  shirt.addReview('user3', 5, 'Perfect fit!');

  print('Book average rating: ${book.getAverageRating()}');
  print('E-book average rating: ${ebook.getAverageRating()}');
  print('Shirt average rating: ${shirt.getAverageRating()}');
}
