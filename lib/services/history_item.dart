import 'package:isar_community/isar.dart';

part 'history_item.g.dart';

@collection
class HistoryItem {
  Id id = Isar.autoIncrement;

  late String title;
  late String description;
  late DateTime timestamp;
}