import 'package:flutter/material.dart';

class XIconLabelButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onclick ?? () {},
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
          children: [
            Icon(
              icon,
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
                label,
                style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: customFontSize ?? 20.0,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
