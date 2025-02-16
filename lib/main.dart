import 'package:color_code_gen/presentation/controller/theme_controller.dart';
import 'package:color_code_gen/presentation/ui/color_picker.dart';
import 'package:color_code_gen/presentation/ui/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // 向き指定
  WidgetsFlutterBinding.ensureInitialized();
  // AdMob 用のプラグイン初期化
  // Admob.initialize();
  //MobileAds.instance.initialize();
  // // Workmanagerの初期化
  // Workmanager().initialize(callbackDispatcher(), isInDebugMode: kDebugMode);
  SystemChrome.setPreferredOrientations([
    // 縦固定
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CircleColorPickerController();
    return Consumer(
      builder: (context, ref, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // colorScheme: _controller.color,
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: controller.color,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: ref.watch(themeController).mode,
          debugShowCheckedModeBanner: false, // ← シミュレータのdebugバーを非表示にする
          home: const HomePage(),
        );
      },
    );
  }
}
