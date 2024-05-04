import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

Future<Uint8List> getBytesFromCanvas(
  
  int width, int height, Uint8List dataBytes) async {
final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
final Canvas canvas = Canvas(pictureRecorder);
final Paint paint = Paint()..color = Colors.transparent;
final Radius radius = Radius.circular(20.0);
canvas.drawRRect(
    RRect.fromRectAndCorners(
      Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    ),
    paint);

var imaged = await loadImage(dataBytes.buffer.asUint8List());
canvas.drawImageRect(
  imaged,
  Rect.fromLTRB(
      0.0, 0.0, imaged.width.toDouble(), imaged.height.toDouble()),
  Rect.fromLTRB(0.0, 0.0, width.toDouble(), height.toDouble()),
  new Paint(),
);

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
 }

    Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
  return completer.complete(img);
});
return completer.future;
}