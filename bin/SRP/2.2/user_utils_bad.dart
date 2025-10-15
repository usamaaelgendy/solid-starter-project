import 'dart:io';

class User {
  String id;
  String email;
  DateTime birthDate;

  User({required this.id, required this.email, required this.birthDate});
}

class UserUtils {
  static bool isValidEmail(String email) {
    return email.contains('@');
  }

  static String formatName(String first, String last) {
    return '$first $last'.trim();
  }

  static int calculateAge(DateTime birthDate) {
    return DateTime.now().year - birthDate.year;
  }

  static void saveUserPhoto(String userId, File photo) {
    // Save photo logic
    print('Saving photo for user $userId');
  }

  static Future<String> fetchUserProfile(String userId) async {
    // API call logic
    await Future.delayed(Duration(seconds: 1));
    return 'profile data for $userId';
  }

  static String hashPassword(String password) {
    return '${password}_hashed';
  }
}

void main() async {
  final user = User(
    id: 'user123',
    email: 'john@example.com',
    birthDate: DateTime(1990, 5, 15),
  );

  final isValid = UserUtils.isValidEmail(user.email);
  final fullName = UserUtils.formatName('John', 'Doe');
  final age = UserUtils.calculateAge(user.birthDate);
  final hashedPassword = UserUtils.hashPassword('secret123');

  print('Valid email: $isValid');
  print('Full name: $fullName');
  print('Age: $age');
  print('Hashed password: $hashedPassword');

  UserUtils.saveUserPhoto(user.id, File('photo.jpg'));
  final profile = await UserUtils.fetchUserProfile(user.id);
  print('Profile: $profile');
}
