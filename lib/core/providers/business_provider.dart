import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventura/core/models/business/business.dart';
import 'package:ventura/core/models/user/user.dart';
import 'package:ventura/core/services/business/business_service.dart';

final businessProvider =
    AsyncNotifierProvider<BusinessAsyncNotifier, Business?>(
  () => BusinessAsyncNotifier(),
);

// Provider for the list of all businesses for the current user.
final userBusinessesProvider = Provider<List<Business>>((ref) {
  // By watching the main provider, this will rebuild when the active business changes,
  // which is a good proxy for when the underlying list might have changed.
  ref.watch(businessProvider);
  return BusinessService().userBusinesses;
});

// Derived providers for easy access to active business properties.
final activeBusinessProvider = Provider((ref) => ref.watch(businessProvider).value);
final activeBusinessIdProvider = Provider((ref) => ref.watch(activeBusinessProvider)?.id);
final activeBusinessNameProvider =
    Provider((ref) => ref.watch(activeBusinessProvider)?.name);

class BusinessAsyncNotifier extends AsyncNotifier<Business?> {
  final BusinessService _businessService = BusinessService();

  @override
  Future<Business?> build() async {
    await _businessService.loadActiveBusiness();
    return _businessService.currentBusiness;
  }

  Future<void> setActiveBusiness(Business business) async {
    state = const AsyncValue.loading();
    try {
      await _businessService.setActiveBusiness(business);
      state = AsyncValue.data(_businessService.currentBusiness);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<List<Business>> syncBusinesses(User user) async {
    state = const AsyncValue.loading();
    try {
      final businesses = await _businessService.syncUserBusinesses(user);
      state = AsyncValue.data(_businessService.currentBusiness);
      return businesses;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return [];
    }
  }
}
