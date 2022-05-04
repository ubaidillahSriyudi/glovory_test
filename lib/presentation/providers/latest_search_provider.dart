import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovory_test/data/local/latest_search_local.dart';
import 'package:glovory_test/data/models/product_model.dart';
import 'package:glovory_test/data/models/search_res_model.dart';
import 'package:glovory_test/data/remote/product_data_src.dart';

final searchProductProvider = StateNotifierProvider.autoDispose<SearchProductsNotifier, AsyncValue<ProductModel> >((ref) {
  return SearchProductsNotifier(ref); 
});

class SearchProductsNotifier extends StateNotifier<AsyncValue<ProductModel>> {
  SearchProductsNotifier(this._ref): super(AsyncValue.data(ProductModel())) {
   _productDataSources = _ref.watch(productDataSrcProvider);
  }

  late final ProductDataSources _productDataSources;
  final AutoDisposeStateNotifierProviderRef _ref; 
  
  Future<void> searchProduct(String nameProduct) async {
    LatestSearch().insertKeyword(nameProduct);
    state = const AsyncValue.loading();
    final _res = await AsyncValue.guard(() async => _productDataSources.search(nameProduct));
    if (!mounted) return;
    state = AsyncValue.data(_res.asData?.value ?? ProductModel());
    // print('searchProduct $state');
  }
}