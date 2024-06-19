import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/MySubjects.dart';
import '../../models/SchemeWorkItemModel.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../students/PdfViewer.dart';
import 'SchemeItemWorkCreateScreen.dart';

//SubjectSchemeWorkScreen
class SubjectSchemeWorkScreen extends StatefulWidget {
  MySubjects item;

  SubjectSchemeWorkScreen(this.item, {super.key});

  @override
  SubjectSchemeWorkScreenState createState() =>
      SubjectSchemeWorkScreenState();
}

class SubjectSchemeWorkScreenState extends State<SubjectSchemeWorkScreen> {
  Future<void> submit_form() async {
    init();
    return;
  }

  String error_message = "";
  bool is_loading = false;
  bool hasOnGoingTrip = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              iconSize: 30,
              onPressed: () async {
                Get.to(() => PdfViewerScreen(
                    widget.item.getPdf(), 'Termly Report Card'));
                //await init();
              },
            ),],
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleMedium(
                '${widget.item.subject_name} - ${widget.item.name},  Scheme Work',
                color: Colors.white,
                fontWeight: 700,
                maxLines: 2,
                height: 1,
              ),
              const SizedBox(
                height: 2,
              ),
              FxText.titleSmall(
                'Found ${works.length} items found.',
                color: Colors.white,
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (hasOnGoingTrip) {
            Utils.toast2('There is still ongoing trip.',
                background_color: CustomTheme.red);
            return;
          }
          //show bottom sheet asking for create new trip
          showModalBottomSheet(
              context: context,
              builder: (BuildContext buildContext) {
                return Container(
                  color: Colors.transparent,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          onTap: () async {
                            //pop
                            Navigator.pop(context);
                            SchemeWorkItemModel m = SchemeWorkItemModel();
                            m.subject_id = widget.item.id.toString();
                            m.subject_text =
                                "${widget.item.subject_name} - ${widget.item.name}";

                            await Get.to(() => SchemeItemWorkCreateScreen(m));
                            init();
                          },
                          leading: Icon(
                            FeatherIcons.plus,
                            color: CustomTheme.primary,
                            size: 26,
                          ),
                          title: FxText.titleLarge(
                            "Add new scheme-work item",
                            fontSize: 20,
                            fontWeight: 800,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await init();
              },
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        SchemeWorkItemModel m = works[index];

                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                //Get.to(() => SubjectSchemeWorkScreen(m));
                                //show popup menu
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext buildContext) {
                                      return Container(
                                        color: Colors.transparent,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 10,
                                          ),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight:
                                                      Radius.circular(16))),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ListTile(
                                                onTap: () async {
                                                  //pop
                                                  Navigator.pop(context);
                                                  m.subject_text =
                                                      widget.item.subject_name;
                                                  await Get.to(() =>
                                                      SchemeItemWorkCreateScreen(
                                                          m));
                                                  init();
                                                },
                                                leading: Icon(
                                                  FeatherIcons.edit,
                                                  color: CustomTheme.primary,
                                                  size: 26,
                                                ),
                                                title: FxText.titleLarge(
                                                  "Edit scheme-work item",
                                                  fontSize: 20,
                                                  fontWeight: 800,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ListTile(
                                                onTap: () async {
                                                  //pop
                                                  m.subject_text =
                                                      widget.item.subject_name;
                                                  Navigator.pop(context);
                                                  await m.delete();
                                                  init();
                                                },
                                                leading: Icon(
                                                  FeatherIcons.trash,
                                                  color: CustomTheme.red,
                                                  size: 26,
                                                ),
                                                title: FxText.titleLarge(
                                                  "Delete scheme-work item",
                                                  fontSize: 20,
                                                  fontWeight: 800,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              leading: Icon(
                                FeatherIcons.bookOpen,
                                color: CustomTheme.primary,
                                size: 26,
                              ),
                              title: FxText(
                                m.topic,
                                fontSize: 16,
                                fontWeight: 600,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FxText.bodyMedium("WEEK: ${m.week},"
                                          "\nperiod: ${m.period},"
                                      .toUpperCase()),
                                  FxText.bodySmall(
                                    "STATUS: ${m.teacher_status}",
                                    color: Colors.black,
                                    fontWeight: 900,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 1,
                            ),
                          ],
                        );
                      },
                      childCount: works.length, // 1000 list items
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<SchemeWorkItemModel> works = [];
  Future<void> init() async {
    works = await SchemeWorkItemModel.get_items(
        where: ' subject_id = ${widget.item.id} ');
    setState(() {});
  }
}
