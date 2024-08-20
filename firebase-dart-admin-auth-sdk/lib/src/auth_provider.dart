abstract class AuthProvider {
  String get providerId;
}

class FacebookAuthProvider implements AuthProvider {
  @override
  String get providerId => 'facebook.com';
}

class GoogleAuthProvider implements AuthProvider {
  @override
  String get providerId => 'google.com';
}

class TwitterAuthProvider implements AuthProvider {
  @override
  String get providerId => 'twitter.com';
}

class GithubAuthProvider implements AuthProvider {
  @override
  String get providerId => 'github.com';
}
