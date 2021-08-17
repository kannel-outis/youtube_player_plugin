import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ignore_for_file: avoid_escaping_inner_quotes

class SizedAspectRatioWidget extends SingleChildRenderObjectWidget {
  final Size additionalSize;
  const SizedAspectRatioWidget({
    Key? key,
    required this.aspectRatio,
    this.additionalSize = const Size(0, 0),
    Widget? child,
  })  : assert(aspectRatio > 0.0),
        super(key: key, child: child);

  final double aspectRatio;

  @override
  RenderSizedAspectRatioWidget createRenderObject(BuildContext context) =>
      RenderSizedAspectRatioWidget(
          aspectRatio: aspectRatio, additionalSize: additionalSize);

  @override
  void updateRenderObject(
      BuildContext context, RenderSizedAspectRatioWidget renderObject) {
    renderObject
      ..aspectRatio = aspectRatio
      ..plusSize = additionalSize;
  }
}

class RenderSizedAspectRatioWidget extends RenderProxyBox {
  final Size additionalSize;

  RenderSizedAspectRatioWidget({
    RenderBox? child,
    required this.additionalSize,
    required double aspectRatio,
  })  : assert(aspectRatio > 0.0),
        assert(aspectRatio.isFinite),
        _aspectRatio = aspectRatio,
        _plusSize = additionalSize,
        super(child);

  late Size? _plusSize;
  Size? get plusSize => _plusSize;
  set plusSize(Size? size) {
    if (size != null) {
      if (size != _plusSize) _plusSize = size;
      markNeedsLayout();
    }
  }

  double get aspectRatio => _aspectRatio;
  double _aspectRatio;
  set aspectRatio(double value) {
    assert(value > 0.0);
    assert(value.isFinite);
    if (_aspectRatio == value) return;
    _aspectRatio = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (height.isFinite) return height * _aspectRatio;
    if (child != null) return child!.getMinIntrinsicWidth(height);
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (height.isFinite) return height * _aspectRatio;
    if (child != null) return child!.getMaxIntrinsicWidth(height);
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (width.isFinite) return width / _aspectRatio;
    if (child != null) return child!.getMinIntrinsicHeight(width);
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (width.isFinite) return width / _aspectRatio;
    if (child != null) return child!.getMaxIntrinsicHeight(width);
    return 0.0;
  }

  Size _applyAspectRatio(BoxConstraints constraints) {
    assert(constraints.debugAssertIsValid());
    assert(() {
      if (!constraints.hasBoundedWidth && !constraints.hasBoundedHeight) {
        throw FlutterError(
          '$runtimeType has unbounded constraints.\n'
          'This $runtimeType was given an aspect ratio of $aspectRatio but was given '
          'both unbounded width and unbounded height constraints. Because both '
          'constraints were unbounded, this render object doesn\'t know how much '
          'size to consume.',
        );
      }
      return true;
    }());

    if (constraints.isTight) return constraints.smallest;

    double width = constraints.maxWidth;
    double height;

    if (width.isFinite) {
      height = width / _aspectRatio;
    } else {
      height = constraints.maxHeight;
      width = height * _aspectRatio;
    }

    if (width > constraints.maxWidth) {
      width = constraints.maxWidth;
      height = width / _aspectRatio;
    }

    if (height > constraints.maxHeight) {
      height = constraints.maxHeight;
      width = height * _aspectRatio;
    }

    if (width < constraints.minWidth) {
      width = constraints.minWidth;
      height = width / _aspectRatio;
    }

    if (height < constraints.minHeight) {
      height = constraints.minHeight;
      width = height * _aspectRatio;
    }

    if (_plusSize != null) {
      return constraints.constrain(
          Size(width + _plusSize!.width, height + _plusSize!.height));
    } else {
      return constraints.constrain(Size(width, height));
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _applyAspectRatio(constraints);
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
    if (child != null) child!.layout(BoxConstraints.tight(size));
  }
}
