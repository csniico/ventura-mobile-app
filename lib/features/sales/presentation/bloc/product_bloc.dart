import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/features/sales/data/models/product_model.dart';
import 'package:ventura/features/sales/domain/entities/product_entity.dart';
import 'package:ventura/features/sales/domain/use_cases/create_product.dart';
import 'package:ventura/features/sales/domain/use_cases/delete_product.dart';
import 'package:ventura/features/sales/domain/use_cases/get_product_by_id.dart';
import 'package:ventura/features/sales/domain/use_cases/search_resources.dart';
import 'package:ventura/features/sales/domain/use_cases/update_product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final SearchResources _searchResources;
  final GetProductById _getProductById;
  final CreateProduct _createProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;

  ProductBloc({
    required SearchResources searchResources,
    required GetProductById getProductById,
    required CreateProduct createProduct,
    required UpdateProduct updateProduct,
    required DeleteProduct deleteProduct,
  }) : _searchResources = searchResources,
       _getProductById = getProductById,
       _createProduct = createProduct,
       _updateProduct = updateProduct,
       _deleteProduct = deleteProduct,
       super(ProductInitial()) {
    on<ProductEvent>((event, emit) => emit(ProductLoadingState()));
    on<ProductSearchEvent>(_onProductSearchEvent);
    on<ProductGetByIdEvent>(_onProductGetByIdEvent);
    on<ProductCreateEvent>(_onProductCreateEvent);
    on<ProductUpdateEvent>(_onProductUpdateEvent);
    on<ProductDeleteEvent>(_onProductDeleteEvent);
  }

  void _onProductSearchEvent(
    ProductSearchEvent event,
    Emitter<ProductState> emit,
  ) async {
    final res = await _searchResources(
      SearchResourcesParams(
        businessId: event.businessId,
        searchQuery: event.searchQuery,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        minQty: event.minQty,
        page: event.page,
        limit: event.limit,
      ),
    );

    res.fold((failure) => emit(ProductErrorState(message: failure.message)), (
      searchResult,
    ) {
      final products = (searchResult['products'] as List<dynamic>)
          .map(
            (productJson) =>
                ProductModel.fromJson(productJson as Map<String, dynamic>),
          )
          .toList();
      emit(ProductSearchResultState(products: products));
    });
  }

  void _onProductGetByIdEvent(
    ProductGetByIdEvent event,
    Emitter<ProductState> emit,
  ) async {
    final res = await _getProductById(
      GetProductByIdParams(
        productId: event.productId,
        businessId: event.businessId,
      ),
    );

    res.fold(
      (failure) => emit(ProductErrorState(message: failure.message)),
      (product) => emit(ProductLoadedState(product: product)),
    );
  }

  void _onProductCreateEvent(
    ProductCreateEvent event,
    Emitter<ProductState> emit,
  ) async {
    final res = await _createProduct(
      CreateProductParams(
        businessId: event.businessId,
        name: event.name,
        price: event.price,
        availableQuantity: event.availableQuantity,
        primaryImage: event.primaryImage,
        supportingImages: event.supportingImages,
        description: event.description,
        notes: event.notes,
      ),
    );

    res.fold(
      (failure) => emit(ProductErrorState(message: failure.message)),
      (product) => emit(ProductCreateSuccessState(product: product)),
    );
  }

  void _onProductUpdateEvent(
    ProductUpdateEvent event,
    Emitter<ProductState> emit,
  ) async {
    final res = await _updateProduct(
      UpdateProductParams(
        productId: event.productId,
        businessId: event.businessId,
        name: event.name,
        price: event.price,
        availableQuantity: event.availableQuantity,
        primaryImage: event.primaryImage,
        supportingImages: event.supportingImages,
        description: event.description,
        notes: event.notes,
      ),
    );

    res.fold(
      (failure) => emit(ProductErrorState(message: failure.message)),
      (product) => emit(ProductUpdateSuccessState(product: product)),
    );
  }

  void _onProductDeleteEvent(
    ProductDeleteEvent event,
    Emitter<ProductState> emit,
  ) async {
    final res = await _deleteProduct(
      DeleteProductParams(
        productId: event.productId,
        businessId: event.businessId,
      ),
    );

    res.fold(
      (failure) => emit(ProductErrorState(message: failure.message)),
      (message) => emit(ProductDeleteSuccessState(message: message)),
    );
  }
}
