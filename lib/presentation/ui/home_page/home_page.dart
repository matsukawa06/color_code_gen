import 'dart:math';

import 'package:color_code_gen/common/common_const.dart';
import 'package:color_code_gen/presentation/controller/color_controller.dart';
import 'package:color_code_gen/presentation/ui/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _currentColor = Colors.blue;
  final _controller = CircleColorPickerController(
    initialColor: Colors.blue,
  );
  // ScrollControllerを初期化
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _currentColor,
          title: const Text('カラー検索'),
        ),
        body: Stack(
          children: [
            // メインコンテンツ
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 2),
                  // カラーコード指定
                  colorCode(),
                  const SizedBox(height: 2),
                  // 色直接指定
                  colorDirect(),
                  const SizedBox(height: 12),
                  // 色円指定
                  Stack(
                    children: [
                      // お気に入りボタン
                      favaritIcon(),
                      // 色円指定
                      Center(
                        child: CircleColorPicker(
                          controller: _controller,
                          onChanged: (color) {
                            setState(() => _currentColor = color);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  // 配色表示
                  colorScheme(),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '検索',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'お気に入り',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '設定',
            )
          ],
        ),
      ),
    );
  }

  // お気に入りボタン
  Widget favaritIcon() {
    return Consumer(
      builder: (context, ref, _) {
        final colorCon = ref.watch(colorController);
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              children: [
                const Text(
                  'お気に入り',
                  style: TextStyle(fontSize: 12),
                ),
                IconButton(
                  onPressed: () {
                    colorCon.changeFavorit();
                  },
                  isSelected: colorCon.isFavorit,
                  selectedIcon: const Icon(Icons.favorite),
                  icon: const Icon(Icons.favorite_border),
                  iconSize: 40,
                  color: Colors.red,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //----------------------------------------------------
  // メモリリークを防ぐため、ScrollControllerを破棄する
  //----------------------------------------------------
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //
  // カラーコード指定
  //
  Widget colorCode() {
    return Consumer(
      builder: (context, ref, _) {
        final colorCon = ref.watch(colorController);
        return Card(
          child: Padding(
            padding: const EdgeInsets.only(top: 1, bottom: 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                // カラー指定タイプを選択するためのプルダウンリスト
                DropdownButton(
                  items: [
                    DropdownMenuItem(
                      value: ColorCodeType.hex.name,
                      child: const Text('HEX'),
                    ),
                    DropdownMenuItem(
                      value: ColorCodeType.rgb.name,
                      child: const Text('RGB'),
                    ),
                  ],
                  value: colorCon.colorCodeTypeSelected,
                  onChanged: (colorType) {
                    setState(() => colorCon.changeColorCodeType(colorType as String));
                  },
                ),
                const SizedBox(width: 20),
                Visibility(
                  visible: colorCon.colorCodeTypeSelected == ColorCodeType.hex.name,
                  child: Row(
                    children: [
                      const Text('#', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      textBox_16(),
                    ],
                  ),
                ),
                Visibility(
                  visible: colorCon.colorCodeTypeSelected == ColorCodeType.rgb.name,
                  child: Row(
                    children: [
                      textBoxRgb(_controller.textR, RGBType.r),
                      const SizedBox(width: 8),
                      textBoxRgb(_controller.textG, RGBType.g),
                      const SizedBox(width: 8),
                      textBoxRgb(_controller.textB, RGBType.b),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // RGBのテキストボックス
  SizedBox textBoxRgb(TextEditingController text, RGBType rgbType) {
    return SizedBox(
      width: 70,
      height: 30,
      child: TextFormField(
        controller: text,
        enableInteractiveSelection: true,
        enabled: true,
        obscureText: false,
        maxLength: 3,
        maxLines: 1,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          filled: false,
          counterText: '',
          contentPadding: EdgeInsets.only(left: 12),
        ),
        style: const TextStyle(
          fontSize: 14,
        ),
        onChanged: (e) {
          _controller.onChangedTextRGB(e, rgbType);
        },
      ),
    );
  }

  // 16進数のテキストボックス
  SizedBox textBox_16() {
    return SizedBox(
      width: 110,
      height: 30,
      child: TextFormField(
        controller: _controller.text_16,
        enableInteractiveSelection: true, // コピペ有効
        enabled: true,
        obscureText: false,
        maxLength: 6,
        maxLines: 1,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          filled: false, // 背景色を表示しない
          counterText: '', // 右下のカウンターを非表示
          contentPadding: EdgeInsets.only(left: 12),
        ),
        style: const TextStyle(
          fontSize: 14,
        ),
        onChanged: (e) {
          _controller.onChangedText16(e);
        },
      ),
    );
  }

  //
  // 色直接指定
  //
  SizedBox colorDirect() {
    return SizedBox(
      width: 320,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: Wrap(
            spacing: 9,
            runSpacing: 6,
            children: [
              colorContainer(Colors.pink),
              colorContainer(Colors.red),
              colorContainer(Colors.deepOrange),
              colorContainer(Colors.orange),
              colorContainer(Colors.yellow),
              colorContainer(Colors.lime),
              colorContainer(Colors.lightGreen),
              colorContainer(Colors.green),
              colorContainer(Colors.teal),
              colorContainer(Colors.cyan),
              colorContainer(Colors.lightBlue),
              colorContainer(Colors.blue),
              colorContainer(Colors.indigo),
              colorContainer(Colors.purple),
            ],
          ),
        ),
      ),
    );
  }

  // 色直接指定用のContainer
  Widget colorContainer(MaterialColor pColor) {
    return GestureDetector(
      onTap: () => _controller.color = pColor,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(color: pColor),
      ),
    );
  }

  // 配色表示
  Widget colorScheme() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Table(
        border: TableBorder.all(color: Colors.orange),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(1.9), // 1列目の幅
          1: FlexColumnWidth(3.1), // 2列目の幅
          2: FlexColumnWidth(1.9), // 3列目の幅
          3: FlexColumnWidth(3.1), // 4列目の幅
        },
        children: <TableRow>[
          commonTableRow('反転色', ColorSchemeType.hanten, '補色', ColorSchemeType.hoshoku),
          commonTableRow('トライアド', ColorSchemeType.triad, 'スプコン', ColorSchemeType.split),
          commonTableRow('類似色', ColorSchemeType.ruiji, 'H.T.S', ColorSchemeType.hueTint),
        ],
      ),
    );
  }

  // 配色Container同士のスペースサイズ
  double schemContainerSpaceWidth = 5;

  // 配色の行部分
  TableRow commonTableRow(
      String name1, ColorSchemeType type1, String name2, ColorSchemeType type2) {
    return TableRow(
      children: <Widget>[
        // 配色のタイトル１
        schemeTitle(type1, name1),
        // 実際の配色を表示する部分
        schemeColor(type1),
        // 配色のタイトル2
        schemeTitle(type2, name2),
        // 実際の配色を表示する部分
        schemeColor(type2),
      ],
    );
  }

  // 配色のタイトル部分
  Align schemeTitle(ColorSchemeType type1, String name1) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          // 配色のタイプの説明ダイアログを表示
          colorSchemTypeExplanation(type1);
        },
        child: Text(
          name1,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
        ),
      ),
    );
  }

  // 実際の配色を表示する部分
  Widget schemeColor(ColorSchemeType type1) {
    return SizedBox(
      height: 48,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Row(
            children: [
              // 選択中の色
              colorSchemContainer(_controller.color),
              SizedBox(width: schemContainerSpaceWidth),
              // 選択中の色に対する配色
              colorSchemRow(type1),
            ],
          ),
        ),
      ),
    );
  }

  // 配色用の共通Container
  Container colorSchemContainer(Color pColor) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(color: pColor),
    );
  }

