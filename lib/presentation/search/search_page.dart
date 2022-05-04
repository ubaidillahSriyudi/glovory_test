import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovory_test/core/error/data_not_found.dart';
import 'package:glovory_test/data/models/product_model.dart';
import 'package:glovory_test/presentation/chart_page.dart';
import 'package:glovory_test/presentation/components/product_card.dart';
import 'package:glovory_test/presentation/providers/chart_provider.dart';
import 'package:glovory_test/presentation/providers/search_provider.dart';
import 'package:intl/intl.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
   final _formater = NumberFormat('#,###');
  static const List<String> popularSearch = [
    'Chess',
    'Gundam Action Figure'
  ];

  @override
  void initState() {
    // TODO: implement initState
    ref.read(keywordsProvider.notifier).latestSearch();
  }

  @override
  Widget build(BuildContext context) {
    final _watchSearch = ref.watch(searchProductProvider);
    final _watchKeywords = ref.watch(keywordsProvider);
    final _watchChartProvider = ref.watch(chartProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey,),
            const SizedBox(width: 10),
            // Text('data', style: TextStyle(color: Colors.black),),
            SizedBox(
              width: 250,
              child: TextFormField(
                textInputAction: TextInputAction.go,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Products',
                  hintStyle: TextStyle(
                    color: Colors.grey
                  )
                ),
                onFieldSubmitted: (val) => ref.read(searchProductProvider.notifier).querySearchProduct(val),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () { 
            Navigator.of(context).pop();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
      body: _watchSearch.when(
        data: (data){
          if (data?.isNotEmpty == true) {
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:  const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1.8 / 2,
                crossAxisSpacing: 11,
                mainAxisSpacing: 10
              ), 
              itemCount: _watchSearch.value?.length,
              itemBuilder: (context, idx) => ProductCard(data ?? <Results>[], idx),
              // itemBuilder: (context, idx) => Container()
            );
          } else if(data?.isEmpty == true) {
            return const DataNotFound();
          } else if(data == null) {
            return ListView(
              children: [
                  if (_watchKeywords.value?.isNotEmpty == true) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text('Latest Search', style: TextStyle(fontSize: 20),),
                        ),
                        ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, idx) {
                            return TextButton(
                                style:  TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(10, 20),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.centerLeft
                                ),
                                onPressed: () => ref.read(searchProductProvider.notifier).querySearchProduct(_watchKeywords.value?[idx] ?? ''), 
                                child: Text('${_watchKeywords.value?[idx]}')
                              );
                          }, 
                          separatorBuilder: (context, idx) => const Divider(), 
                          itemCount: _watchKeywords.value?.length ?? 0
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const Text('Popular Search'),
                      ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          Wrap(
                            spacing: 3,
                            direction: Axis.horizontal,
                            children: _buildCategoryChip(popularSearch)!
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        }, 
        error: (error, stack) {}, 
        loading: () => const Center(child: CircularProgressIndicator(),)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ((){
        if (_watchSearch.value?.isEmpty == true) {
          return Container();
        } else if(_watchSearch.value?.isNotEmpty == true && _watchChartProvider.value!.isNotEmpty ) {
          return ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChartPage() ));
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent.shade200,
              fixedSize: const Size(400, 20)
            ),
            child: Text('Buy ${_watchChartProvider.value!.length} item - Rp ${_formater.format(ref.watch(chartProvider.notifier).totalPrice)}')
          );
        } else if(_watchChartProvider.value!.isNotEmpty || _watchKeywords.value?.isNotEmpty == true) {
          return ElevatedButton(
            onPressed: () => ref.read(keywordsProvider.notifier).clearKeywords(), 
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 0,
            ),
            child: const Text('Clear Search History', style: TextStyle(color: Colors.black),)
          );
        }
      }())
    );
  }

  List<Widget>? _buildCategoryChip(List<String> categories) {
    List<Widget> chips = [];
    for (int i = 0; i < categories.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 3, right: 3),
        child: ChoiceChip(
          label: Text(categories[i]),
          selected: true,
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF1993AB), width: 1),
          selectedColor: const Color(0xFF1993AB).withOpacity(0.1),
          onSelected: (value) => ref.read(searchProductProvider.notifier).querySearchProduct(categories[i]),
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}