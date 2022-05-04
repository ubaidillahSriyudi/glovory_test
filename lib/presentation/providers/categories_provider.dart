import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovory_test/data/local/categories_local.dart';
import 'package:glovory_test/data/models/category_model.dart';
import 'package:glovory_test/data/remote/product_data_src.dart';

final categoriesProvider = StateNotifierProvider.autoDispose<CategoriesNotifier, AsyncValue<List<Results>?>>((ref) {
  return CategoriesNotifier(ref); 
});

class CategoriesNotifier extends StateNotifier<AsyncValue<List<Results>?> > {
  CategoriesNotifier(this._ref): super(const AsyncValue.data(null)) {
   _productDataSources = _ref.watch(productDataSrcProvider);
  }

  late final ProductDataSources _productDataSources;
  final AutoDisposeStateNotifierProviderRef _ref; 
  
  Future<void> categories() async {
    state = const AsyncValue.loading();
    
    CategoriesLocal().allCategories().then((value) async {
      // print('categories $value');
      if (value.isEmpty) {
        final _res = await AsyncValue.guard(() async => _productDataSources.categories());
        await CategoriesLocal().insertCategories(_res.value ?? CategoryModel());
        final _allCategoriesLocal = await CategoriesLocal().allCategories();
        if (!mounted) return;
        state = AsyncValue.data(_allCategoriesLocal);
      } else {
        if (!mounted) return;
        state = AsyncValue.data(value);
      }
    });
  }
}