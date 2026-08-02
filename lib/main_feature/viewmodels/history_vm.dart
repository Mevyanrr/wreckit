import 'package:flutter/material.dart';
import 'package:wreckit/main_feature/models/scanner_model.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';

class HistoryGroup {
  final String label;
  final List<ScanHistoryItem> items;
  const HistoryGroup({required this.label, required this.items});
}

class ScanHistoryViewModel extends ChangeNotifier {
  List<ScanHistoryItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ScanHistoryItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _items.isEmpty;

  //CONTOH DUMMY 
  void loadDummy() {
    final now = DateTime.now();

    _items = [
  // --- Hari Ini ---
  ScanHistoryItem(
    id: '1',
    imagePath: '',
    scannedAt: now.subtract(const Duration(hours: 1)),
    scanResult: ScanResultModel.bahaya(
      url: 'https://bit.ly/3xQ9mK',
    ),
  ),
  ScanHistoryItem(
    id: '2',
    imagePath: '',
    scannedAt: now.subtract(const Duration(hours: 3)),
    scanResult: ScanResultModel.aman(
      url: 'https://www.bca.co.id/produk/kartu-debit',
    ),
  ),
  ScanHistoryItem(
    id: '3',
    imagePath: '',
    scannedAt: now.subtract(const Duration(hours: 5)),
    scanResult: ScanResultModel.waspada(
      url: 'https://tokopedia.com/promo/flash-sale',
    ),
  ),

  // --- Kemarin ---
  ScanHistoryItem(
    id: '4',
    imagePath: '',
    scannedAt: now.subtract(const Duration(days: 1, hours: 2)),
    scanResult: ScanResultModel.waspada(
      url: 'https://free-rewards.claims/get-prize',
    ),
  ),
  ScanHistoryItem(
    id: '5',
    imagePath: '',
    scannedAt: now.subtract(const Duration(days: 1, hours: 6)),
    scanResult: ScanResultModel.aman(
      url: 'https://shopee.co.id/product/123456',
    ),
  ),
  ScanHistoryItem(
    id: '6',
    imagePath: '',
    scannedAt: now.subtract(const Duration(days: 1, hours: 10)),
    scanResult: ScanResultModel.bahaya(
      url: 'https://phishing-bank.xyz/login/verify',
    ),
  ),

  // --- 3 Hari Lalu ---
  ScanHistoryItem(
    id: '7',
    imagePath: '',
    scannedAt: now.subtract(const Duration(days: 3)),
    scanResult: ScanResultModel.aman(
      url: 'https://amazon.com/warehouse/deals',
    ),
  ),
  ScanHistoryItem(
    id: '8',
    imagePath: '',
    scannedAt: now.subtract(const Duration(days: 3, hours: 4)),
    scanResult: ScanResultModel.waspada(
      url: 'https://tinyurl.com/win-iphone15',
    ),
  ),

  // --- Tanggal Spesifik ---
  ScanHistoryItem(
    id: '9',
    imagePath: '',
    scannedAt: DateTime(2024, 11, 14, 9, 30),
    scanResult: ScanResultModel.aman(
      url: 'https://grab.com/id/promo/voucher',
    ),
  ),
  ScanHistoryItem(
    id: '10',
    imagePath: '',
    scannedAt: DateTime(2024, 11, 14, 15, 45),
    scanResult: ScanResultModel.bahaya(
      url: 'https://secure-gateway.link/redirect?id=8f3a',
    ),
  ),
];
    notifyListeners();
  }

  Future<void> loadHistory(List<ScanHistoryItem> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = List<ScanHistoryItem>.from(data)
        ..sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    } catch (e) {
      _errorMessage = 'Gagal memuat riwayat: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addItem(ScanHistoryItem item) {
    _items = [item, ..._items];
    notifyListeners();
  }

  void removeItem(String id) {
    _items = _items.where((e) => e.id != id).toList();
    notifyListeners();
  }

  List<HistoryGroup> get groupedHistory {
    if (_items.isEmpty) return [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final Map<String, List<ScanHistoryItem>> buckets = {};

    for (final item in _items) {
      final d = DateTime(
        item.scannedAt.year,
        item.scannedAt.month,
        item.scannedAt.day,
      );
      String label;
      if (d == today) {
        label = 'HARI INI';
      } else if (d == yesterday) {
        label = 'KEMARIN';
      } else {
        label = _formatDate(d);
      }
      buckets.putIfAbsent(label, () => []).add(item);
    }

    return buckets.entries
        .map((e) => HistoryGroup(label: e.key, items: e.value))
        .toList();
  }

  static String _formatDate(DateTime d) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    return '${months[d.month - 1]} ${d.day.toString().padLeft(2, '0')}, ${d.year}';
  }
}