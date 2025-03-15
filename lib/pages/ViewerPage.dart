import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journalmax/models/EntryItemMoods.dart';
import 'package:journalmax/widgets/dialogs/ViewPageContentDialog.dart';
import 'package:journalmax/pages/EditorPage.dart';
import 'package:journalmax/widgets/XAppBar.dart';
import 'package:journalmax/widgets/XDrawer.dart';
import 'package:journalmax/widgets/XFloatingButton.dart';
import 'package:journalmax/widgets/XIconLabelButton.dart';
import 'package:journalmax/widgets/XProgress.dart';
import 'package:journalmax/widgets/XSnackBar.dart';
import 'package:journalmax/services/DataBaseService.dart';

// ignore: must_be_immutable
class ViewerPage extends StatefulWidget {
  final int Id;
  const ViewerPage({super.key, required this.Id});

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  bool isLoading = false;
  Map<String, Color> mood = EntryItemMoods.happy;
  Map<String, Object?> content = {};
  Widget contentToShow = Container();

  //READ
  Future<void> getEntry() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (kDebugMode) print('Id:${widget.Id}');
      final res = await getEntryById(widget.Id);
      content = res.first;
      setMood(res.first["mood"].toString());
      setState(() {
        contentToShow = SelectableText(
          content["content"].toString(),
          style: TextStyle(color: mood["secondary"], fontSize: 20.0),
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  //UI

  void changeContent(Widget contentWidget) {
    setState(() {
      contentToShow = contentWidget;
    });
  }

  void setMood(String Mood) {
    setState(() {
      mood = EntryItemMoods.nameToColor(Mood);
    });
  }

  @override
  void initState() {
    super.initState();
    getEntry();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_conditional_assignment
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: XAppBar(
            title: "View Entry",
          )),
      drawer: const XDrawer(
        currentPage: "view",
      ),
      backgroundColor: colors.surface,
      body: Column(
        children: [
          titleBar(context, colors),
          contentBox(context, colors),
          XIconLabelButton(
            icon: Icons.collections,
            label: "View memories in the Entry",
            customFontSize: 16.0,
            onclick: () {
              viewPageContentDialog(
                  context, colors, changeContent, content, mood);
            },
          )
        ],
      ),
      floatingActionButton: XFloatingButton(
          icon: Icons.edit,
          //pass arguments later
          onclick: () => Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return EditorPage(
                  createNewEntry: false,
                  updateId: widget.Id,
                );
              }))),
    );
  }

  Expanded contentBox(BuildContext context, ColorScheme colors) {
    return Expanded(
        child: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: colors.outline),
          color: mood["surface"] ?? colors.surface,
          boxShadow: [
            BoxShadow(
                color: mood["text"] ?? colors.shadow,
                offset: const Offset(1.5, 1.5)),
            BoxShadow(
                color: mood["secondary"] ?? colors.outline,
                offset: const Offset(-1.5, -1.5))
          ],
          borderRadius: BorderRadius.circular(0)),
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.all(2.0),
      child: SingleChildScrollView(
          child: isLoading ? XProgress(colors: colors) : contentToShow),
    ));
  }

  Container titleBar(BuildContext context, ColorScheme colors) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: colors.outline),
            color: mood["surface"] ?? colors.surface,
            boxShadow: [
              BoxShadow(
                  color: mood["text"] ?? colors.shadow,
                  offset: const Offset(1.5, 1.5)),
              BoxShadow(
                  color: mood["secondary"] ?? colors.outline,
                  offset: const Offset(-1.5, -1.5))
            ],
            borderRadius: BorderRadius.circular(0)),
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.all(2.0),
        child: SelectableText(
          content["title"].toString(),
          style: TextStyle(
              color: mood["text"],
              fontSize: 30.0,
              overflow: TextOverflow.ellipsis),
          textAlign: TextAlign.left,
        ));
  }
}
