import '../models/user.dart';

/// Service for managing User
class UserService {
  final List<User> _items = [];
  
  /// Get all items
  List<User> getAll() => List.unmodifiable(_items);
  
  /// Get item by ID
  User? getById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
  
  /// Create new item
  User create(Map<String, dynamic> data) {
    final item = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: data['name'] as String,
      createdAt: DateTime.now(),
    );
    _items.add(item);
    return item;
  }
  
  /// Update existing item
  User? update(String id, Map<String, dynamic> data) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    
    final updated = _items[index].copyWith(
      name: data['name'] as String?,
      updatedAt: DateTime.now(),
    );
    _items[index] = updated;
    return updated;
  }
  
  /// Delete item
  bool delete(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return false;
    
    _items.removeAt(index);
    return true;
  }
}
