class DsCustomMiddleWareDatabase {
  static final Map<String, String> users = {
    'user1': 'password1',
    'user2': 'password2',
  };

  static bool authenticate(String username, String password) {
    return users.containsKey(username) && users[username] == password;
  }
}
