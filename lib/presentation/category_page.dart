import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovory_test/presentation/all_products_page.dart';
import 'package:glovory_test/presentation/providers/categories_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CategoryPage extends ConsumerStatefulWidget {
  const CategoryPage(this.currentCategory, {Key? key}) : super(key: key);
  final String currentCategory;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(categoriesProvider.notifier).categories();
  }

  @override
  Widget build(BuildContext context) {
    final _watchCategories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading:  IconButton(onPressed: () => {
          Navigator.of(context).pop()
          // Navigator.of(context).pushAndRemoveUntil(
          //   MaterialPageRoute(builder: (_) => const AllProductsPage()
          // ), (route) => false)
        }, icon: const Icon(Icons.close, color: Colors.black)),
      ),
      body: _watchCategories.when(
          data: (data) {
            if (data?.isNotEmpty == true) {
              return ListView.separated(
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(15, 20),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                        primary: data?[idx].categoryName == widget.currentCategory ? Colors.red : Colors.grey
                      ),
                      onPressed: ()  {
                        // ref.read(productsProvider.notifier).productsByCategory(data?[idx].categoryName ?? '');
                        // Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => AllProductsPage(data?[idx].categoryName ?? '')
                          ), (route) => false
                        );
                        // print('object ${data.[idx].categoryName}')
                      },
                      child: Text('${data?[idx].categoryName}')
                    ),
                  );
                }, 
                separatorBuilder: (context, idx) => const Divider(), 
                itemCount: data!.length
              );
            }

            return Container();
          }, 
          error: (error, stack) { }, 
          loading: () => const Center(child: CircularProgressIndicator())
        )
    );
  }
}