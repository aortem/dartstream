import '../models/user.dart';

/// Repository interface for User
abstract class UserRepository {
  Future<List<User>> findAll();
  Future<User?> findById(String id);
  Future<User> save(User item);
  Future<void> delete(String id);
}

/// In-memory implementation
class InMemoryUserRepository implements UserRepository {
  final Map<String, User> _storage = {};
  
  @override
  Future<List<User>> findAll() async {
    return _storage.values.toList();
  }
  
  @override
  Future<User?> findById(String id) async {
    return _storage[id];
  }
  
  @override
  Future<User> save(User item) async {
    _storage[item.id] = item;
    return item;
  }
  
  @override
  Future<void> delete(String id) async {
    _storage.remove(id);
  }
}
