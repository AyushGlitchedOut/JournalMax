import 'package:flutter/material.dart';

void showSnackBar(String message, BuildContext context) {
  final ColorScheme colors = Theme.of(context).colorScheme;
  OverlayEntry? overLayEntry;

  //Custom SnackBar using Overlay
  overLayEntry = OverlayEntry(builder: (BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width * 0.22,
              horizontal: 10.0),
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      stops: const [0.9, 1],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colors.onPrimary, colors.tertiary]),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: colors.primary,
                        offset: const Offset(-1.5, -1.5)),
                    BoxShadow(
                        color: colors.outline, offset: const Offset(1.5, 1.5))
                  ],
                  border: Border.all(color: colors.outline),
                  color: colors.onPrimary),
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      Center(
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: colors.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                          child: Text(
                            message,
                            style: TextStyle(
                              color: colors.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        overLayEntry?.remove();
                        overLayEntry?.dispose();
                        overLayEntry = null;
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: colors.primary,
                      ))
                ],
              )),
        ),
      ),
    );
  });

  //insert the overlay
  Overlay.of(
    context,
  ).insert(overLayEntry ??
      OverlayEntry(builder: (BuildContext context) {
        return Container();
      }));

  Future.delayed(const Duration(milliseconds: 1500), () {
    overLayEntry?.remove();
    overLayEntry?.dispose();
    overLayEntry = null;
  });
  return;
}
