import 'dart:io';
import 'dart:convert';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  DateTime birthDate;
  List<String> roles;
  bool isActive;
  DateTime createdAt;
  DateTime lastLoginAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthDate,
    required this.roles,
    this.isActive = true,
    required this.createdAt,
    required this.lastLoginAt,
  });
}

class UserManager {
  List<User> _users = [];
  final String _dataFilePath = 'users.json';

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  bool isValidName(String name) {
    return name.isNotEmpty && name.length >= 2 && name.length <= 50;
  }

  bool isValidAge(DateTime birthDate) {
    final age = DateTime.now().year - birthDate.year;
    return age >= 13 && age <= 120;
  }

  List<String> validateUser(User user) {
    List<String> errors = [];

    if (!isValidName(user.firstName)) {
      errors.add('First name must be 2-50 characters');
    }
    if (!isValidName(user.lastName)) {
      errors.add('Last name must be 2-50 characters');
    }
    if (!isValidEmail(user.email)) {
      errors.add('Invalid email format');
    }
    if (!isValidAge(user.birthDate)) {
      errors.add('Age must be between 13 and 120');
    }
    if (user.roles.isEmpty) {
      errors.add('At least one role is required');
    }

    return errors;
  }

  String generateUserId() {
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  User createUser({
    required String firstName,
    required String lastName,
    required String email,
    required DateTime birthDate,
    required List<String> roles,
  }) {
    final user = User(
      id: generateUserId(),
      firstName: firstName,
      lastName: lastName,
      email: email,
      birthDate: birthDate,
      roles: roles,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    final validationErrors = validateUser(user);
    if (validationErrors.isNotEmpty) {
      throw Exception('User validation failed: ${validationErrors.join(', ')}');
    }

    if (_users.any((u) => u.email == email)) {
      throw Exception('User with email $email already exists');
    }

    _users.add(user);
    saveToFile();
    sendWelcomeEmail(user);
    logUserCreation(user);

    return user;
  }

  void updateUser(String userId, {
    String? firstName,
    String? lastName,
    String? email,
    List<String>? roles,
    bool? isActive,
  }) {
    final user = getUserById(userId);
    if (user == null) {
      throw Exception('User not found');
    }

    if (firstName != null) user.firstName = firstName;
    if (lastName != null) user.lastName = lastName;
    if (email != null) {
      if (_users.any((u) => u.id != userId && u.email == email)) {
        throw Exception('Email already exists');
      }
      user.email = email;
    }
    if (roles != null) user.roles = roles;
    if (isActive != null) user.isActive = isActive;

    final validationErrors = validateUser(user);
    if (validationErrors.isNotEmpty) {
      throw Exception('User validation failed: ${validationErrors.join(', ')}');
    }

    saveToFile();
    logUserUpdate(user);
  }

  void deleteUser(String userId) {
    final user = getUserById(userId);
    if (user == null) {
      throw Exception('User not found');
    }

    user.isActive = false;
    saveToFile();
    logUserDeletion(user);
  }

  User? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  User? getUserByEmail(String email) {
    try {
      return _users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  List<User> getActiveUsers() {
    return _users.where((user) => user.isActive).toList();
  }

  List<User> getUsersByRole(String role) {
    return _users.where((user) =>
    user.isActive && user.roles.contains(role)
    ).toList();
  }

  List<User> searchUsers(String searchTerm) {
    final term = searchTerm.toLowerCase();
    return _users.where((user) =>
    user.isActive && (
        user.firstName.toLowerCase().contains(term) ||
            user.lastName.toLowerCase().contains(term) ||
            user.email.toLowerCase().contains(term)
    )
    ).toList();
  }

  void loadFromFile() {
    try {
      final file = File(_dataFilePath);
      if (!file.existsSync()) return;

      final jsonString = file.readAsStringSync();
      final List<dynamic> jsonList = jsonDecode(jsonString);

      _users = jsonList.map((json) => User(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        birthDate: DateTime.parse(json['birthDate']),
        roles: List<String>.from(json['roles']),
        isActive: json['isActive'] ?? true,
        createdAt: DateTime.parse(json['createdAt']),
        lastLoginAt: DateTime.parse(json['lastLoginAt']),
      )).toList();

      print('Loaded ${_users.length} users from file');
    } catch (e) {
      print('Error loading users: $e');
      _users = [];
    }
  }

  void saveToFile() {
    try {
      final jsonList = _users.map((user) => {
        'id': user.id,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'birthDate': user.birthDate.toIso8601String(),
        'roles': user.roles,
        'isActive': user.isActive,
        'createdAt': user.createdAt.toIso8601String(),
        'lastLoginAt': user.lastLoginAt.toIso8601String(),
      }).toList();

      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);
      final file = File(_dataFilePath);
      file.writeAsStringSync(jsonString);

      print('Saved ${_users.length} users to file');
    } catch (e) {
      print('Error saving users: $e');
    }
  }

  // Responsibility 5: Email Notifications
  void sendWelcomeEmail(User user) {
    print('📧 Sending welcome email to ${user.email}');
    print('Subject: Welcome ${user.firstName}!');
    print('Body: Welcome to our platform, ${user.firstName} ${user.lastName}');

  }

  void sendPasswordResetEmail(User user) {
    print('📧 Sending password reset email to ${user.email}');
    print('Subject: Password Reset Request');
    print('Body: Reset your password, ${user.firstName}');
  }

  void sendRoleChangeNotification(User user, List<String> newRoles) {
    print('📧 Sending role change notification to ${user.email}');
    print('Subject: Your roles have been updated');
    print('Body: Your roles are now: ${newRoles.join(', ')}');
  }

  void logUserCreation(User user) {
    final timestamp = DateTime.now().toIso8601String();
    print('📝 LOG [$timestamp]: User created - ${user.id} (${user.email})');

  }

  void logUserUpdate(User user) {
    final timestamp = DateTime.now().toIso8601String();
    print('📝 LOG [$timestamp]: User updated - ${user.id} (${user.email})');
  }

  void logUserDeletion(User user) {
    final timestamp = DateTime.now().toIso8601String();
    print('📝 LOG [$timestamp]: User deleted - ${user.id} (${user.email})');
  }

  void logUserLogin(User user) {
    user.lastLoginAt = DateTime.now();
    final timestamp = DateTime.now().toIso8601String();
    print('📝 LOG [$timestamp]: User login - ${user.id} (${user.email})');
    saveToFile();
  }

  int getTotalUserCount() {
    return _users.length;
  }

  int getActiveUserCount() {
    return _users.where((user) => user.isActive).length;
  }

  Map<String, int> getRoleStatistics() {
    Map<String, int> stats = {};

    for (var user in _users.where((u) => u.isActive)) {
      for (var role in user.roles) {
        stats[role] = (stats[role] ?? 0) + 1;
      }
    }

    return stats;
  }

  List<User> getRecentUsers(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _users.where((user) =>
    user.isActive && user.createdAt.isAfter(cutoff)
    ).toList();
  }

  double getAverageUserAge() {
    final activeUsers = _users.where((user) => user.isActive);
    if (activeUsers.isEmpty) return 0.0;

    final totalAge = activeUsers.fold<int>(0, (sum, user) {
      return sum + (DateTime.now().year - user.birthDate.year);
    });

    return totalAge / activeUsers.length;
  }
}


void main() {
  final userManager = UserManager();

  userManager.loadFromFile();

  try {
    final newUser = userManager.createUser(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      birthDate: DateTime(1990, 5, 15),
      roles: ['user', 'editor'],
    );

    print('Created user: ${newUser.firstName} ${newUser.lastName}');

    final searchResults = userManager.searchUsers('john');
    print('Search results: ${searchResults.length} users found');
    print('Total users: ${userManager.getTotalUserCount()}');
    print('Active users: ${userManager.getActiveUserCount()}');
    print('Average age: ${userManager.getAverageUserAge().toStringAsFixed(1)}');

    final roleStats = userManager.getRoleStatistics();
    print('Role statistics: $roleStats');

    userManager.updateUser(
      newUser.id,
      firstName: 'Jonathan',
      roles: ['user', 'admin'],
    );

    userManager.logUserLogin(newUser);

    userManager.sendPasswordResetEmail(newUser);

  } catch (e) {
    print('Error: $e');
  }
}