/*
  // 配色表示
  Widget colorScheme() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Table(
        border: TableBorder.all(color: Colors.orange),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(4), // 1列目の幅
          1: FlexColumnWidth(6), // 2列目の幅
        },
        children: <TableRow>[
          commonTableRow('反転色', ColorSchemType.hanten),
          commonTableRow('補色', ColorSchemType.hoshoku),
          commonTableRow('トライアド', ColorSchemType.triad),
          commonTableRow('スプリット・コンプリメンタリ', ColorSchemType.split),
          commonTableRow('類似色', ColorSchemType.ruiji),
          commonTableRow('ヒュー・チント・シェード', ColorSchemType.hueTint),
        ],
      ),
    );
  }

  // 配色Container同士のスペースサイズ
  double schemContainerSpaceWidth = 15;

  // 配色の行部分
  TableRow commonTableRow(String name, ColorSchemType type) {
    return TableRow(
      children: <Widget>[
        SizedBox(
          height: 100,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                // 配色のタイプの説明ダイアログを表示
                colorSchemTypeExplanation(type);
              },
              child: Text(
                name,
                style: const TextStyle(
                  // fontSize: 20,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
              ),
            ),
          ),
        ),
        // 実際の配色を表示する部分
        SizedBox(
          height: 100,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  // 選択中の色
                  colorSchemContainer(_controller.color),
                  SizedBox(width: schemContainerSpaceWidth),
                  // 選択中の色に対する配色
                  colorSchemRow(type),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
*/
  // 配色のタイプの説明ダイアログを表示
  Future<dynamic> colorSchemTypeExplanation(ColorSchemeType type) {
    String title = '';
    String content = '';
    switch (type) {
      case ColorSchemeType.hanten:
        title = '反転色';
        break;
      case ColorSchemeType.hoshoku:
        title = '補色';
        content = '''色相環で真向かいの位置にある色が補色です。メインカラーに対して、補色をアクセントとして使用すると人目を引く効果が期待できます。''';
        break;
      case ColorSchemeType.triad:
        title = 'トライアド';
        content = '''色相環で等しい距離にある３つの色の組み合わせです。バランスが良く、安定感があります。''';
        break;
      case ColorSchemeType.split:
        title = 'スプリット・コンプリメンタリ';
        break;
      case ColorSchemeType.ruiji:
        title = '類似色';
        break;
      case ColorSchemeType.hueTint:
        title = 'ヒュー・チント・シェード';
        break;
      default:
        title = '';
      //設定なし
    }

    return showDialog(
      context: context,
      builder: (BuildContext contex) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(contex).pop();
              },
              child: const Text('閉じる'),
            )
          ],
        );
      },
    );
  }

