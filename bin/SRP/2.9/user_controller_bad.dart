import 'dart:convert';
import 'dart:io';

// ❌ Controller handling multiple responsibilities
class UserController {
  final Map<String, dynamic> _users = {};
  final Map<String, String> _sessions = {};

  // Request handling + Validation + Business logic + Data access + Response formatting
  Future<void> createUser(HttpRequest request) async {
    try {
      // Parse request body
      final bodyString = await utf8.decoder.bind(request).join();
      final Map<String, dynamic> requestData = jsonDecode(bodyString);

      // Validate input (mixed in controller)
      if (requestData['email'] == null || requestData['email'].isEmpty) {
        _sendErrorResponse(request.response, 400, 'Email is required');
        return;
      }

      if (!_isValidEmail(requestData['email'])) {
        _sendErrorResponse(request.response, 400, 'Invalid email format');
        return;
      }

      if (requestData['password'] == null ||
          requestData['password'].length < 8) {
        _sendErrorResponse(
          request.response,
          400,
          'Password must be at least 8 characters',
        );
        return;
      }

      if (requestData['firstName'] == null ||
          requestData['firstName'].isEmpty) {
        _sendErrorResponse(request.response, 400, 'First name is required');
        return;
      }

      // Check if user exists (data access logic)
      final existingUser = _users[requestData['email']];
      if (existingUser != null) {
        _sendErrorResponse(request.response, 409, 'User already exists');
        return;
      }

      // Hash password (security logic)
      final hashedPassword = _hashPassword(requestData['password']);

      // Create user (business logic)
      final userId = _generateUserId();
      final user = {
        'id': userId,
        'email': requestData['email'],
        'firstName': requestData['firstName'],
        'lastName': requestData['lastName'] ?? '',
        'password': hashedPassword,
        'role': requestData['role'] ?? 'user',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
      };

      // Save to "database" (data access)
      _users[user['email']] = user;

      // Send welcome email (external service logic)
      await _sendWelcomeEmail(user['email'], user['firstName']);

      // Log user creation (logging logic)
      _logUserAction(userId, 'USER_CREATED', {
        'email': user['email'],
        'role': user['role'],
      });

      // Format and send response
      final responseUser = Map<String, dynamic>.from(user);
      responseUser.remove('password'); // Don't send password back

      request.response
        ..statusCode = 201
        ..headers.contentType = ContentType.json
        ..write(
          jsonEncode({
            'success': true,
            'message': 'User created successfully',
            'user': responseUser,
          }),
        );

      await request.response.close();
    } catch (e) {
      _sendErrorResponse(request.response, 500, 'Internal server error: $e');
    }
  }

  Future<void> loginUser(HttpRequest request) async {
    try {
      final bodyString = await utf8.decoder.bind(request).join();
      final Map<String, dynamic> loginData = jsonDecode(bodyString);

      // Validation
      if (loginData['email'] == null || loginData['password'] == null) {
        _sendErrorResponse(
          request.response,
          400,
          'Email and password required',
        );
        return;
      }

      // Find user (data access)
      final user = _users[loginData['email']];
      if (user == null) {
        _sendErrorResponse(request.response, 401, 'Invalid credentials');
        return;
      }

      // Verify password (security logic)
      if (!_verifyPassword(loginData['password'], user['password'])) {
        _sendErrorResponse(request.response, 401, 'Invalid credentials');
        return;
      }

      // Check if user is active (business logic)
      if (!user['isActive']) {
        _sendErrorResponse(request.response, 403, 'Account is deactivated');
        return;
      }

      // Generate session token (session management)
      final sessionToken = _generateSessionToken();
      _sessions[sessionToken] = user['id'];

      // Update last login (data access)
      user['lastLoginAt'] = DateTime.now().toIso8601String();

      // Log login (logging)
      _logUserAction(user['id'], 'USER_LOGIN', {
        'email': user['email'],
        'timestamp': user['lastLoginAt'],
      });

      // Send response
      request.response
        ..statusCode = 200
        ..headers.contentType = ContentType.json
        ..write(
          jsonEncode({
            'success': true,
            'message': 'Login successful',
            'token': sessionToken,
            'user': {
              'id': user['id'],
              'email': user['email'],
              'firstName': user['firstName'],
              'lastName': user['lastName'],
              'role': user['role'],
            },
          }),
        );

      await request.response.close();
    } catch (e) {
      _sendErrorResponse(request.response, 500, 'Internal server error: $e');
    }
  }

  Future<void> getUserProfile(HttpRequest request) async {
    try {
      // Extract user ID from URL path (routing logic)
      final pathSegments = request.uri.pathSegments;
      if (pathSegments.length < 3) {
        _sendErrorResponse(request.response, 400, 'User ID required');
        return;
      }

      final userId = pathSegments[2]; // /api/users/{id}

      // Authentication check (auth logic)
      final authHeader = request.headers.value('Authorization');
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        _sendErrorResponse(request.response, 401, 'Authorization required');
        return;
      }

      final token = authHeader.substring(7); // Remove "Bearer "
      final sessionUserId = _sessions[token];
      if (sessionUserId == null) {
        _sendErrorResponse(request.response, 401, 'Invalid token');
        return;
      }

      // Find user (data access)
      final user = _users.values.firstWhere(
        (u) => u['id'] == userId,
        orElse: () => {},
      );

      if (user.isEmpty) {
        _sendErrorResponse(request.response, 404, 'User not found');
        return;
      }

      // Authorization check (business logic)
      if (sessionUserId != userId && user['role'] != 'admin') {
        _sendErrorResponse(request.response, 403, 'Access denied');
        return;
      }

      // Format response (response formatting)
      final responseUser = Map<String, dynamic>.from(user);
      responseUser.remove('password');

      // Log access (logging)
      _logUserAction(sessionUserId, 'PROFILE_ACCESSED', {
        'targetUserId': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      request.response
        ..statusCode = 200
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'success': true, 'user': responseUser}));

      await request.response.close();
    } catch (e) {
      _sendErrorResponse(request.response, 500, 'Internal server error: $e');
    }
  }

  // All these helper methods mixed in controller
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  String _hashPassword(String password) {
    // Simplified hashing (in real app, use proper bcrypt)
    return password.split('').reversed.join() + 'salt123';
  }

  bool _verifyPassword(String password, String hashedPassword) {
    return _hashPassword(password) == hashedPassword;
  }

  String _generateUserId() {
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generateSessionToken() {
    return 'token_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _sendWelcomeEmail(String email, String firstName) async {
    // Simulate email sending
    print('Sending welcome email to $email for $firstName');
    await Future.delayed(Duration(milliseconds: 100));
  }

  void _logUserAction(
    String userId,
    String action,
    Map<String, dynamic> details,
  ) {
    final logEntry = {
      'userId': userId,
      'action': action,
      'details': details,
      'timestamp': DateTime.now().toIso8601String(),
    };
    print('LOG: ${jsonEncode(logEntry)}');
  }

  void _sendErrorResponse(
    HttpResponse response,
    int statusCode,
    String message,
  ) {
    response
      ..statusCode = statusCode
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({'success': false, 'message': message}));
    response.close();
  }
}

// Usage example
void badControllerExample() async {
  final controller = UserController();

  // This would be handled by a web framework in real scenarios
  print('UserController with mixed responsibilities created');
  print(
    'Contains: HTTP handling + Validation + Business logic + Data access + Auth + Logging + Email',
  );
}
