import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class HiveService{
  Future<void> init()async{
    var directory = await getApplicationCacheDirectory();
    var path = '${directory.path}jerseyhub.db';

    Hive.init(path);
  }
}