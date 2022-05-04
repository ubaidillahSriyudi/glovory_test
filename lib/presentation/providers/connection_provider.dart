
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectionProvider = StateNotifierProvider<ConnectionNotifier, AsyncValue<bool?>>((ref) {
  return ConnectionNotifier();
});

class ConnectionNotifier extends StateNotifier<AsyncValue<bool?>> {
  ConnectionNotifier(): super(const AsyncValue.data(null));
  
  void checkConnection() async {
    try {
      final _res = await InternetAddress.lookup('example.com');
      state = AsyncValue.data(true);
    } on SocketException catch (e) {
    state = const AsyncValue.data(false);
    }
  }
}