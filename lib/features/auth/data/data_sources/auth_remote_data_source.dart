abstract interface class AuthRemoteDataSource {
  Future<String> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<String> signInWithGoogle({
    required String googleId,
    required String email,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  });

  Future<String> signUp({
    required String email,
    required String firstName,
    required String password,
    String? lastName,
    String? avatarUrl,
  });

  Future<void> signOut();
}
