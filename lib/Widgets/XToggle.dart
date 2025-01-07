import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class XToggle extends StatefulWidget {
  final String title;
  final bool value;
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
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => widget.onclick!(widget.value),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: colors.onSurface,
            // border: Border.all(
            //   color: colors.outline,
            // ),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: colors.primary, offset: const Offset(-1.5, -1.5)),
              BoxShadow(color: colors.shadow, offset: const Offset(1.5, 1.5))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Text(
                widget.title,
                style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: widget.customFontSize ?? 22.0,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500),
              ),
            ),
            CupertinoSwitch(
              value: widget.value,
              onChanged: (value) => widget.onclick!(value),
              inactiveTrackColor: colors.onPrimary,
            )
          ],
        ),
      ),
    );
  }
}