/*
  // 配色用の共通Container
  Container colorSchemContainer(Color pColor) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(color: pColor),
    );
  }
*/
  // 配色をRowで作成する
  // colorSchemTypeによって、返却するContainer数が異なる
  Row colorSchemRow(ColorSchemeType type) {
    // 選択中カラーのRGB配列作成
    List<int> aryRgb = [_controller.color.red, _controller.color.green, _controller.color.blue];
    switch (type) {
      case ColorSchemeType.hanten:
        //==============================
        // 反転色
        //==============================
        // 反転色計算処理
        Color col = invertRgb(aryRgb);
        // 画面表示
        return Row(
          children: [colorSchemContainer(col)],
        );
      case ColorSchemeType.hoshoku:
        //==============================
        // 補色
        //==============================
        // 補色計算処理
        Color col = complementaryRgb(aryRgb);
        // 画面表示
        return Row(
          children: [colorSchemContainer(col)],
        );
      case ColorSchemeType.triad:
        //==============================
        // トライアド
        //==============================
        // トライアド計算処理
        List<Color> triadicColor = colorTriadicRgb(aryRgb);
        // 画面表示
        return Row(
          children: [
            colorSchemContainer(triadicColor[0]),
            SizedBox(width: schemContainerSpaceWidth),
            colorSchemContainer(triadicColor[1]),
          ],
        );
      case ColorSchemeType.split:
        //==============================
        // スプリット・コンプリメンタリ
        //==============================
        // スプリット・コンプリメンタリ計算処理
        List<Color> splitColor = colorSplitComplementaryRgb(aryRgb);
        // 画面表示
        return Row(
          children: [
            colorSchemContainer(splitColor[0]),
            SizedBox(width: schemContainerSpaceWidth),
            colorSchemContainer(splitColor[1]),
          ],
        );
      case ColorSchemeType.ruiji:
        //==============================
        // 類似色
        //==============================
        // 類似色計算処理
        List<Color> analogousColor = colorAnalogousRgb(aryRgb);
        // 画面表示
        return Row(
          children: [
            colorSchemContainer(analogousColor[0]),
            SizedBox(width: schemContainerSpaceWidth),
            colorSchemContainer(analogousColor[1]),
          ],
        );
      case ColorSchemeType.hueTint:
        //==============================
        // ヒュー・チント・シェード
        //==============================
        // ヒュー・チント・シェード計算処理
        List<Color> hueTintShadeColor = colorHueTintShadeRgb(aryRgb);
        // 画面表示
        return Row(
          children: [
            colorSchemContainer(hueTintShadeColor[0]),
            SizedBox(width: schemContainerSpaceWidth),
            colorSchemContainer(hueTintShadeColor[1]),
          ],
        );
      default:
        // ここに入ることは無いはず
        return Row(
          children: [
            Container(),
          ],
        );
    }
  }

  //--------------------------------------
  // 反転色計算処理
  //--------------------------------------
  Color invertRgb(List<int> aryRgb) {
    // 空で初期化して、addAllする
    List<int> retColor = [...aryRgb];
    for (int i = 0; i < aryRgb.length; i++) {
      retColor[i] = 255 - aryRgb[i];
    }
    return Color.fromRGBO(retColor[0], retColor[1], retColor[2], 1);
  }

  //--------------------------------------
  // 補色計算処理
  //--------------------------------------
  Color complementaryRgb(List<int> aryRgb) {
    // 最大値・最小値を取得
    int maxNum = aryRgb.reduce(max);
    int minNum = aryRgb.reduce(min);

    int sum = maxNum + minNum;

    List<int> retColor = [...aryRgb];
    retColor[0] = sum - aryRgb[0];
    retColor[1] = sum - aryRgb[1];
    retColor[2] = sum - aryRgb[2];

    return Color.fromRGBO(retColor[0], retColor[1], retColor[2], 1);
  }

  //--------------------------------------
  // トライアド計算処理
  //--------------------------------------
  List<Color> colorTriadicRgb(List<int> aryRgb) {
    List<int> rgb1 = [...aryRgb];
    rgb1[0] = aryRgb[1];
    rgb1[1] = aryRgb[2];
    rgb1[2] = aryRgb[0];
    List<int> rgb2 = [...aryRgb];
    rgb2[0] = aryRgb[2];
    rgb2[1] = aryRgb[0];
    rgb2[2] = aryRgb[1];

    return [
      Color.fromRGBO(rgb1[0], rgb1[1], rgb1[2], 1),
      Color.fromRGBO(rgb2[0], rgb2[1], rgb2[2], 1),
    ];
  }

  //--------------------------------------
  // スプリット・コンプリメンタリ計算処理
  //--------------------------------------
  List<Color> colorSplitComplementaryRgb(List<int> aryRgb) {
    List<num> hsv = rgb2hsv(aryRgb);
    num h = hsv[0] + 180;
    num h0 = h + 30;
    num h1 = h - 30;

    // hsv2rgb:HSV色空間からRGB色空間へ変換する
    List<num> rgb1 = hsv2rgb(h0, hsv[1], hsv[2]);
    List<num> rgb2 = hsv2rgb(h1, hsv[1], hsv[2]);

    return [
      Color.fromRGBO(rgb1[0].toInt(), rgb1[1].toInt(), rgb1[2].toInt(), 1),
      Color.fromRGBO(rgb2[0].toInt(), rgb2[1].toInt(), rgb2[2].toInt(), 1),
    ];
  }

