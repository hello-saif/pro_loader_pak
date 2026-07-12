import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pro_loader/src/enum/pro_loader_type.dart';

class ProLoader extends StatefulWidget {
  const ProLoader({
    super.key,
    this.type = ProLoaderType.circleSpin,
    this.color,
    this.secondaryColor,
    this.size = 48,
    this.strokeWidth = 4,
    this.duration = const Duration(milliseconds: 1200),
    this.value,
  });

  final ProLoaderType type;
  final Color? color;
  final Color? secondaryColor;
  final double size;
  final double strokeWidth;
  final Duration duration;
  final double? value;

  @override
  State<ProLoader> createState() => _ProLoaderState();
}

class _ProLoaderState extends State<ProLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(ProLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;
    final secondaryColor =
        widget.secondaryColor ?? color.withValues(alpha: 0.22);

    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ProLoaderPainter(
              type: widget.type,
              progress: widget.value ?? _controller.value,
              color: color,
              secondaryColor: secondaryColor,
              strokeWidth: widget.strokeWidth,
              value: widget.value,
            ),
          );
        },
      ),
    );
  }
}

class ProLoadingButton extends StatelessWidget {
  const ProLoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.child,
    this.loaderType = ProLoaderType.buttonLoader,
    this.loaderColor,
    this.loaderSize = 22,
  });

  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget child;
  final ProLoaderType loaderType;
  final Color? loaderColor;
  final double loaderSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: isLoading
            ? ProLoader(
                key: const ValueKey('loader'),
                type: loaderType,
                color: loaderColor,
                size: loaderSize,
              )
            : KeyedSubtree(key: const ValueKey('child'), child: child),
      ),
    );
  }
}

class ProLoaderOverlay {
  const ProLoaderOverlay._();

  static OverlayEntry? _entry;

  static bool get isShowing => _entry != null;

