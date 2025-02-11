import 'dart:async';
import 'dart:math';

import 'package:color_code_gen/common/common_const.dart';
import 'package:color_code_gen/presentation/controller/color_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ColorCodeBuilder = Widget Function(BuildContext context, Color color);

class CircleColorPickerController extends ChangeNotifier {
  CircleColorPickerController({
    Color initialColor = const Color.fromARGB(255, 255, 0, 0),
  }) : _color = initialColor;

  Color _color;
  Color get color => _color;
  set color(Color color) {
    _color = color;
    notifyListeners();
  }

  final text_16 = TextEditingController();
  final textR = TextEditingController();
  final textG = TextEditingController();
  final textB = TextEditingController();

  onChangedText16(String text) {
    // カラー指定タイプが16進数の場合
    if (text.length < 6) return;
    // 16進数で色指定する場合、8桁必要
    String hex = text;
    // intに変換してみる（16進数で使用できない文字が含まれている場合0を返す）
    int colorValue = int.tryParse(hex, radix: 16) ?? 0;
    // 変換に失敗したら処理終了
    if (colorValue == 0) return;
    // 変換できたら選択中の色を変更する
    _color = Color(colorValue);
    notifyListeners();
  }

  onChangedTextRGB(String text) {
    // カラー指定タイプがRGBの場合
  }
}

class CircleColorPicker extends StatefulWidget {
  const CircleColorPicker({
    super.key,
    this.onChanged,
    this.onEnded,
    this.size = const Size(300, 300),
    this.strokeWidth = 8,
    this.thumbSize = 40,
    this.controller,
    this.textStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    this.colorCodeBuilder,
  });

  /// ユーザーが色を選択しているとき（ドラッグ中）に呼び出される
  /// このコールバックは、ユーザーが選択した最新の色で呼び出される
  final ValueChanged<Color>? onChanged;

  /// ドラッグが終了したときに呼び出される
  /// このコールバックは、ユーザーが選択した最新の色で呼び出される
  final ValueChanged<Color>? onEnded;

  /// ピッカーの色を動的に制御するオブジェクト
  /// 必要に応じて、initialColorを指定します
  final CircleColorPickerController? controller;

  /// ウィジェットのサイズ
  /// ドラッグ可能な領域には、親指ウィジェットが含まれるため
  /// 円はサイズより小さくなります
  /// Default value is 280 x 280.
  final Size size;

  /// 円の枠線の幅
  /// Default value is 2.
  final double strokeWidth;

  /// サークルピッカーの親指サイズ
  /// Default value is 32.
  final double thumbSize;

  /// テキストスタイの設定
  /// Default value is Black
  final TextStyle textStyle;

  /// カラーコードセクションを表示するウィジェットビルダー
  /// この関数は色が変更されるたびに呼び出される
  /// デフォルトは、RGB文字列を表示するテキストウィジェット
  final ColorCodeBuilder? colorCodeBuilder;

  Color get initialColor => controller?.color ?? const Color.fromARGB(255, 255, 0, 0);

  double get initialLightness => HSLColor.fromColor(initialColor).lightness;

  double get initialHue => HSLColor.fromColor(initialColor).hue;

  @override
  // ignore: library_private_types_in_public_api
  _CircleColorPickerState createState() => _CircleColorPickerState();
}

class _CircleColorPickerState extends State<CircleColorPicker> with TickerProviderStateMixin {
  late AnimationController _lightnessController;
  late AnimationController _hueController;

  Color get _color {
    return HSLColor.fromAHSL(
      1,
      _hueController.value,
      1,
      _lightnessController.value,
    ).toColor();
  }

