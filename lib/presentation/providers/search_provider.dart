import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovory_test/data/local/latest_search_local.dart';
import 'package:glovory_test/data/local/product_local.dart';
import 'package:glovory_test/data/models/product_model.dart';
import 'package:glovory_test/data/remote/product_data_src.dart';

final searchProductProvider = StateNotifierProvider.autoDispose<SearchProductsNotifier, AsyncValue<List<Results>?> >((ref) {
  return SearchProductsNotifier(ref); 
});

final keywordsProvider = StateNotifierProvider<LatestSearchNotifier, AsyncValue<List<String>> >((ref) {
  return LatestSearchNotifier(); 
});

class SearchProductsNotifier extends StateNotifier<AsyncValue<List<Results>?>> { ///_____ searchProductProvider
  SearchProductsNotifier(this._ref): super(const AsyncValue.data(null)) {
   _productDataSources = _ref.watch(productDataSrcProvider);
  }

  late final ProductDataSources _productDataSources;
  final AutoDisposeStateNotifierProviderRef _ref; 
  
  Future<void> searchProduct(String nameProduct) async {
    LatestSearch().insertKeyword(nameProduct);
    state = const AsyncValue.loading();
    final _res = await AsyncValue.guard(() async => _productDataSources.search(nameProduct));
    if (!mounted) return;
    // state = AsyncValue.data(_res.asData?.value ?? ProductModel());
  }

  Future<void> querySearchProduct(String nameProduct) async {
    LatestSearch().insertKeyword(nameProduct);
    state = const AsyncValue.loading();
    final _res = await ProductsLocal().search(nameProduct);
    if (!mounted) return;
    state = AsyncValue.data(_res);
  }
}

class LatestSearchNotifier extends StateNotifier<AsyncValue<List<String>>> { ///_____ keywordsProvider
  LatestSearchNotifier(): super(const AsyncValue.data([]));

  
  Future<void> latestSearch() async {
    final _keywords = await LatestSearch().getKeywords();
    state = const AsyncValue.loading();
    if (!mounted) return;
    state = AsyncValue.data(_keywords);
  }

  Future<void> clearKeywords() async {
    LatestSearch().clearKeywords();
    final _keywords = await LatestSearch().getKeywords();
    state = const AsyncValue.loading();
    if (!mounted) return;
    state = AsyncValue.data(_keywords);
  }
}