  static void show(
    BuildContext context, {
    ProLoaderType type = ProLoaderType.overlayLoader,
    Color? color,
    Color barrierColor = const Color(0x66000000),
    double size = 56,
    bool dismissible = false,
  }) {
    hide();

    _entry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: dismissible ? hide : null,
                child: ColoredBox(color: barrierColor),
              ),
            ),
            Center(
              child: ProLoader(type: type, color: color, size: size),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _ProLoaderPainter extends CustomPainter {
  const _ProLoaderPainter({
    required this.type,
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.strokeWidth,
    required this.value,
  });

  final ProLoaderType type;
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double strokeWidth;
  final double? value;

  @override
  void paint(Canvas canvas, Size size) {
    final index = type.index;

    if (_drawNamed(canvas, size)) {
      return;
    }

    switch (index % 10) {
      case 0:
        _ring(canvas, size, segments: 1 + index % 4);
      case 1:
        _dots(canvas, size, count: 3 + index % 5, orbit: index.isOdd);
      case 2:
        _bars(canvas, size, count: 3 + index % 6);
      case 3:
        _squares(canvas, size, count: 4 + index % 5);
      case 4:
        _ripple(canvas, size, rings: 2 + index % 3);
      case 5:
        _pulse(canvas, size);
      case 6:
        _arcLines(canvas, size, lines: 8 + index % 8);
      case 7:
        _wave(canvas, size, count: 4 + index % 4);
      case 8:
        _grid(canvas, size, columns: 3);
      default:
        _progress(canvas, size);
    }
  }

  bool _drawNamed(Canvas canvas, Size size) {
    switch (type) {
      case ProLoaderType.circleSpin:
        _ring(canvas, size, segments: 1);
      case ProLoaderType.dualRing:
        _ring(canvas, size, segments: 2);
      case ProLoaderType.threeBounce:
      case ProLoaderType.typingDots:
        _dots(canvas, size, count: 3);
      case ProLoaderType.wave:
        _wave(canvas, size, count: 5);
      case ProLoaderType.pulse:
      case ProLoaderType.heartBeat:
        _pulse(canvas, size);
      case ProLoaderType.fadingCircle:
        _arcLines(canvas, size, lines: 12);
      case ProLoaderType.rotatingDots:
      case ProLoaderType.chasingDots:
        _dots(canvas, size, count: 8, orbit: true);
      case ProLoaderType.cubeGrid:
      case ProLoaderType.skeletonGrid:
        _grid(canvas, size, columns: 3);
      case ProLoaderType.foldingCube:
      case ProLoaderType.rotatingSquare:
      case ProLoaderType.flippingSquare:
        _squares(canvas, size, count: 4);
      case ProLoaderType.hourGlass:
        _hourGlass(canvas, size);
      case ProLoaderType.linearDots:
        _dots(canvas, size, count: 5);
      case ProLoaderType.bars:
      case ProLoaderType.equalizer:
        _bars(canvas, size, count: 5);
      case ProLoaderType.ripple:
        _ripple(canvas, size, rings: 3);
      case ProLoaderType.orbit:
      case ProLoaderType.planet:
        _orbit(canvas, size);
      case ProLoaderType.radar:
        _radar(canvas, size);
      case ProLoaderType.wifi:
        _wifi(canvas, size);
      case ProLoaderType.infinity:
        _infinity(canvas, size);
      case ProLoaderType.spinnerLines:
        _arcLines(canvas, size, lines: 10);
      case ProLoaderType.scalingCircle:
      case ProLoaderType.elasticCircle:
      case ProLoaderType.doubleBounce:
        _pulse(canvas, size, secondCircle: true);
      case ProLoaderType.tripleRing:
        _ring(canvas, size, segments: 3);
      case ProLoaderType.progressRing:
      case ProLoaderType.percentageLoader:
        _progress(canvas, size);
      case ProLoaderType.liquidFill:
        _liquid(canvas, size);
      case ProLoaderType.shimmerLine:
        _shimmerLine(canvas, size);
      case ProLoaderType.shimmerCard:
        _shimmerCard(canvas, size);
      case ProLoaderType.skeletonList:
        _skeletonList(canvas, size);
      case ProLoaderType.skeletonProfile:
        _skeletonProfile(canvas, size);
      case ProLoaderType.buttonLoader:
      case ProLoaderType.overlayLoader:
      case ProLoaderType.fullscreenLoader:
      case ProLoaderType.dialogLoader:
        _ring(canvas, size, segments: 1);
      case ProLoaderType.uploadLoader:
        _arrow(canvas, size, up: true);
      case ProLoaderType.downloadLoader:
        _arrow(canvas, size, up: false);
      case ProLoaderType.stepLoader:
        _steps(canvas, size);
      case ProLoaderType.routeLoader:
        _route(canvas, size);
      case ProLoaderType.pageLoader:
        _page(canvas, size);
      case ProLoaderType.imageLoader:
        _image(canvas, size);
      case ProLoaderType.searchLoader:
        _search(canvas, size);
      case ProLoaderType.paymentLoader:
        _payment(canvas, size);
      case ProLoaderType.successTransitionLoader:
        _success(canvas, size);
      case ProLoaderType.hexagonSpin:
        _hexagonSpin(canvas, size);
      case ProLoaderType.apple:
        apple(canvas, size);
      case ProLoaderType.googleMaterial:
        _googleMaterial(canvas, size);
      case ProLoaderType.liquidSpinner:
        _liquidSpinner(canvas, size);
      case ProLoaderType.dnaLoader:
        _dnaLoader(canvas, size);
      case ProLoaderType.orbitAtom:
        _orbitAtom(canvas, size);
    }

    return true;
  }

  Paint get _paint => Paint()
    ..color = color
    ..strokeWidth = strokeWidth
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  Paint get _fill => Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  Offset _center(Size size) => Offset(size.width / 2, size.height / 2);

  void _ring(Canvas canvas, Size size, {required int segments}) {
    final rect = Offset.zero & size;
    final paint = _paint;
    canvas.drawCircle(
      _center(size),
      size.shortestSide / 2 - strokeWidth,
      Paint()
        ..color = secondaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    for (var i = 0; i < segments; i++) {
      final start = (progress * math.pi * 2) + (i * math.pi * 2 / segments);
      canvas.drawArc(
        rect.deflate(strokeWidth),
        start,
        math.pi * .75,
        false,
        paint,
      );
    }
  }

  void _dots(
    Canvas canvas,
    Size size, {
    required int count,
    bool orbit = false,
  }) {
    final center = _center(size);
    final radius = size.shortestSide * (orbit ? .34 : .07);
    final dotRadius = size.shortestSide * .075;

    for (var i = 0; i < count; i++) {
      final phase = (progress + i / count) % 1;
      final opacity = (.25 + .75 * math.sin(phase * math.pi)).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      final offset = orbit
          ? Offset(
              center.dx + math.cos(phase * math.pi * 2) * radius,
              center.dy + math.sin(phase * math.pi * 2) * radius,
            )
          : Offset(
              size.width * (.25 + i * (.5 / math.max(1, count - 1))),
              center.dy + math.sin(phase * math.pi * 2) * size.height * .08,
            );
      canvas.drawCircle(offset, dotRadius * (.65 + opacity * .35), paint);
    }
  }

  void _bars(Canvas canvas, Size size, {required int count}) {
    final width = size.width / (count * 2 - 1);
    for (var i = 0; i < count; i++) {
      final phase = (progress + i / count) % 1;
      final height =
          size.height * (.25 + .65 * math.sin(phase * math.pi).abs());
      final left = i * width * 2;
      final top = (size.height - height) / 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, width, height),
          Radius.circular(width),
        ),
        _fill,
      );
    }
  }

  void _wave(Canvas canvas, Size size, {required int count}) {
    final paint = _paint;
    final path = Path();

    for (var i = 0; i <= 80; i++) {
      final x = size.width * i / 80;
      final y =
          size.height / 2 +
          math.sin((i / 80 * math.pi * count) + progress * math.pi * 2) *
              size.height *
              .22;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _pulse(Canvas canvas, Size size, {bool secondCircle = false}) {
    final center = _center(size);
    final radius = size.shortestSide * (.15 + progress * .35);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withValues(alpha: 1 - progress)
        ..style = PaintingStyle.fill,
    );

    if (secondCircle) {
      final phase = (progress + .5) % 1;
      canvas.drawCircle(
        center,
        size.shortestSide * (.15 + phase * .35),
        Paint()
          ..color = color.withValues(alpha: 1 - phase)
          ..style = PaintingStyle.fill,
      );
    }
  }

  void _ripple(Canvas canvas, Size size, {required int rings}) {
    final center = _center(size);
    for (var i = 0; i < rings; i++) {
      final phase = (progress + i / rings) % 1;
      canvas.drawCircle(
        center,
        size.shortestSide * .45 * phase,
        Paint()
          ..color = color.withValues(alpha: 1 - phase)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }
  }

  void _arcLines(Canvas canvas, Size size, {required int lines}) {
    final center = _center(size);
    final radius = size.shortestSide * .42;

    for (var i = 0; i < lines; i++) {
      final phase = (i / lines + progress) % 1;
      final angle = phase * math.pi * 2;
      final opacity = (i + 1) / lines;
      final paint = _paint..color = color.withValues(alpha: opacity);
      canvas.drawLine(
        Offset(
          center.dx + math.cos(angle) * radius * .62,
          center.dy + math.sin(angle) * radius * .62,
        ),
        Offset(
          center.dx + math.cos(angle) * radius,
          center.dy + math.sin(angle) * radius,
        ),
        paint,
      );
    }
  }

  void _squares(Canvas canvas, Size size, {required int count}) {
    final cell = size.shortestSide / 3;
    final center = _center(size);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * math.pi * 2);

    for (var i = 0; i < count; i++) {
      final angle = i * math.pi * 2 / count;
      final offset = Offset(math.cos(angle), math.sin(angle)) * cell * .75;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: offset,
            width: cell * .45,
            height: cell * .45,
          ),
          Radius.circular(cell * .08),
        ),
        _fill,
      );
    }

    canvas.restore();
  }

  void _grid(Canvas canvas, Size size, {required int columns}) {
    final gap = size.shortestSide * .06;
    final cell = (size.shortestSide - gap * (columns - 1)) / columns;

    for (var row = 0; row < columns; row++) {
      for (var col = 0; col < columns; col++) {
        final index = row * columns + col;
        final phase = (progress + index / (columns * columns)) % 1;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(col * (cell + gap), row * (cell + gap), cell, cell),
            Radius.circular(cell * .15),
          ),
          Paint()..color = color.withValues(alpha: .25 + .75 * phase),
        );
      }
    }
  }

  void _progress(Canvas canvas, Size size) {
    final current = (value ?? progress).clamp(0.0, 1.0);
    canvas.drawCircle(
      _center(size),
      size.shortestSide * .4,
      Paint()
        ..color = secondaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
    canvas.drawArc(
      (Offset.zero & size).deflate(strokeWidth),
      -math.pi / 2,
      current * math.pi * 2,
      false,
      _paint,
    );
  }

  void _orbit(Canvas canvas, Size size) {
    _ring(canvas, size, segments: 1);
    final center = _center(size);
    final angle = progress * math.pi * 2;
    canvas.drawCircle(
      Offset(
        center.dx + math.cos(angle) * size.width * .32,
        center.dy + math.sin(angle) * size.height * .32,
      ),
      size.shortestSide * .08,
      _fill,
    );
  }

  void _radar(Canvas canvas, Size size) {
    _ripple(canvas, size, rings: 3);
    final center = _center(size);
    final angle = progress * math.pi * 2;
    canvas.drawLine(
      center,
      Offset(
        center.dx + math.cos(angle) * size.width * .42,
        center.dy + math.sin(angle) * size.height * .42,
      ),
      _paint,
    );
  }

  void _wifi(Canvas canvas, Size size) {
    final paint = _paint;
    final center = Offset(size.width / 2, size.height * .72);
    for (var i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.shortestSide * .16 * i),
        math.pi * 1.18,
        math.pi * .64,
        false,
        paint
          ..color = color.withValues(
            alpha: ((progress + i / 3) % 1).clamp(.25, 1),
          ),
      );
    }
    canvas.drawCircle(center, size.shortestSide * .04, _fill);
  }

  void _infinity(Canvas canvas, Size size) {
    final path = Path();
    for (var i = 0; i <= 120; i++) {
      final t = i / 120 * math.pi * 2;
      final x = size.width / 2 + math.sin(t) * size.width * .35;
      final y =
          size.height / 2 +
          math.sin(t * 2 + progress * math.pi * 2) * size.height * .18;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, _paint);
  }

  void _hourGlass(Canvas canvas, Size size) {
    final paint = _paint;
    final rect = (Offset.zero & size).deflate(strokeWidth * 2);
    final path = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.right, rect.bottom)
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.bottom);
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(progress * math.pi);
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _liquid(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth);
    canvas.drawCircle(_center(size), size.shortestSide * .42, _paint);
    final fillHeight = size.height * (.25 + .5 * progress);
    canvas.clipPath(Path()..addOval(rect));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - fillHeight, size.width, fillHeight),
      _fill,
    );
  }

  void _shimmerLine(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height * .38, size.width, size.height * .24),
      Radius.circular(size.height * .12),
    );
    canvas.drawRRect(rect, Paint()..color = secondaryColor);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * progress - size.width * .25,
        0,
        size.width * .25,
        size.height,
      ),
      Paint()..color = color.withValues(alpha: .35),
    );
  }

  void _shimmerCard(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(size.shortestSide * .08),
      ),
      Paint()..color = secondaryColor,
    );
    _shimmerLine(canvas, size);
  }

  void _skeletonList(Canvas canvas, Size size) {
    for (var i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            0,
            i * size.height * .24,
            size.width * (.65 + .08 * (i % 2)),
            size.height * .12,
          ),
          Radius.circular(size.height * .05),
        ),
        Paint()
          ..color = i.isEven ? color.withValues(alpha: .28) : secondaryColor,
      );
    }
  }

  void _skeletonProfile(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width * .23, size.height * .28),
      size.shortestSide * .16,
      Paint()..color = secondaryColor,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .45,
          size.height * .18,
          size.width * .45,
          size.height * .11,
        ),
        const Radius.circular(6),
      ),
      Paint()..color = color.withValues(alpha: .25),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .45,
          size.height * .38,
          size.width * .32,
          size.height * .09,
        ),
        const Radius.circular(6),
      ),
      Paint()..color = secondaryColor,
    );
  }

  void _arrow(Canvas canvas, Size size, {required bool up}) {
    _progress(canvas, size);
    final center = _center(size);
    final direction = up ? -1.0 : 1.0;
    final path = Path()
      ..moveTo(center.dx, center.dy + direction * size.height * .23)
      ..lineTo(center.dx, center.dy - direction * size.height * .2)
      ..moveTo(
        center.dx - size.width * .14,
        center.dy - direction * size.height * .06,
      )
      ..lineTo(center.dx, center.dy - direction * size.height * .2)
      ..lineTo(
        center.dx + size.width * .14,
        center.dy - direction * size.height * .06,
      );
    canvas.drawPath(path, _paint);
  }

  void _steps(Canvas canvas, Size size) {
    final count = 4;
    for (var i = 0; i < count; i++) {
      canvas.drawCircle(
        Offset(size.width * (.15 + i * .23), size.height / 2),
        size.shortestSide * .07,
        Paint()..color = i / count <= progress ? color : secondaryColor,
      );
    }
  }

  void _route(Canvas canvas, Size size) {
    final paint = _paint;
    final path = Path()
      ..moveTo(size.width * .18, size.height * .78)
      ..quadraticBezierTo(
        size.width * .5,
        size.height * .15,
        size.width * .82,
        size.height * .78,
      );
    canvas.drawPath(path, paint);
    _dots(canvas, size, count: 2, orbit: true);
  }

  void _page(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      size.width * .22,
      size.height * .12,
      size.width * .56,
      size.height * .76,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      _paint,
    );
    canvas.drawLine(
      Offset(rect.left + 6, rect.top + 10),
      Offset(rect.right - 6, rect.top + 10),
      _paint,
    );
    canvas.drawLine(
      Offset(rect.left + 6, rect.top + 20),
      Offset(rect.right - 12, rect.top + 20),
      _paint,
    );
  }

  void _image(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      size.width * .16,
      size.height * .2,
      size.width * .68,
      size.height * .6,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      _paint,
    );
    canvas.drawCircle(
      Offset(rect.left + rect.width * .25, rect.top + rect.height * .28),
      size.shortestSide * .06,
      _fill,
    );
    canvas.drawLine(
      Offset(rect.left + 6, rect.bottom - 8),
      Offset(rect.center.dx, rect.center.dy),
      _paint,
    );
    canvas.drawLine(
      Offset(rect.center.dx, rect.center.dy),
      Offset(rect.right - 6, rect.bottom - 8),
      _paint,
    );
  }

  void _search(Canvas canvas, Size size) {
    final center = Offset(size.width * .44, size.height * .42);
    canvas.drawCircle(center, size.shortestSide * .18, _paint);
    canvas.drawLine(
      Offset(center.dx + size.width * .13, center.dy + size.height * .13),
      Offset(size.width * .78, size.height * .78),
      _paint,
    );
  }

  void _payment(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      size.width * .12,
      size.height * .26,
      size.width * .76,
      size.height * .48,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      _paint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.top + rect.height * .28),
      Offset(rect.right, rect.top + rect.height * .28),
      _paint,
    );
    _dots(canvas, size, count: 3);
  }

  void _success(Canvas canvas, Size size) {
    _progress(canvas, size);
    final center = _center(size);
    final path = Path()
      ..moveTo(center.dx - size.width * .18, center.dy)
      ..lineTo(center.dx - size.width * .04, center.dy + size.height * .15)
      ..lineTo(center.dx + size.width * .22, center.dy - size.height * .18);
    canvas.drawPath(path, _paint);
  }

  void _hexagonSpin(Canvas canvas, Size size) {
    final center = _center(size);

    canvas.save();

    canvas.translate(center.dx, center.dy);

    canvas.rotate(progress * math.pi * 2);

    final path = Path();

    final radius = size.shortestSide * .35;

    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i;

      final point = Offset(math.cos(angle) * radius, math.sin(angle) * radius);

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();

    canvas.drawPath(path, _paint);

    canvas.restore();
  }

  void apple(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.shortestSide * .34;

    for (int i = 0; i < 12; i++) {
      final angle = (math.pi * 2 / 12) * i;

      final opacity = ((i + progress * 12) % 12) / 12;

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth;

      final start = Offset(
        center.dx + math.cos(angle) * radius * .55,
        center.dy + math.sin(angle) * radius * .55,
      );

      final end = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      canvas.drawLine(start, end, paint);
    }
  }

  void _googleMaterial(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth);

    // Background circle
    canvas.drawCircle(
      _center(size),
      size.shortestSide / 2 - strokeWidth,
      Paint()
        ..color = secondaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rotation = progress * math.pi * 2;

    final sweep =
        (0.25 + 0.55 * math.sin(progress * math.pi)).clamp(0.15, 0.85) *
        math.pi *
        2;

    canvas.drawArc(rect, rotation - math.pi / 2, sweep, false, paint);
  }

  void _liquidSpinner(Canvas canvas, Size size) {
    final center = _center(size);
    final radius = size.shortestSide * .42;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = secondaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );

    final level = .55 + math.sin(progress * math.pi * 2) * .08;

    final waveHeight = size.height * .05;

    final path = Path();

    final top = size.height * level;

    path.moveTo(0, top);

    for (double x = 0; x <= size.width; x++) {
      final y =
          top +
          math.sin((x / size.width) * math.pi * 2 + progress * math.pi * 4) *
              waveHeight;

      path.lineTo(x, y);
    }

    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    canvas.restore();
    final angle = progress * math.pi * 2;

    final bubble = Offset(
      center.dx + math.cos(angle) * radius * .55,
      center.dy + math.sin(angle) * radius * .55,
    );

    canvas.drawCircle(
      bubble,
      size.shortestSide * .06,
      Paint()
        ..color = Colors.white.withValues(alpha: .7)
        ..style = PaintingStyle.fill,
    );
  }

  void _dnaLoader(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = secondaryColor
      ..strokeWidth = strokeWidth * .6
      ..strokeCap = StrokeCap.round;

    const count = 12;

    final spacing = size.height / (count - 1);

    final amplitude = size.width * .22;

    for (int i = 0; i < count; i++) {
      final t = i / (count - 1);

      final angle = progress * math.pi * 2 + t * math.pi * 2;

      final x1 = size.width / 2 + math.sin(angle) * amplitude;

      final x2 = size.width / 2 - math.sin(angle) * amplitude;

      final y = spacing * i;
      canvas.drawLine(Offset(x1, y), Offset(x2, y), linePaint);

      final alpha = (.4 + .6 * math.cos(angle).abs()).clamp(.0, 1.0);
      paint.color = color.withValues(alpha: alpha);

      canvas.drawCircle(Offset(x1, y), size.shortestSide * .045, paint);
      paint.color = color.withValues(alpha: 1 - alpha * .35);

      canvas.drawCircle(Offset(x2, y), size.shortestSide * .045, paint);
    }
  }

  void _orbitAtom(Canvas canvas, Size size) {
    final center = _center(size);
    final radius = size.shortestSide * .33;

    final orbitPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * .7;

    final electronPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.shortestSide * .07, electronPaint);

    for (int i = 0; i < 3; i++) {
      canvas.save();

      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * math.pi / 3);
      canvas.rotate(progress * math.pi * 2);

      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: radius * 2,
        height: radius * .9,
      );
      canvas.drawOval(rect, orbitPaint);
      final angle = progress * math.pi * 2 + i * math.pi * .8;

      final electron = Offset(
        math.cos(angle) * radius,
        math.sin(angle) * radius * .45,
      );

      canvas.drawCircle(electron, size.shortestSide * .045, electronPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ProLoaderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.type != type ||
        oldDelegate.color != color ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.value != value;
  }
}
