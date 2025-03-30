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
  final int providedEntryId;
  const ViewerPage({super.key, required this.providedEntryId});

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  bool isLoading = false;
  Map<String, Color> mood = EntryItemMoods.happy;
  Map<String, Object?> content = {};
  Widget contentToShow = Container();

  //Method to get and entry by provided Id and set the variables according to its data
  Future<void> getEntry() async {
    try {
      //start loading
      setState(() {
        isLoading = true;
      });

      //get the Entry by Id
      final res = await getEntryById(widget.providedEntryId);
      content = res.first;
      setMood(res.first["mood"].toString());

      //change the UI elements
      setState(() {
        contentToShow = SelectableText(
          content["content"].toString(),
          style: TextStyle(
              color: mood["secondary"],
              fontSize: 20.0,
              shadows: const [
                Shadow(
                    offset: Offset(1.5, 1.5), color: Colors.grey, blurRadius: 2)
              ]),
        );
        //stop loading
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  //method to pass to the dialog to change the shown widget
  void changeContent(Widget contentWidget) {
    setState(() {
      contentToShow = contentWidget;
    });
  }

  //method to change the mood
  void setMood(String Mood) {
    setState(() {
      mood = EntryItemMoods.nameToColor(Mood);
    });
  }

  @override
  void initState() {
    super.initState();
    //get Entry soon after loading the UI
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
          //button to open the dialog to select the content to view
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
          //Floating button to open editor page for editing the current entry
          icon: Icons.edit,
          onclick: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return EditorPage(
                createNewEntry: false,
                updateId: widget.providedEntryId,
              );
            }));
            await Future.delayed(const Duration(milliseconds: 250));
            getEntry();
            setState(() {});
          }),
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
        child: Column(
          crossAxisAlignment: contentToShow is SelectableText
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          //To not center the contents if its text (diary entry)
          mainAxisAlignment: contentToShow is SelectableText
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceAround,
          children: [
            isLoading ? XProgress(colors: colors) : contentToShow,
          ],
        ),
      ),
    ));
  }

  Container titleBar(BuildContext context, ColorScheme colors) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.060,
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
          maxLines: 1,
          content["title"].toString(),
          style: TextStyle(
              color: mood["text"],
              fontSize: 25.0,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.left,
        ));
  }
}
