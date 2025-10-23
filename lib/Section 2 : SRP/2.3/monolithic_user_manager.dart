// Simple User data class
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final List<String> roles;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.roles,
  });
}

class UserManager {
  final List<User> _users = [];

  // Job 1: Generate IDs
  String _generateId() {
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Job 2: Validate user data
  bool _isValidEmail(String email) {
    return email.contains('@') && email.length > 5;
  }

  bool _isValidName(String name) {
    return name.isNotEmpty && name.length >= 2;
  }

  // Job 3: Save and load users
  void _saveToFile() {
    print('Saving ${_users.length} users to file...');
  }

  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Job 4: Search functionality
  List<User> searchUsers(String term) {
    return _users
        .where(
          (user) => user.firstName.contains(term) || user.email.contains(term),
        )
        .toList();
  }

  // Job 5: Send emails
  void _sendWelcomeEmail(User user) {
    print('📧 Sending welcome email to ${user.email}');
    print('Subject: Welcome ${user.firstName}!');
  }

  // Job 6: Logging
  void _logUserCreation(User user) {
    final timestamp = DateTime.now();
    print('📝 LOG [$timestamp]: User created - ${user.id} (${user.email})');
  }

  // Job 7: Statistics
  int getTotalUsers() => _users.length;

  Map<String, int> getRoleStatistics() {
    Map<String, int> stats = {};
    for (var user in _users) {
      for (var role in user.roles) {
        stats[role] = (stats[role] ?? 0) + 1;
      }
    }
    return stats;
  }

  // The main method that uses ALL 7 jobs - chaos!
  User createUser(
    String firstName,
    String lastName,
    String email,
    List<String> roles,
  ) {
    // Job 1: Generate ID
    final id = _generateId();

    // Job 2: Validate
    if (!_isValidName(firstName) ||
        !_isValidName(lastName) ||
        !_isValidEmail(email)) {
      throw Exception('Invalid user data');
    }

    // Create user
    final user = User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      roles: roles,
    );

    // Job 3: Save
    _users.add(user);
    _saveToFile();

    // Job 5: Send email
    _sendWelcomeEmail(user);

    // Job 6: Log
    _logUserCreation(user);

    return user;
  }
}






void main() {
  final manager = UserManager();

  try {
    final user = manager.createUser('Alice', 'Smith', 'alice@example.com', [
      'user',
    ]);
    print('✅ Created user: ${user.firstName} ${user.lastName}');

    final searchResults = manager.searchUsers('alice');
    print('Found ${searchResults.length} users');

    print('📊 Total users: ${manager.getTotalUsers()}');
    print('📊 Role stats: ${manager.getRoleStatistics()}');
  } catch (e) {
    print('Error: $e');
  }
}
