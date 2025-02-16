//--------------------------------------
// 反転色計算処理
//--------------------------------------
import 'dart:math';

import 'package:flutter/material.dart';

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
// RGB色空間からHSL色空間へ変換する
//--------------------------------------
List<num> rgb2hsl(List<int> aryRgb) {
  num r = aryRgb[0];
  num g = aryRgb[1];
  num b = aryRgb[2];
  num maxNum = aryRgb.reduce(max);
  num minNum = aryRgb.reduce(min);
  List<num> hsl = [0, 0, 0];
  // H（色相）
  if (maxNum != minNum) {
    if (maxNum == r) hsl[0] = 60 * (g - b) / (maxNum - minNum);
    if (maxNum == g) hsl[0] = 60 * (b - r) / (maxNum - minNum) + 120;
    if (maxNum == b) hsl[0] = 60 * (r - g) / (maxNum - minNum) + 240;
    if (hsl[0] < 0) {
      // 求めた色相がマイナスの場合、360を加算して0〜360の範囲に収める
      hsl[0] += 360;
    }
  }

  // S（彩度）
  num cnt = (maxNum + minNum) / 2;
  if (cnt <= 127) {
    hsl[1] = (maxNum - minNum) / (maxNum + minNum);
  } else {
    hsl[1] = (maxNum - minNum) / (510 - maxNum - minNum);
  }

  // L（輝度）
  hsl[2] = (maxNum + minNum) / 2;

  return hsl;
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
