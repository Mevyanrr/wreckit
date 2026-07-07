import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../services/history_item.dart';

class DbService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HistoryItemSchema],
      directory: dir.path,
    );
  }
}