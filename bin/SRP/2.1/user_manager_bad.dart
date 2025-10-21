class UserManager {
  String name = '';
  String email = '';

  bool isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  String hashPassword(String password) {
    return '${password}_hashed';
  }

  void saveToDatabase() {
    print('Saving user $name to database...');
  }

  void sendWelcomeEmail() {
    print('Sending welcome email to $email...');
  }

  void logUserCreation() {
    print('LOG: User $name created at ${DateTime.now()}');
  }

  void createUser(String name, String email, String password) {
    this.name = name;
    this.email = email;

    if (!isValidEmail(email)) return;

    hashPassword(password);
    saveToDatabase();
    sendWelcomeEmail();
    logUserCreation();
  }
}

void main() {
  final manager = UserManager();
  manager.createUser('John', 'john@example.com', 'password123');
}
