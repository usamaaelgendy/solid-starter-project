class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  DateTime birthDate;
  String address;
  String phone;
  List<String> roles;
  DateTime lastLoginAt;
  bool isActive;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.birthDate,
    required this.address,
    required this.phone,
    required this.roles,
    required this.lastLoginAt,
    required this.isActive,
  });

  bool isValidEmail() {
    return email.contains('@') && email.contains('.');
  }

  bool isValidPassword() {
    return password.length >= 8 &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[A-Z]'));
  }

  List<String> getValidationErrors() {
    List<String> errors = [];
    if (firstName.isEmpty) errors.add('First name required');
    if (lastName.isEmpty) errors.add('Last name required');
    if (!isValidEmail()) errors.add('Invalid email format');
    if (!isValidPassword()) errors.add('Password too weak');
    return errors;
  }

  String getFullName() {
    return '$firstName $lastName';
  }

  String getDisplayName() {
    return '${firstName[0]}${lastName[0]}';
  }

  String formatAddress() {
    return address.replaceAll('\n', ', ');
  }

  int getAge() {
    return DateTime.now().year - birthDate.year;
  }

  bool isAdult() {
    return getAge() >= 18;
  }

  bool canAccess(String resource) {
    return roles.contains('admin') || roles.contains(resource);
  }

  void save() {
    print('Saving user $id to database');
    lastLoginAt = DateTime.now();
  }

  static User? loadById(String id) {
    print('Loading user $id from database');
    return null;
  }

  void delete() {
    print('Deleting user $id from database');
    isActive = false;
  }

  bool checkPassword(String inputPassword) {
    return password == inputPassword;
  }

  void updatePassword(String newPassword) {
    if (User.isPasswordStrong(newPassword)) {
      password = newPassword;
    }
  }

  static bool isPasswordStrong(String password) {
    return password.length >= 8;
  }

  void sendWelcomeEmail() {
    print('Sending welcome email to $email');
  }

  void sendPasswordResetEmail() {
    print('Sending password reset email to $email');
  }
}

void main() {
  final user = User(
    id: 'user-001',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    password: 'SecurePass123',
    birthDate: DateTime(1990, 5, 15),
    address: '123 Main St\nAnytown, USA',
    phone: '555-1234',
    roles: ['user', 'editor'],
    lastLoginAt: DateTime.now().subtract(Duration(days: 1)),
    isActive: true,
  );

  if (user.getValidationErrors().isEmpty) {
    print('User: ${user.getFullName()}');
    print('Age: ${user.getAge()}');
    print('Can edit: ${user.canAccess('editor')}');

    user.save();
    user.sendWelcomeEmail();

    if (user.checkPassword('SecurePass123')) {
      print('Password correct');
    }
  }
}
