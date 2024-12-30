import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLifecycleNotifier extends StateNotifier<AppLifecycleState> with WidgetsBindingObserver {
  AppLifecycleNotifier() : super(AppLifecycleState.resumed) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    state = state;
    super.state = state;
  }
}

final appLifecycleProvider = StateNotifierProvider<AppLifecycleNotifier, AppLifecycleState>(
  (ref) => AppLifecycleNotifier(),
);
