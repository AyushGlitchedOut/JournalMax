import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class XSearchBar extends StatelessWidget {
  //the function to execute
  final void Function(String query) searchFunction;
  final TextEditingController controller;
  final FocusNode? focus;

  const XSearchBar(
      {super.key,
      required this.searchFunction,
      required this.controller,
      this.focus});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
              color: colors.primary,
              offset: const Offset(-1.5, -1.5),
              blurRadius: 1.0),
          BoxShadow(
              color: colors.shadow,
              offset: const Offset(2.0, 2.0),
              blurRadius: 1.0),
        ],
      ),
      child: Row(
        children: [
          searchBarField(colors),
          const SizedBox(
            width: 15.0,
          ),
          searchBarButton(colors)
        ],
      ),
    );
  }

//The InputField (SearchBar) in which query is put
  Expanded searchBarField(ColorScheme colors) {
    return Expanded(
      child: SearchBar(
        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        onChanged: searchFunction,
        controller: controller,
        focusNode: focus,
        onSubmitted: searchFunction,
        textStyle: WidgetStatePropertyAll(TextStyle(
            color: colors.primary,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            decorationColor: Colors.transparent)),
        hintStyle: WidgetStatePropertyAll(TextStyle(
            color: colors.secondary,
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
            decorationColor: Colors.transparent)),
        hintText: "Type the title of Entry.....",
      ),
    );
  }

  //The button that triggers the searh method
  IconButton searchBarButton(ColorScheme colors) {
    return IconButton(
      padding: const EdgeInsets.all(5.0),
      onPressed: () => searchFunction(controller.text),
      style: ButtonStyle(
          shadowColor: WidgetStatePropertyAll(colors.shadow),
          backgroundColor: WidgetStatePropertyAll(colors.onSurface),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              side: const BorderSide(),
              borderRadius: BorderRadius.circular(10.0)))),
      icon: Icon(
        CupertinoIcons.search,
        size: 40.0,
        color: colors.onPrimary,
        shadows: [
          BoxShadow(
              color: colors.primary,
              offset: const Offset(-1.5, -1.5),
              blurRadius: 1.0),
          BoxShadow(
              color: colors.shadow,
              offset: const Offset(2.0, 2.0),
              blurRadius: 1.0)
        ],
      ),
    );
  }
}
