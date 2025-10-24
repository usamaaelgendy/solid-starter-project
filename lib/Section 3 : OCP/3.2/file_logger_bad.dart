import 'dart:io';

class FileLogger {
  final String filePath;

  FileLogger(this.filePath);

  void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] $message\n';

    File(filePath).writeAsStringSync(logEntry, mode: FileMode.append);
    print('Logged to file: $logEntry');
  }
}


class UserService {
  final FileLogger _logger;

  UserService(this._logger);

  void createUser(String username) {
    print('Creating user: $username');

    _logger.log('User created: $username');
  }

  void deleteUser(String username) {
    print('Deleting user: $username');
    _logger.log('User deleted: $username');
  }
}

void main() {
  final logger = FileLogger('app.log');
  final userService = UserService(logger);

  userService.createUser('Alice');
  userService.deleteUser('Bob');
}
