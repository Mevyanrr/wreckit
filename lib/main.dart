import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/main_feature/viewmodels/main_vm.dart';
import 'package:wreckit/main_feature/views/scanner_page.dart';
import 'package:wreckit/scan_result/viewmodels/scanresult_vm.dart';
import 'package:wreckit/scan_result/views/block_reported.dart'; 
import 'package:wreckit/scan_result/views/scanresult_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ScannerViewModel>(
          create: (_) => ScannerViewModel(),
        ),
        ChangeNotifierProvider<ScanResultViewModel>(
          create: (_) => ScanResultViewModel(),
        ),
        ChangeNotifierProvider<BlockReportedViewModel>(
          create: (_) => BlockReportedViewModel(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Wreckit',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              // scaffoldBackgroundColor: Appcolors.primaryColor,
            ),
            initialRoute: '/block_reported', 
            routes: {
              '/scanner': (context) => const ScannerPage(),
              '/scan_result': (context) => const ScanResultPage(),
              '/block_reported': (context) => const BlockReportedPage(),
            },
          );
        },
      ),
    );
  }
}