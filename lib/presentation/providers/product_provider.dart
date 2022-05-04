import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovory_test/data/local/product_local.dart';
import 'package:glovory_test/data/models/product_model.dart';
import 'package:glovory_test/data/remote/product_data_src.dart';

final productsProvider = StateNotifierProvider.autoDispose<ProductsNotifier, AsyncValue<List<Results>> >((ref) {
  return ProductsNotifier(ref); 
});

class ProductsNotifier extends StateNotifier<AsyncValue<List<Results>>> {
  ProductsNotifier(this._ref): super(const AsyncValue.data([])) {
   _productDataSources = _ref.watch(productDataSrcProvider);
  }

  late final ProductDataSources _productDataSources;
  final AutoDisposeStateNotifierProviderRef _ref; 
  
  Future<void> allProducts() async {
    state = const AsyncValue.loading();

    try {
      await InternetAddress.lookup('example.com');
      ProductsLocal().allProducts().then((value) async {
        if (value.isEmpty)  {
          final _res = await AsyncValue.guard(() async => _productDataSources.allProducts());
          await ProductsLocal().insertProducts(_res.value ?? ProductModel());
          var _allProductLocal = await ProductsLocal().allProducts();
          if (!mounted) return;
          state = AsyncValue.data(_allProductLocal);
        } else {
          state = AsyncValue.data(value);
        }
      });
    } on SocketException catch (e) {
      var _allProductLocal = await ProductsLocal().allProducts();
      print('_allProductLocal $_allProductLocal');
      state = AsyncValue.data(_allProductLocal);
    }
  }

  Future<void> pagination(int page) async {
    state = const AsyncValue.loading();

    try {
        await InternetAddress.lookup('example.com');
        final _res = await AsyncValue.guard(() async => _productDataSources.pagination(page));
        if (_res.value?.results != null) {
          await ProductsLocal().insertProducts(_res.value ?? ProductModel());
          var _allProductLocal = await ProductsLocal().allProducts();
          if (!mounted) return;
          state = AsyncValue.data(_allProductLocal);
        } else {
          var _allProductLocal = await ProductsLocal().allProducts();
          if (!mounted) return;
          state = AsyncValue.data(_allProductLocal);
        }
    } on SocketException catch (e) {
      var _allProductLocal = await ProductsLocal().allProducts();
      print('_allProductLocal $_allProductLocal');
      state = AsyncValue.data(_allProductLocal);
    }
  }

  Future<void> productsByCategory(String category) async {
    state = const AsyncValue.loading();
    if (!mounted) return;
    final _res = await ProductsLocal().getProductsByCategory(category);
    state = AsyncValue.data(_res);
  }
}