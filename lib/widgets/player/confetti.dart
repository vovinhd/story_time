// stolen from https://github.com/flutter/games/tree/main/templates/basic 


import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

class Confetti extends StatefulWidget {
  const new({
    super.key,
    this.colors = _defaultColors, 
    this.isStopped = false, required this.ttl 
  });

  static const _defaultColors = [
    Color(0xffd10841),
    Color(0xff1d75fb),
    Color(0xff0050bc),
    Color(0xffa2dcc7),
  ]; 

  final Duration ttl; 
  final bool isStopped; 
  final List<Color> colors; 

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ConfettiPainter(colors: widget.colors, animation: _controller),
      willChange: true,
      child: const SizedBox.expand()
    );
  }

  @override
  void didUpdateWidget(covariant Confetti oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isStopped && !widget.isStopped) { 
      _controller.repeat(); 
    } else if (!oldWidget.isStopped && widget.isStopped) {
      _controller.stop(canceled: false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration:  widget.ttl); 

    if(!widget.isStopped) {
      _controller.repeat(); 
    }
  }

}

class ConfettiPainter extends CustomPainter {

  final defaultPainter = Paint();
  final int particleCount = 200; 

  late final List<_Particle> _particles; 

  Size? _size; 
  DateTime _lastFrame = DateTime.now(); 

  final UnmodifiableListView<Color> colors; 

  new({
    required Listenable animation, required Iterable<Color> colors
  }) : colors = UnmodifiableListView(colors), super(repaint: animation); 


  @override
  void paint(Canvas canvas, Size size) {
    if (_size == null ) {
      // print(size); 
      _particles = List.generate(particleCount, (i) {
        return _Particle(bounds: size, color: colors[i % colors.length]); 
      });
    }

    final didResize = _size !=null && _size != size; 
    final now = DateTime.now(); 
    final dt = now.difference(_lastFrame);

    for (final particle in _particles) {
      if (didResize) {
        particle.updateBounds(size);
      }
      particle.update(dt.inMilliseconds / 1000); 
      particle.draw(canvas);
    } 

    _size = size;
    _lastFrame = now; 
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class _ParticleConfig {

  static const backSideBlend = Color(0x70EEEEEE);
  static double baseRotationSpeed = 800; 
  static double additionalRotationSpeed = 800; 
  static double size = 7; 
  static double baseOscillationSpeed = .5; 
  static double additionalOscillationSpeed = 1.5; 

  static double xSpeed = 40; 
  static double baseYSpeed = 50; 
  static double additionalYSpeed = 60; 
  static int ttl = 10; //s
}

class _Particle {

  new({required this._bounds,required this.color}); 

  static const degToRad = pi / 180; 

  Size _bounds;

  final Color color;
  static const backSideBlend = _ParticleConfig.backSideBlend;
  late final Color backColor = Color.alphaBlend(backSideBlend, color);
  final paint = Paint()..style = PaintingStyle.fill;

  static final Random _random = Random(); 
  
  late Offset position = Offset(
    _random.nextDouble() * _bounds.width,
    - _random.nextDouble() * (_bounds.height*0.8) - 10,
  );
  late final double rotationSpeed = _ParticleConfig.baseRotationSpeed + _random.nextDouble() * _ParticleConfig.additionalRotationSpeed; 
  final double angle  = _random.nextDouble() * 360 * degToRad; 
  double rotation  = _random.nextDouble() * 360 * degToRad; 
  
  double cosA = 1.0; 
  final double size = _ParticleConfig.size; 
  final double oscillationSpeed = _ParticleConfig.baseOscillationSpeed + _random.nextDouble() * _ParticleConfig.additionalOscillationSpeed; 

  final double xSpeed = _ParticleConfig.xSpeed;
  final double ySpeed = _ParticleConfig.baseYSpeed + _random.nextDouble() * _ParticleConfig.additionalYSpeed; 

  double opacity = 1.0;  

  late List<Offset> corners = List.generate(4, (i) {
    final cornerAngle = angle + degToRad * (45 + i * 90);
    return Offset(cos(cornerAngle), sin(cornerAngle));
  });

  double time = _random.nextDouble(); 
  
  void draw(Canvas canvas){
      paint.color = cosA > 0 ? color : backColor; 
      paint.color = Color.from(alpha: opacity, red: paint.color.r, green: paint.color.g, blue: paint.color.b); 
      final path = Path()..addPolygon(List.generate(4, (index) => Offset(position.dx + corners[index].dx * size, position.dy + corners[index].dy * size)), true);
      canvas.drawPath(path, paint);  
  } 

  void update(double dt) { 
    time += dt; 
    rotation += rotationSpeed * dt; 
    cosA = cos(degToRad * rotation); 
    var x = cos(time * oscillationSpeed) * xSpeed * dt;
    var y = ySpeed * dt;
    // if (position.dy + y > _bounds.height) {
    //   position = Offset(_random.nextDouble() * _bounds.width, 0); 
    // } else {
    // }
      position = Offset(position.dx + x, position.dy + y);
    opacity = (_ParticleConfig.ttl - time);  
    print(opacity); 

    // print(position);
  }

  void updateBounds(Size newBounds) {
    if (!newBounds.contains(position)) {
      position = Offset(
        _random.nextDouble() * newBounds.width,
        _random.nextDouble() * newBounds.height,

      );
    }
    _bounds = newBounds;
  }
}