//--------------------------------------
// RGB色空間からHSV色空間へ変換する
//--------------------------------------
  List<num> rgb2hsv(List<int> aryRgb) {
    num r = aryRgb[0];
    num g = aryRgb[1];
    num b = aryRgb[2];
    num maxNum = aryRgb.reduce(max);
    num minNum = aryRgb.reduce(min);
    List<num> hsv = [0, 0, maxNum];
    if (maxNum != minNum) {
      // H（色相）
      if (maxNum == r) hsv[0] = 60 * (g - b) / (maxNum - minNum);
      if (maxNum == g) hsv[0] = 60 * (b - r) / (maxNum - minNum) + 120;
      if (maxNum == b) hsv[0] = 60 * (r - g) / (maxNum - minNum) + 240;

      // S（彩度）
      hsv[1] = (maxNum - minNum) / maxNum;
    }

    hsv[0] = hsv[0].round();
    hsv[1] = (hsv[1] * 100).round();
    hsv[2] = ((hsv[2] / 255) * 100).round();

    return hsv;
  }

  //--------------------------------------
  // HSV色空間からRGB色空間へ変換する
  //--------------------------------------
  List<num> hsv2rgb(num h, num s, num v) {
    List<num> rgb = [0, 0, 0];

    h = sanitizeHue(h);
    s = s / 100;
    v = v / 100;

    if (s == 0) {
      rgb[0] = v * 255;
      rgb[1] = v * 255;
      rgb[2] = v * 255;
      return rgb;
    }

    int dh = (h / 60).floor();
    num p = v * (1 - s);
    num q = v * (1 - s * (h / 60 - dh));
    num t = v * (1 - s * (1 - (h / 60 - dh)));

    switch (dh) {
      case 0:
        rgb[0] = v;
        rgb[1] = t;
        rgb[2] = p;
        break;
      case 1:
        rgb[0] = q;
        rgb[1] = v;
        rgb[2] = p;
        break;
      case 2:
        rgb[0] = p;
        rgb[1] = v;
        rgb[2] = t;
        break;
      case 3:
        rgb[0] = p;
        rgb[1] = q;
        rgb[2] = v;
        break;
      case 4:
        rgb[0] = t;
        rgb[1] = p;
        rgb[2] = v;
        break;
      case 5:
        rgb[0] = v;
        rgb[1] = p;
        rgb[2] = q;
        break;
      default:
        break;
    }
    rgb[0] = (rgb[0] * 255).round();
    rgb[1] = (rgb[1] * 255).round();
    rgb[2] = (rgb[2] * 255).round();
    return rgb;
  }

  num sanitizeHue(num hue) {
    if (hue >= 360) return hue - 360;
    if (hue < 0) return 360 + hue;
    return hue;
  }

  //--------------------------------------
  // 類似色計算処理
  //--------------------------------------
  List<Color> colorAnalogousRgb(List<int> aryRgb) {
    List<num> hsv = rgb2hsv(aryRgb);
    num h = hsv[0];
    num h0 = h + 30;
    num h1 = h - 30;

    //hsv2rgb:HSV色空間からRGB色空間へ変換する
    List<num> rgb1 = hsv2rgb(h0, hsv[1], hsv[2]);
    List<num> rgb2 = hsv2rgb(h1, hsv[1], hsv[2]);

    return [
      Color.fromRGBO(rgb1[0].toInt(), rgb1[1].toInt(), rgb1[2].toInt(), 1),
      Color.fromRGBO(rgb2[0].toInt(), rgb2[1].toInt(), rgb2[2].toInt(), 1),
    ];
  }

  //--------------------------------------
  // ヒュー・チント・シェード計算処理
  //--------------------------------------
  List<Color> colorHueTintShadeRgb(List<int> aryRgb) {
    List<int> rgb = [aryRgb[0], aryRgb[1], aryRgb[2]];

    List<int> Rs = [(rgb[0] * 3 / 5).floor(), (rgb[0] + ((255 - rgb[0]) * 4 / 5)).floor()];
    List<int> Gs = [(rgb[1] * 3 / 5).floor(), (rgb[1] + ((255 - rgb[1]) * 4 / 5)).floor()];
    List<int> Bs = [(rgb[2] * 3 / 5).floor(), (rgb[2] + ((255 - rgb[2]) * 4 / 5)).floor()];

    List<int> rgb1 = [Rs[0], Gs[0], Bs[0]];
    List<int> rgb2 = [Rs[1], Gs[1], Bs[1]];

    return [
      Color.fromRGBO(rgb1[0], rgb1[1], rgb1[2], 1),
      Color.fromRGBO(rgb2[0], rgb2[1], rgb2[2], 1),
    ];
  }
}
