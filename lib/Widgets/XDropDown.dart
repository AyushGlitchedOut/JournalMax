import 'package:flutter/material.dart';

class XDropdown extends StatelessWidget {
  final String label;
  final List<String> list;
  final void Function(String value)? onchange;
  const XDropdown(
      {super.key, required this.label, required this.list, this.onchange});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
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
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              label,
              style: TextStyle(
                  color: colors.onPrimary,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: DropdownMenu(
                onSelected: (value) => onchange!(value ?? "angry"),
                textStyle: TextStyle(color: colors.onPrimary, fontSize: 20.0),
                initialSelection: list.first,
                leadingIcon: Icon(
                  Icons.arrow_drop_down,
                  color: colors.onPrimary,
                ),
                dropdownMenuEntries: list
                    .map((item) => DropdownMenuEntry(label: item, value: item))
                    .toList()),
          )
        ]));
  }
}
