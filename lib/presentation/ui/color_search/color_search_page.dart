import 'package:color_code_gen/common/common_const.dart';
import 'package:color_code_gen/common/common_util.dart';
import 'package:color_code_gen/presentation/controller/color_controller.dart';
import 'package:color_code_gen/presentation/ui/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
/// カラー検索ページ
///
class ColorSearchPage extends StatefulWidget {
  const ColorSearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ColorSearchPageState createState() => _ColorSearchPageState();
}

class _ColorSearchPageState extends State<ColorSearchPage> {
  Color _currentColor = Colors.blue;
  final _controller = CircleColorPickerController(
    initialColor: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    final pageTitle = TabItem.search.title;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _currentColor,
        title: Text(pageTitle),
      ),
      body: body(),
    );
  }

  Stack body() {
    return Stack(
      children: [
        // メインコンテンツ
        SingleChildScrollView(
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
}
