import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovory_test/data/models/chart_model.dart';
import 'package:glovory_test/data/models/product_model.dart';
import 'package:glovory_test/presentation/providers/chart_provider.dart';
import 'package:intl/intl.dart';



class ProductCard extends ConsumerWidget {
  ProductCard(this.results, this._idx, {Key? key}) : super(key: key);

  final List<Results> results;
  final int _idx;
  final _formater = NumberFormat('#,###');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _watchChartProviderVal = ref.watch(chartProvider);

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: results[_idx].productImgSm ?? '',
                width: 80,
                height: 80,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              // child: Image(
              //   image: NetworkImageWithRetry(results[_idx].productImgSm ?? '', scale: 1.8),
              // ),
              // child: Image.network(results?[_idx].productImgSm ?? '', fit: BoxFit.fill, scale: 1.8),
            ),
          ),
          const Spacer(),
          const SizedBox(height: 10),
          Text('${results[_idx].productName}', textAlign: TextAlign.left,),
          const SizedBox(height: 10),
          Text('Rp ${_formater.format(int.parse(results[_idx].productPrice?.substring(0, results[_idx].productPrice?.indexOf('.')) ?? ''))}', textAlign: TextAlign.left, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 5),
          if ( _watchChartProviderVal.value?.keys.contains( results[_idx].id.toString()) == false ) ...[
            ElevatedButton(
              onPressed: () => ref.read(chartProvider.notifier).initChart(ChartModel(
                productId: results[_idx].id.toString(),
                amount: 1,
                imgUrl: results[_idx].productImgSm,
                name: results[_idx].productName,
                price: int.parse(results[_idx].productPrice?.substring(0, results[_idx].productPrice?.indexOf('.')) ?? '')
              )), 
              child:  const Text('Add to Chart', style: TextStyle(color: Colors.red)),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                fixedSize: const Size(150, 5),
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(11),
                )
              ),
            )
          ] else if(_watchChartProviderVal.value?.keys.contains( results[_idx].id.toString()) == true  ) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // ref.read(chartProvider( ChartModel(amount: 1) ));
                    ref.read(chartProvider.notifier).add( results[_idx].id.toString());
                  }, 
                  child: const Text('+', style: TextStyle(color: Colors.red)),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    // fixedSize: const Size(150, 5),
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(11),
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${_watchChartProviderVal.value?[results[_idx].id.toString()]?.amount }', style: const TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // ref.read(chartProvider( ChartModel(amount: 1) ));
                    ref.read(chartProvider.notifier).subtract( results[_idx].id.toString());
                  }, 
                  child: const Text('-', style: TextStyle(color: Colors.red)),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    // fixedSize: const Size(150, 5),
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(11),
                    )
                  ),
                ),
              ],
            )
          ],
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}