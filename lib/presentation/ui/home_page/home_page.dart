import 'package:color_code_gen/presentation/ui/color_picker.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
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
          title: const Text('sample'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            // カラーコード指定
            const Row(),
            const SizedBox(height: 48),
            // 色円指定
            Center(
              child: CircleColorPicker(
                controller: _controller,
                onChanged: (color) {
                  setState(() => _currentColor = color);
                },
              ),
            ),
            const SizedBox(height: 20),
            // 色直接指定
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  spacing: 9,
                  runSpacing: 6,
                  children: [
                    colorContainer(_controller, Colors.pink),
                    colorContainer(_controller, Colors.red),
                    colorContainer(_controller, Colors.deepOrange),
                    colorContainer(_controller, Colors.orange),
                    colorContainer(_controller, Colors.yellow),
                    colorContainer(_controller, Colors.lime),
                    colorContainer(_controller, Colors.lightGreen),
                    colorContainer(_controller, Colors.green),
                    colorContainer(_controller, Colors.teal),
                    colorContainer(_controller, Colors.cyan),
                    colorContainer(_controller, Colors.lightBlue),
                    colorContainer(_controller, Colors.blue),
                    colorContainer(_controller, Colors.indigo),
                    colorContainer(_controller, Colors.purple),
                    colorContainer(_controller, Colors.deepPurple),
                    colorContainer(_controller, Colors.blueGrey),
                    colorContainer(_controller, Colors.brown),
                    colorContainer(_controller, Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorContainer(CircleColorPickerController controller, MaterialColor pColor) {
    return GestureDetector(
      onTap: () => controller.color = pColor,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(color: pColor),
      ),
    );
  }
}