  // カラー円と、カラー円の内側の表示
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Stack(
        children: <Widget>[
          // カラー円の表示
          _HuePicker(
            hue: _hueController.value,
            size: widget.size,
            strokeWidth: widget.strokeWidth,
            thumbSize: widget.thumbSize,
            onEnded: _onEnded,
            onChanged: (hue) {
              _hueController.value = hue;
            },
          ),
          // カラー円の内側の表示
          insideColorCircle(),
        ],
      ),
    );
  }

  // カラー円の内側の表示
  AnimatedBuilder insideColorCircle() {
    return AnimatedBuilder(
      animation: _hueController,
      builder: (context, child) {
        return Consumer(
          builder: (context, ref, _) {
            return AnimatedBuilder(
              animation: _lightnessController,
              builder: (context, _) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // 選択中の色を、カラーコード(16進数)で表示
                      widget.colorCodeBuilder != null
                          ? widget.colorCodeBuilder!(context, _color)
                          : Text(
                              getColorCode(ref),
                              style: widget.textStyle,
                            ),
                      const SizedBox(height: 16),
                      // 選択中の色を、中心に「◯」で表示
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: _color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3,
                            color: HSLColor.fromColor(_color)
                                .withLightness(
                                  _lightnessController.value * 4 / 5,
                                )
                                .toColor(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 明るさのスライダーを表示
                      _LightnessSlider(
                        width: 140,
                        thumbSize: 26,
                        hue: _hueController.value,
                        lightness: _lightnessController.value,
                        onEnded: _onEnded,
                        onChanged: (lightness) {
                          _lightnessController.value = lightness;
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // カラーコードタイプのカラーコードを返却する
  String getColorCode(WidgetRef ref) {
    final colorCon = ref.watch(colorController);
    String ret;

    if (colorCon.colorCodeTypeSelected == ColorCodeType.hex.name) {
      // 16進数の場合
      ret = '#${_color.value.toRadixString(16).substring(2)}';
    } else {
      // RGBの場合
      ret = '${_color.red}, ${_color.green}, ${_color.blue}';
    }
    // カラーコードを返却
    return ret;
  }

  @override
  void initState() {
    super.initState();
    _hueController = AnimationController(
      vsync: this,
      value: widget.initialHue,
      lowerBound: 0,
      upperBound: 360,
    )..addListener(_onColorChanged);
    _lightnessController = AnimationController(
      vsync: this,
      value: widget.initialLightness,
      lowerBound: 0,
      upperBound: 1,
    )..addListener(_onColorChanged);
    widget.controller?.addListener(_setColor);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_setColor);
    super.dispose();
  }

  void _onColorChanged() {
    widget.onChanged?.call(_color);
    widget.controller?.color = _color;
  }

  void _onEnded() {
    widget.onEnded?.call(_color);
  }

  void _setColor() {
    if (widget.controller != null && widget.controller!.color != _color) {
      final hslColor = HSLColor.fromColor(widget.controller!.color);
      _hueController.value = hslColor.hue;
      _lightnessController.value = hslColor.lightness;
    }
  }
}

class _LightnessSlider extends StatefulWidget {
  const _LightnessSlider({
    super.key,
    required this.hue,
    required this.lightness,
    required this.width,
    required this.onChanged,
    required this.onEnded,
    required this.thumbSize,
  });

  final double hue;

  final double lightness;

  final double width;

  final ValueChanged<double> onChanged;

  final VoidCallback onEnded;

  final double thumbSize;

  @override
  _LightnessSliderState createState() => _LightnessSliderState();
}

class _LightnessSliderState extends State<_LightnessSlider> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  Timer? _cancelTimer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onDown,
      onPanCancel: _onCancel,
      onHorizontalDragStart: _onStart,
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      onVerticalDragStart: _onStart,
      onVerticalDragUpdate: _onUpdate,
      onVerticalDragEnd: _onEnd,
      child: SizedBox(
        width: widget.width,
        height: widget.thumbSize,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 12,
              margin: EdgeInsets.symmetric(
                horizontal: widget.thumbSize / 3,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                gradient: LinearGradient(
                  stops: const [0, 0.4, 1],
                  colors: [
                    HSLColor.fromAHSL(1, widget.hue, 1, 0).toColor(),
                    HSLColor.fromAHSL(1, widget.hue, 1, 0.5).toColor(),
                    HSLColor.fromAHSL(1, widget.hue, 1, 0.9).toColor(),
                  ],
                ),
              ),
            ),
            Positioned(
              left: widget.lightness * (widget.width - widget.thumbSize),
              child: ScaleTransition(
                scale: _scaleController,
                child: _Thumb(
                  size: widget.thumbSize,
                  color: HSLColor.fromAHSL(
                    1,
                    widget.hue,
                    1,
                    widget.lightness,
                  ).toColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      value: 1,
      lowerBound: 0.9,
      upperBound: 1,
      duration: const Duration(milliseconds: 50),
    );
  }

  void _onDown(DragDownDetails details) {
    _scaleController.reverse();
    widget.onChanged(details.localPosition.dx / widget.width);
  }

  void _onStart(DragStartDetails details) {
    _cancelTimer?.cancel();
    _cancelTimer = null;
    widget.onChanged(details.localPosition.dx / widget.width);
  }

  void _onUpdate(DragUpdateDetails details) {
    widget.onChanged(details.localPosition.dx / widget.width);
  }

  void _onEnd(DragEndDetails details) {
    _scaleController.forward();
    widget.onEnded();
  }

  void _onCancel() {
    // onDragStartがすぐに呼び出された場合、ScaleDownアニメーションはキャンセルされる
    _cancelTimer = Timer(
      const Duration(milliseconds: 5),
      () {
        _scaleController.forward();
        widget.onEnded();
      },
    );
  }
}

class _HuePicker extends StatefulWidget {
  const _HuePicker({
    super.key,
    required this.hue,
    required this.onChanged,
    required this.onEnded,
    required this.size,
    required this.strokeWidth,
    required this.thumbSize,
  });

  final double hue;

  final ValueChanged<double> onChanged;

  final VoidCallback onEnded;

  final Size size;

  final double strokeWidth;

  final double thumbSize;

  @override
  _HuePickerState createState() => _HuePickerState();
}

class _HuePickerState extends State<_HuePicker> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  Timer? _cancelTimer;

  @override
  Widget build(BuildContext context) {
    final minSize = min(widget.size.width, widget.size.height);
    final offset = _CircleTween(
      minSize / 2 - widget.thumbSize / 2,
    ).lerp(widget.hue * pi / 180);
    return GestureDetector(
      onPanDown: _onDown,
      onPanCancel: _onCancel,
      onHorizontalDragStart: _onStart,
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      onVerticalDragStart: _onStart,
      onVerticalDragUpdate: _onUpdate,
      onVerticalDragEnd: _onEnd,
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.all(
                  widget.thumbSize / 2 - widget.strokeWidth,
                ),
                child: CustomPaint(
                  painter: _CirclePickerPainter(widget.strokeWidth),
                ),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: ScaleTransition(
                scale: _scaleController,
                child: _Thumb(
                  size: widget.thumbSize,
                  color: HSLColor.fromAHSL(1, widget.hue, 1, 0.5).toColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      value: 1,
      lowerBound: 0.9,
      upperBound: 1,
      duration: const Duration(milliseconds: 50),
    );
  }

  void _onDown(DragDownDetails details) {
    _scaleController.reverse();
    _updatePosition(details.localPosition);
  }

  void _onStart(DragStartDetails details) {
    _cancelTimer?.cancel();
    _cancelTimer = null;
    _updatePosition(details.localPosition);
  }

  void _onUpdate(DragUpdateDetails details) {
    _updatePosition(details.localPosition);
  }

  void _onEnd(DragEndDetails details) {
    _scaleController.forward();
    widget.onEnded();
  }

  void _onCancel() {
    // onDragStartがすぐに呼び出された場合、ScaleDownアニメーションはキャンセルされる
    _cancelTimer = Timer(
      const Duration(milliseconds: 5),
      () {
        _scaleController.forward();
        widget.onEnded();
      },
    );
  }

  void _updatePosition(Offset position) {
    final radians = atan2(
      position.dy - widget.size.height / 2,
      position.dx - widget.size.width / 2,
    );
    widget.onChanged(radians % (2 * pi) * 180 / pi);
  }
}

class _CircleTween extends Tween<Offset> {
  _CircleTween(this.radius)
      : super(
          begin: _radiansToOffset(0, radius),
          end: _radiansToOffset(2 * pi, radius),
        );

  final double radius;

  @override
  Offset lerp(double t) => _radiansToOffset(t, radius);

  static Offset _radiansToOffset(double radians, double radius) {
    return Offset(
      radius + radius * cos(radians),
      radius + radius * sin(radians),
    );
  }
}

class _CirclePickerPainter extends CustomPainter {
  const _CirclePickerPainter(
    this.strokeWidth,
  );

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radio = min(size.width, size.height) / 2 - strokeWidth;

    const sweepGradient = SweepGradient(
      colors: [
        Color.fromARGB(255, 255, 0, 0),
        Color.fromARGB(255, 255, 255, 0),
        Color.fromARGB(255, 0, 255, 0),
        Color.fromARGB(255, 0, 255, 255),
        Color.fromARGB(255, 0, 0, 255),
        Color.fromARGB(255, 255, 0, 255),
        Color.fromARGB(255, 255, 0, 0),
      ],
    );

    final sweepShader = sweepGradient.createShader(
      Rect.fromCircle(center: center, radius: radio),
    );

    canvas.drawCircle(
      center,
      radio,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 2
        ..shader = sweepShader,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    super.key,
    required this.size,
    required this.color,
  });

  final double size;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(16, 0, 0, 0),
            blurRadius: 4,
            spreadRadius: 4,
          )
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        width: size - 6,
        height: size - 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
