part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoadingState extends ProductState {}

final class ProductSearchResultState extends ProductState {
  final List<Product> products;

  ProductSearchResultState({required this.products});
}

final class ProductLoadedState extends ProductState {
  final Product product;

  ProductLoadedState({required this.product});
}

final class ProductCreateSuccessState extends ProductState {
  final Product product;

  ProductCreateSuccessState({required this.product});
}

final class ProductUpdateSuccessState extends ProductState {
  final Product product;

  ProductUpdateSuccessState({required this.product});
}

final class ProductDeleteSuccessState extends ProductState {
  final String message;

  ProductDeleteSuccessState({required this.message});
}

final class ProductErrorState extends ProductState {
  final String message;

  ProductErrorState({required this.message});
}
