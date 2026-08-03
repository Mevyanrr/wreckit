import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wreckit/main_feature/viewmodels/history_vm.dart';
import 'package:wreckit/main_feature/viewmodels/scanner_vm.dart';
import 'package:wreckit/main_feature/views/history_page.dart';
import 'package:wreckit/main_feature/views/scanner_page.dart';
import 'package:wreckit/scan_result/models/scanresult_model.dart';
import 'package:wreckit/scan_result/viewmodels/scanresult_vm.dart';
import 'package:wreckit/splash_onboarding/view/onboarding1.dart';
import 'package:wreckit/splash_onboarding/view/onboarding2.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ScannerViewModel>(
          create: (_) => ScannerViewModel(),
        ),
        ChangeNotifierProvider<ScanResultViewModel>(
          create: (_) => ScanResultViewModel(
            ScanResultModel.waspada(url: ''),
          ),
        ),
        ChangeNotifierProvider<ScanHistoryViewModel>(
          create: (_) => ScanHistoryViewModel(),
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
            ),
            initialRoute: '/onboarding1',
            routes: {
              '/onboarding1': (context) => const Onboarding1(),
              '/onboarding2': (context) => const Onboarding2(),
              '/scanner': (context) => const ScannerPage(),
              '/history': (context) => const ScanHistoryPage(),
            },
          );
        },
      ),
    );
  }
}