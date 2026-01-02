import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../../shared/constants/app_constants.dart';

class HiveAuthService {
  static HiveAuthService? _instance;
  static HiveAuthService get instance => _instance ??= HiveAuthService._();

  HiveAuthService._();

  late Box<User> _userBox;
  late Box<String> _currentUserBox;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    try {
      print('HiveAuthService: Initializing...');
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
      print('HiveAuthService: Hive initialized at ${appDocumentDir.path}');

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserAdapter());
        print('HiveAuthService: UserAdapter registered');
      }

      _userBox = await Hive.openBox<User>(AppConstants.userBoxName);
      _currentUserBox = await Hive.openBox<String>();
      print('HiveAuthService: Boxes opened successfully');
      print('HiveAuthService: Current users in box: ${_userBox.length}');
      _isInitialized = true;
      print('HiveAuthService: Initialization complete');
    } catch (e) {
      print('HiveAuthService: Initialization error: $e');
      rethrow;
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) {
      print('HiveAuthService: Not initialized, calling init()');
      await init();
    }

    try {
      print('HiveAuthService: Attempting signup for email: $email');
      final existingUsers = _userBox.values.where(
        (user) => user.email == email,
      );
      if (existingUsers.isNotEmpty) {
        print('HiveAuthService: Email already exists: $email');
        return false;
      }

      final user = User.create(name: name, email: email, password: password);
      print('HiveAuthService: Created new user: ${user.email}, ID: ${user.id}');

      await _userBox.add(user);
      await _currentUserBox.put('current_user', user.id);
      print(
        'HiveAuthService: Signup successful and logged in user: ${user.email}',
      );

      return true;
    } catch (e) {
      print('HiveAuthService: Signup error: $e');
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    if (!_isInitialized) {
      print('HiveAuthService: Not initialized, calling init()');
      await init();
    }

    try {
      print('HiveAuthService: Looking for user with email: $email');
      final user = _userBox.values.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () {
          print('HiveAuthService: User not found or password mismatch');
          throw Exception('User not found');
        },
      );

      await _currentUserBox.put('current_user', user.id);
      print('HiveAuthService: Login successful for user: ${user.email}');
      return true;
    } catch (e) {
      print('HiveAuthService: Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _currentUserBox.clear();
  }

  User? getCurrentUser() {
    final currentUserId = _currentUserBox.get('current_user');
    if (currentUserId == null) return null;

    try {
      return _userBox.values.firstWhere((user) => user.id == currentUserId);
    } catch (e) {
      return null;
    }
  }

  bool isLoggedIn() {
    return _currentUserBox.containsKey('current_user');
  }

  Future<void> clearAllData() async {
    await _userBox.clear();
    await _currentUserBox.clear();
  }

  Future<void> close() async {
    await _userBox.close();
    await _currentUserBox.close();
  }
}
