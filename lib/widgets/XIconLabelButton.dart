import 'package:flutter/material.dart';

// ignore: must_be_immutable
class XIconLabelButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final void Function()? onclick;
  final double? customFontSize;
  const XIconLabelButton(
      {super.key,
      required this.icon,
      required this.label,
      this.onclick,
      this.customFontSize});

  @override
  State<XIconLabelButton> createState() => _XIconLabelButtonState();
}

class _XIconLabelButtonState extends State<XIconLabelButton> {
  double buttonOpacity = 1.0;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: widget.onclick ?? () {},
      onTapDown: (details) {
        setState(() {
          buttonOpacity = 0.8;
        });
      },
      onTapUp: (details) {
        setState(() {
          buttonOpacity = 1.0;
        });
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: buttonOpacity,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: colors.onSurface,
              gradient: LinearGradient(
                  stops: const [0.7, 0.9],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors.onSurface, Colors.grey]),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                    color: colors.primary, offset: const Offset(-1.5, -1.5)),
                BoxShadow(color: colors.outline, offset: const Offset(1.5, 1.5))
              ]),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: colors.onPrimary,
                shadows: [
                  Shadow(
                    color: colors.primary,
                    offset: const Offset(-1.0, -1.0),
                  ),
                  Shadow(
                    color: colors.shadow,
                    offset: const Offset(1.0, 1.0),
                  )
                ],
                size: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.label,
                  style: TextStyle(
                      color: colors.onPrimary,
                      fontSize: widget.customFontSize ?? 20.0,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
