// import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TikTokFavoriteAnimationIcon extends StatefulWidget {
  final Offset position;
  final double size;
  final Function onAnimationComplete;

  const TikTokFavoriteAnimationIcon({
    Key key,
    this.onAnimationComplete,
    this.position,
    this.size: 25,
  }) : super(key: key);

  @override
  _TikTokFavoriteAnimationIconState createState() =>
      _TikTokFavoriteAnimationIconState();
}

class _TikTokFavoriteAnimationIconState
    extends State<TikTokFavoriteAnimationIcon> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> animation;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      lowerBound: 0,
      upperBound: 1,
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = new Tween(begin: 0.0, end: 50.0).animate(_animationController)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    _animationController.addListener(() {
      setState(() {});
    });
    startAnimation();
    super.initState();
  }

  startAnimation() async {
    await _animationController.forward();
    widget.onAnimationComplete?.call();
  }

  double rotate = pi / 10.0 * (2 * Random().nextDouble() - 1);

  double get value => _animationController?.value;

  double appearDuration = 0.2;
  double dismissDuration = 0.3;

  double get opa {
    if (value < appearDuration) {
      return 0.99 / appearDuration * value;
    }
    if (value < dismissDuration) {
      return 0.99;
    }
    var res = 0.99 - (value - dismissDuration) / (1 - dismissDuration);
    return res < 0 ? 0 : res;
  }

  double get scale {
    if (value < appearDuration) {
      return 1 + appearDuration - value;
    }
    if (value < dismissDuration) {
      return 1;
    }
    return (value - dismissDuration) / (1 - dismissDuration) + 1;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Icon(
      Icons.favorite,
      size: widget.size,
      color: Colors.redAccent,
    );
    content = ShaderMask(
      child: content,
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) => RadialGradient(
        center: Alignment.topLeft.add(Alignment(0.66, 0.66)),
        colors: [
          Color(0xffEF6F6F),
          Color(0xffF03E3E),
        ],
      ).createShader(bounds),
    );
    Widget body = Transform.rotate(
      angle: rotate,
      child: Opacity(
        opacity: opa,
        child: Transform.scale(
          alignment: Alignment.bottomCenter,
          scale: scale,
          child: content,
        ),
      ),
    );
    return widget.position == null
        ? Container()
        : Positioned(
            left: widget.position.dx - widget.size / 2,
            // top: widget.position.dy - widget.size,
    bottom:  animation.value,
            child: body,
          );
  }
}
