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
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          const SizedBox(height: 48),
          Center(
            child: CircleColorPicker(
              controller: _controller,
              onChanged: (color) {
                setState(() => _currentColor = color);
              },
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () => _controller.color = Colors.blue,
                child: const Text('BLUE', style: TextStyle(color: Colors.blue)),
              ),
              TextButton(
                onPressed: () => _controller.color = Colors.green,
                child: const Text('GREEN', style: TextStyle(color: Colors.green)),
              ),
              TextButton(
                onPressed: () => _controller.color = Colors.red,
                child: const Text('RED', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
