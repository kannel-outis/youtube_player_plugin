import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef SeekToCallBack = Function(double);

class ProgressSlider extends LeafRenderObjectWidget {
  final Color thumbColor, barColor, progressBarColor, bufferedColor;
  final double? thumbSize;
  final SeekToCallBack? seekTo;
  final double? bufferedValue;
  final double value;

  const ProgressSlider({
    Key? key,
    required this.thumbColor,
    required this.barColor,
    this.thumbSize,
    this.seekTo,
    this.bufferedValue,
    this.bufferedColor = Colors.white,
    required this.progressBarColor,
    this.value = 0.0,
  }) : super(key: key);
  @override
  RenderProgressSlider createRenderObject(BuildContext context) {
    return RenderProgressSlider(
      barColor: barColor,
      thumbColor: thumbColor,
      thumbSize: thumbSize!,
      seekTo: seekTo,
      bufferedValue: bufferedValue!,
      value: value,
      progressBarColor: progressBarColor,
      bufferedColor: bufferedColor,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderProgressSlider renderObject) {
    renderObject
      ..barcolor = barColor
      ..thumbcolor = thumbColor
      ..thumbsize = thumbSize!
      ..currentValue = value
      ..bufferedvalue = bufferedValue!
      ..progressBarcolor = progressBarColor
      ..bufferedcolor = bufferedColor;
  }
}

class RenderProgressSlider extends RenderBox {
  final Color thumbColor, barColor, progressBarColor, bufferedColor;
  final double thumbSize;
  final SeekToCallBack? seekTo;
  final double bufferedValue;
  final double value;

  RenderProgressSlider({
    required this.thumbColor,
    required this.barColor,
    required this.thumbSize,
    required this.progressBarColor,
    required this.bufferedColor,
    this.bufferedValue = 0.5,
    this.seekTo,
    this.value = 0.0,
  })  : _barcolor = barColor,
        _thumbColor = thumbColor,
        _progressBarcolor = progressBarColor,
        _bufferedcolor = bufferedColor,
        _thumbSize = thumbSize,
        _bufferedValue = bufferedValue,
        _currentValue = value,
        _show = value,
        _thumbValue = value {
    _dragGestureRecognizer = HorizontalDragGestureRecognizer()
      ..onStart = (dragStartDetails) {
        final dx = dragStartDetails.localPosition.dx.clamp(0, size.width);

        _thumbValue = _show = _currentValue = dx / size.width;
        // _thumbSize = _thumbSize * 1.2;
        markNeedsPaint();
        markNeedsSemanticsUpdate();
      }
      ..onUpdate = (updateDetails) {
        final dx = updateDetails.localPosition.dx.clamp(0, size.width);
        _thumbValue = _currentValue = dx / size.width;
        _dragging = true;
        markNeedsPaint();
        markNeedsSemanticsUpdate();
      }
      ..onEnd = (dragEndDetails) {
        _show = _currentValue;
        _thumbValue = _currentValue;
        thumbsize = thumbSize;
        _dragging = false;
        seekTo?.call(_show);
        markNeedsLayout();
      };
  }

  late final HorizontalDragGestureRecognizer _dragGestureRecognizer;
  late double _show;

  late Color _thumbColor, _barcolor, _progressBarcolor, _bufferedcolor;
  late double _thumbSize;
  late double _currentValue;
  late double _bufferedValue;
  late double _thumbValue;
  bool _dragging = false;

  Color get thumbcolor => _thumbColor;
  set thumbcolor(Color newColor) {
    if (_thumbColor == newColor) return;
    _thumbColor = newColor;
    markNeedsPaint();
  }

  Color get barcolor => _barcolor;
  set barcolor(Color newColor) {
    if (_barcolor == newColor) return;
    _barcolor = newColor;
    markNeedsPaint();
  }

  double get thumbsize => _thumbSize;
  set thumbsize(double newValue) {
    if (_thumbSize == newValue) return;
    _thumbSize = newValue;
    markNeedsLayout();
  }

  double get currentValue => _currentValue;
  set currentValue(double newValue) {
    if (_currentValue == newValue) return;
    _currentValue = newValue;
    _show = _currentValue;
    if (!_dragging) _thumbValue = _currentValue;
    markNeedsPaint();
  }

  double get bufferedvalue => _bufferedValue;
  set bufferedvalue(double newValue) {
    if (_bufferedValue == newValue) return;
    _bufferedValue = newValue;
    markNeedsPaint();
  }

  Color get progressBarcolor => _progressBarcolor;
  set progressBarcolor(Color newColor) {
    if (_progressBarcolor == newColor) return;
    _progressBarcolor = newColor;
    markNeedsPaint();
  }

  Color get bufferedcolor => _bufferedcolor;
  set bufferedcolor(Color newColor) {
    if (_bufferedcolor == newColor) return;
    _bufferedcolor = newColor;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    //Progressbar
    final barPaint = Paint()
      ..color = _barcolor
      ..strokeWidth = 1.8;
    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width, size.height / 2);
    canvas.drawLine(point1, point2, barPaint);

    // notBuffered progress Bar
    final notBufferedPaint = Paint()
      ..color = _barcolor
      ..strokeWidth = 1.8;
    final np1 = Offset(
      _currentValue > _bufferedValue
          ? _show * size.width
          : _bufferedValue * size.width,
      size.height / 2,
    );
    final np2 = Offset(size.width, size.height / 2);
    canvas.drawLine(np1, np2, notBufferedPaint);

//bufferedProgress
    final s = Paint()
      // ..color = Colors.blue.withOpacity(.4)
      ..color = _bufferedcolor
      ..strokeWidth = 1.8;
    final s1 = Offset(0, size.height / 2);
    final s2 =
        Offset(_bufferedValue.clamp(0.0, 1.0) * size.width, size.height / 2);
    canvas.drawLine(s1, s2, s);

//Progress
    final p = Paint()
      ..color = _progressBarcolor
      ..strokeWidth = 2.3;
    final p1 = Offset(0, size.height / 2);
    final p2 = Offset(_show.clamp(0.0, 1.0) * size.width, size.height / 2);
    canvas.drawLine(p1, p2, p);

// thumb
    final thumbPaint = Paint()..color = _thumbColor;
    final thumbDx = _thumbValue.clamp(0.0, 1.0) * size.width;
    final center = Offset(thumbDx, size.height / 2);
    canvas.drawCircle(center, _thumbSize / 2, thumbPaint);
    canvas.restore();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final height = _thumbSize;
    final width = constraints.maxWidth;
    final size = Size(width, height);
    return constraints.constrain(size);
  }

  @override
  double computeMaxIntrinsicHeight(double width) => _thumbSize;

  @override
  double computeMinIntrinsicHeight(double width) => _thumbSize;

  @override
  double computeMaxIntrinsicWidth(double height) => 80.0;

  @override
  double computeMinIntrinsicWidth(double height) => 80.0;

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _dragGestureRecognizer.addPointer(event);
    }
  }
}
