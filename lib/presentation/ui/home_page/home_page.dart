import 'package:color_code_gen/presentation/ui/color_picker.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _currentColor,
          title: const Text('カラー検索'),
        ),
        body: SingleChildScrollView(
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
            ],
          ),
        ),
      ),
    );
  }

  //
  // カラーコード指定
  //
  Card colorCode() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            const Text(
              '16進',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 5),
            textBox_16(),
            const SizedBox(width: 10),
            const Text(
              'RGB',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 5),
            textBoxRgb(_controller.textR),
            const SizedBox(width: 2),
            textBoxRgb(_controller.textG),
            const SizedBox(width: 2),
            textBoxRgb(_controller.textB),
          ],
        ),
      ),
    );
  }

  SizedBox textBoxRgb(TextEditingController text) {
    return SizedBox(
      width: 60,
      child: TextFormField(
        controller: text,
        enableInteractiveSelection: true,
        enabled: true,
        obscureText: false,
        maxLength: 3,
        maxLines: 1,
        style: const TextStyle(fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          filled: true,
          counterText: '',
        ),
        onChanged: (e) {
          _controller.onChangedText(e);
        },
      ),
    );
  }

  // 16進数のテキストボックス
  SizedBox textBox_16() {
    return SizedBox(
      width: 94,
      child: TextFormField(
        controller: _controller.text_16,
        enableInteractiveSelection: true, // コピペ有効
        enabled: true,
        obscureText: false,
        maxLength: 6,
        maxLines: 1,
        style: const TextStyle(fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none, // 入力エリアの下線を非表示
          // hintText: '000000',
          filled: true, // 背景色を表示する
          counterText: '', // 右下のカウンターを非表示
        ),
        onChanged: (e) {
          _controller.onChangedText(e);
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
}
