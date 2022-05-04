import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovory_test/core/error/data_not_found.dart';
import 'package:glovory_test/presentation/category_page.dart';
import 'package:glovory_test/presentation/chart_page.dart';
import 'package:glovory_test/presentation/components/product_card.dart';
import 'package:glovory_test/presentation/profile_page.dart';
import 'package:glovory_test/presentation/providers/chart_provider.dart';
import 'package:glovory_test/presentation/providers/connection_provider.dart';
import 'package:glovory_test/presentation/providers/product_provider.dart';
import 'package:glovory_test/presentation/search/search_page.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class AllProductsPage extends ConsumerStatefulWidget {
  const AllProductsPage(this.category, {Key? key}) : super(key: key);

  final String category;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends ConsumerState<AllProductsPage> {

  int _paging = 2;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
   final _formater = NumberFormat('#,###');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(connectionProvider.notifier).checkConnection();
      _checkConnection();
      _getData();
  }

  void _checkConnection(){
     WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final _watchCon = ref.watch(connectionProvider);
      if (_watchCon.value == false) {
        ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('App currently running in Offline Mode'))
        );
      }
    });
  }

  void _getData() {
    if (widget.category == 'All Products') {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        ref.read(productsProvider.notifier).allProducts();
      });
    } else {
       WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        ref.read(productsProvider.notifier).productsByCategory(widget.category);
      });
    }
  }

  void onRefreshLoading() async {
    print('onRefreshLoading fired');
    _paging ++;
    ref.read(productsProvider.notifier).pagination(_paging);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final _watch = ref.watch(productsProvider);
    final _watchChartProvider = ref.watch(chartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () => {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchPage()))
          }, icon: const Icon(Icons.search, color: Colors.black)),
          IconButton(onPressed: () => {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => CategoryPage(widget.category)))
          }, icon: const Icon(Icons.apps_sharp, color: Colors.black)),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfilePage())
            ), 
            // onPressed: () => ProductsLocal().allProducts(),
            icon: const Icon(Icons.person_outline_sharp, color: Colors.black)
          )
        ],
      ),
      body: _watch.when(
        data: (data) {
          if (data.isNotEmpty == true) {
            return SmartRefresher(
              controller: _refreshController,
              onLoading: onRefreshLoading,
              onRefresh: onRefreshLoading,
              enablePullUp: false,
              child: ListView(
                children: [
                  GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:  const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1.8 / 2,
                      crossAxisSpacing: 11,
                      mainAxisSpacing: 10
                    ), 
                    itemCount: data.length,
                    itemBuilder: (context, idx) => ProductCard(data, idx)
                  ),
                  const SizedBox(
                    height: 70,
                  )
                ],
              ),
            );
          } else if(data.isEmpty == true) {
            return const DataNotFound();
          }
          return Container();
        }, 
        error: (error, stack) {}, 
        loading: () => const Center(
          child: CircularProgressIndicator(),
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _watchChartProvider.value!.isNotEmpty
      ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
             Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChartPage() ));
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent.shade200,
            fixedSize: const Size(400, 20)
          ),
          child: Text('Buy ${_watchChartProvider.value!.length} item - Rp ${_formater.format(ref.watch(chartProvider.notifier).totalPrice)}')
        ),
      )
      : Container(),
    );
  }
}