import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class XToggle extends StatefulWidget {
  final String title;
  final bool value;
  //take custom font size if the text is long
  final double? customFontSize;
  final void Function(bool onclick)? onclick;
  const XToggle(
      {super.key,
      required this.title,
      required this.value,
      this.onclick,
      this.customFontSize});

  @override
  State<XToggle> createState() => _XToggleState();
}

class _XToggleState extends State<XToggle> {
  double buttonOpacity = 1.0;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => widget.onclick!(widget.value),
      //to change opacity for animation on Tap up and down
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
      //Animated Opacity to simulate the clicking effect
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: buttonOpacity,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: const [0.7, 0.95],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors.onSurface, Colors.grey]),
              color: colors.onSurface,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                    color: colors.primary, offset: const Offset(-1.5, -1.5)),
                BoxShadow(color: colors.outline, offset: const Offset(1.5, 1.5))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //The label for text
              Padding(
                padding: const EdgeInsets.only(left: 7.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      color: colors.onPrimary,
                      fontSize: widget.customFontSize ?? 22.0,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(
                            offset: Offset(1.5, 1.5),
                            color: Colors.grey,
                            blurRadius: 2)
                      ]),
                ),
              ),
              //the actual switch
              CupertinoSwitch(
                value: widget.value,
                onChanged: (value) => widget.onclick!(value),
                inactiveTrackColor: colors.onPrimary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
