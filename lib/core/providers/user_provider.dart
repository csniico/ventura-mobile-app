import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventura/core/models/user/user.dart';
import 'package:ventura/core/services/user/user_service.dart';

final userProvider = AsyncNotifierProvider<UserAsyncNotifier, User?>(
  () => UserAsyncNotifier(),
);
final userIdProvider = Provider((ref) => ref.watch(userProvider).value?.id);
final userEmailProvider = Provider(
  (ref) => ref.watch(userProvider).value?.email,
);
final userAvatarProvider = Provider(
  (ref) => ref.watch(userProvider).value?.avatarUrl,
);
final userEmployerBusinessProvider = Provider(
  (ref) => ref.watch(userProvider).value?.employerBusiness,
);

final isAuthenticatedProvider = Provider((ref) {
  return ref.watch(userProvider).value != null;
});

class UserAsyncNotifier extends AsyncNotifier<User?> {
  final UserService _userService = UserService();

  @override
  Future<User?> build() async {
    await _userService.loadUser();
    return _userService.user;
  }

  Future<void> refreshUser() async {
    state = const AsyncValue.loading();
    try {
      await _userService.loadUser();
      state = AsyncValue.data(_userService.user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> saveUser(User user) async {
    state = const AsyncValue.loading();
    try {
      await _userService.saveUser(user);
      state = AsyncValue.data(_userService.user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signOut() async {
    await _userService.signOut();
    state = const AsyncValue.data(null);
  }

  Future<void> deleteUser() async {
    await _userService.deleteUser();
    state = const AsyncValue.data(null);
  }
}
