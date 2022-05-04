import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glovory_test/data/models/chart_model.dart';

final chartProvider = StateNotifierProvider<ChartNotifier, AsyncValue<Map<String, ChartModel>>>((ref) {
  return ChartNotifier(ref);
});

class ChartNotifier extends StateNotifier<AsyncValue<Map<String, ChartModel>>> {
  ChartNotifier(this._ref): super(const AsyncValue.data({}));
   final StateNotifierProviderRef _ref;

  Map<String, ChartModel> listChart = <String, ChartModel>{};
  int totalPrice = 0;

  void initChart(ChartModel model) {
    listChart.putIfAbsent(model.productId.toString(), () => model);
    _countsTotalPrice('+', listChart[model.productId]?.price ?? 0);
    state = AsyncValue.data(listChart);
  }

  void add(String productId) {
    int _amount = listChart[productId]?.amount ?? 0;
    _amount ++;
    listChart.update(productId, (value) => ChartModel(
      productId: listChart[productId]?.productId,
      name: listChart[productId]?.name,
      imgUrl: listChart[productId]?.imgUrl,
      price: listChart[productId]?.price,
      amount: _amount,
    ));
    _countsTotalPrice('+', listChart[productId]?.price ?? 0);
    state = AsyncValue.data(listChart);
  }

  void subtract(String productId) {
    int _amount = listChart[productId]?.amount ?? 0;
    _amount --;
    _countsTotalPrice('-', listChart[productId]?.price ?? 0);
    if (_amount == 0) {
      listChart.remove(productId);
    } else {
      listChart.update(productId, (value) => ChartModel(
         productId: listChart[productId]?.productId,
        name: listChart[productId]?.name,
        imgUrl: listChart[productId]?.imgUrl,
        price: listChart[productId]?.price,
        amount: _amount
      ));
    }
    state = AsyncValue.data(listChart);
  }

  void remove(String productId) {
    listChart.remove(productId);
    state = AsyncValue.data(listChart);
  }

  void clearAll() {
    listChart.clear();
    state = AsyncValue.data(listChart);
  }

  void _countsTotalPrice(String operation, int price) {
    if (operation == '+') {
      totalPrice = totalPrice + price;
    } else if (operation == '-') {
      totalPrice = totalPrice - price;
    }
  }
}