import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initTestHive() async {
  const MethodChannel('plugins.flutter.io/path_provider')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      return '.';
    }
    return null;
  });

  await Hive.initFlutter();
  await Hive.openBox('usersBox');
}

Future<void> clearTestHive() async {
  final box = Hive.box('usersBox');
  await box.clear();
}
