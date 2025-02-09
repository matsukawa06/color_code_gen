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
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10),
                  // カラーコード指定
                  colorCode(),
                  const SizedBox(height: 16),
                  // 色円指定
                  Center(
                    child: CircleColorPicker(
                      controller: _controller,
                      onChanged: (color) {
                        setState(() => _currentColor = color);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 色直接指定
                  colorDirect(),
                  const SizedBox(height: 16),
                  // 配色表示
                  colorScheme(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            // トップへ戻るボタン
            Visibility(
              visible: 0 == 0, //_scrollController.offset > 0.0,
              child: Positioned(
                bottom: 35,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    // ボタンが押されたときにスクロール位置を一番上に戻す
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Icon(Icons.arrow_upward),
                ),
              ),
            )
          ],
        ),
      ),
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
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                // カラー指定タイプを選択するためのプルダウンリスト
                DropdownButton(
                  items: [
                    DropdownMenuItem(
                      value: ColorCodeType.hex.name,
                      child: const Text('HEX', style: TextStyle(fontSize: 20)),
                    ),
                    DropdownMenuItem(
                      value: ColorCodeType.rgb.name,
                      child: const Text('RGB', style: TextStyle(fontSize: 20)),
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
                      const Text('#', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      textBox_16(),
                    ],
                  ),
                ),
                Visibility(
                  visible: colorCon.colorCodeTypeSelected == ColorCodeType.rgb.name,
                  child: Row(
                    children: [
                      textBoxRgb(_controller.textR),
                      const SizedBox(width: 8),
                      textBoxRgb(_controller.textG),
                      const SizedBox(width: 8),
                      textBoxRgb(_controller.textB),
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
  SizedBox textBoxRgb(TextEditingController text) {
    return SizedBox(
      width: 70,
      child: TextFormField(
        controller: text,
        enableInteractiveSelection: true,
        enabled: true,
        obscureText: false,
        maxLength: 3,
        maxLines: 1,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
          filled: true,
          counterText: '',
        ),
        onChanged: (e) {
          _controller.onChangedTextRGB(e);
        },
      ),
    );
  }

  // 16進数のテキストボックス
  SizedBox textBox_16() {
    return SizedBox(
      width: 110,
      child: TextFormField(
        controller: _controller.text_16,
        enableInteractiveSelection: true, // コピペ有効
        enabled: true,
        obscureText: false,
        maxLength: 6,
        maxLines: 1,
        style: const TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none, // 入力エリアの下線を非表示
          // hintText: '000000',
          filled: true, // 背景色を表示する
          counterText: '', // 右下のカウンターを非表示
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
          padding: const EdgeInsets.all(20),
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
          0: FlexColumnWidth(4), // 1列目の幅
          1: FlexColumnWidth(6), // 2列目の幅
        },
        children: <TableRow>[
          commonTableRow('補色', ColorSchemType.hoshoku),
          commonTableRow('トライアド', ColorSchemType.toraiado),
          commonTableRow('スプリメット・コンプリメンタリ', ColorSchemType.supuritto),
          commonTableRow('類似色', ColorSchemType.ruiji),
          commonTableRow('ヒュー・チント・シェード', ColorSchemType.hyuchinto),
        ],
      ),
    );
  }

  // 配色の行部分
  TableRow commonTableRow(String name, ColorSchemType type) {
    return TableRow(
      children: <Widget>[
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(name, style: const TextStyle(fontSize: 20)),
            ),
          ),
        ),
        // 実際の配色を表示する部分
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: _controller.color),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: colorSchem1),
              )
            ],
          ),
        ),
      ],
    );
  }

  MaterialColor get colorSchem1 => Colors.red;

  // メモリリークを防ぐため、ScrollControllerを破棄する
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
