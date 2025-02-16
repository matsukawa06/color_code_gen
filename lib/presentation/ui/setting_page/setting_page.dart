import 'package:color_code_gen/common/common_const.dart';
import 'package:color_code_gen/presentation/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

///
/// settingページ
///
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageTitle = TabItem.setting.title;
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: body(),
    );
  }

  Widget body() {
    Future<PackageInfo> getPackageInfo() {
      return PackageInfo.fromPlatform();
    }

    return Container(
      padding: const EdgeInsets.all(28),
      child: Consumer(builder: (context, ref, _) {
        return FutureBuilder<PackageInfo>(
          future: getPackageInfo(),
          builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
            if (snapshot.hasError) {
              return const Text('ERROR');
            } else if (!snapshot.hasData) {
              return const Text('Loading...');
            }
            // final data = snapshot.data!;
            return Column(
              children: [
                // App設定
                _appSettings(context, ref),
              ],
            );
          },
        );
      }),
    );
  }

  //----------------------------
  // App設定
  //----------------------------
  Widget _appSettings(BuildContext context, WidgetRef ref) {
    final myTheme = ref.watch(themeController);
    return Card(
      elevation: 5,
      child: Column(
        children: [
          // ダークモード選択エリア
          SwitchListTile(
            value: myTheme.isDark,
            title: const Text('ダークモード'),
            onChanged: (bool value) {
              myTheme.brightnessToggle();
            },
          )
        ],
      ),
    );
  }
}
