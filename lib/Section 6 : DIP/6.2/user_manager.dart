class Logger {
  void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] $message');
  }
}

class DatabaseConnection {
  final String connectionString = 'localhost:5432';

  Future<void> connect() async {
    print('Connecting to database at $connectionString...');
    await Future.delayed(Duration(milliseconds: 500));
    print('Connected to database');
  }

  Future<void> saveUser(User user) async {
    print('Saving user ${user.name} to database...');
    await Future.delayed(Duration(milliseconds: 200));
  }

  Future<User?> findUserById(String id) async {
    print('Finding user by id: $id...');
    await Future.delayed(Duration(milliseconds: 200));
    return User(id: id, name: 'John Doe', email: 'john@example.com');
  }
}

class EmailService {
  void sendWelcomeEmail(String email) {
    print('Sending welcome email to $email...');
  }
}

class UserManager {
  final Logger _logger = Logger();
  final DatabaseConnection _database = DatabaseConnection();
  final EmailService _emailService = EmailService();


  Future<void> initialize() async {
    _logger.log('Initializing UserManager');
    await _database.connect();
  }

  Future<void> createUser(String name, String email) async {
    _logger.log('Creating new user: $name');

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );

    await _database.saveUser(user);
    _emailService.sendWelcomeEmail(email);

    _logger.log('User created successfully: ${user.id}');
  }

  Future<User?> getUser(String id) async {
    _logger.log('Fetching user: $id');
    return await _database.findUserById(id);
  }
}

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

void main() async {
  final userManager = UserManager();
  await userManager.initialize();
  await userManager.createUser('Alice Smith', 'alice@example.com');
}
