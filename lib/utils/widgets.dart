import 'package:flutter/cupertino.dart';

class OnHover extends StatefulWidget {
  final Widget? child;

  const OnHover({Key? key, this.child}) : super(key: key);

  @override
  State<OnHover> createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hovered = Matrix4.identity()..translate(0, -10, 0);
    final transform = isHovered ? hovered : Matrix4.identity();
    return MouseRegion(
      onEnter: (_) => setHovered(true),
      onExit: (_) => setHovered(false),
      child: AnimatedContainer(
        child: widget.child,
        transform: transform,
        duration: const Duration(
          milliseconds: 300,
        ),
      ),
    );
  }

  void setHovered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
