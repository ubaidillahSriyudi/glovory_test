import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovory_test/presentation/profile_page.dart';
import 'package:glovory_test/presentation/providers/chart_provider.dart';
import 'package:intl/intl.dart';

class ChartPage extends ConsumerWidget {
  ChartPage({Key? key}) : super(key: key);
  final _formater = NumberFormat('#,###');
   
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _watchChart = ref.watch(chartProvider);
    if (_watchChart.value?.keys.isEmpty == true) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) { 
        Navigator.of(context).pop();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart', style: TextStyle(color: Colors.black)),
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
        actions: [
          TextButton(
            onPressed: () => ref.read(chartProvider.notifier).clearAll(), 
            child: const Text('Clear All')
          )
        ],
      ),
      body: ListView(
        children: _watchChart.value!.entries.map((e) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(e.value.imgUrl ?? '', fit: BoxFit.cover, scale: 2.0),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.value.name.toString()),
                          Text('Rp ${_formater.format(e.value.price)}')
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: () => ref.read(chartProvider.notifier).remove(e.key), icon: const Icon(Icons.delete)),
                      Row(
                        children: [
                          IconButton(onPressed: () => ref.read(chartProvider.notifier).add(e.value.productId ?? ''), icon: const Icon(Icons.add_box_outlined)),
                          Text(e.value.amount.toString()),
                          IconButton(onPressed: () => ref.read(chartProvider.notifier).subtract(e.value.productId ?? ''), icon: const Icon(Icons.indeterminate_check_box_outlined))
                        ],
                      )
                    ],
                  )
                ],
              ),
              const Divider()
            ],
          ),
        )).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent.shade200,
            fixedSize: const Size(400, 20)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Purchase Order'),
              Text('Rp ${_formater.format(ref.watch(chartProvider.notifier).totalPrice)}'),
            ],
          )
        ),
      ),
    );
  }
}