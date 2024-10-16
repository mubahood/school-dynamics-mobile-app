import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/MyClasses.dart';
import '../../models/UserModel.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';
import 'FinancialAccountScreen.dart';

class FinancialAccountsScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  FinancialAccountsScreen(this.params, {Key? key}) : super(key: key);

  @override
  FinancialAccountsScreenState createState() =>
      new FinancialAccountsScreenState();
}

class FinancialAccountsScreenState extends State<FinancialAccountsScreen> {
  List<UserModel> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh(isRefresh: true);
  }

  Future<dynamic> doRefresh1() async {
    doRefresh(isRefresh: true);
  }

  Future<dynamic> doRefresh({bool isRefresh = false}) async {
    futureInit = init(isRefresh: isRefresh);
    setState(() {});
  }

  late Future<dynamic> futureInit;

  bool searchIsopen = false;
  String searchKeyWord = "";
  TextEditingController search_controler = new TextEditingController();
  var searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        // remove back button in appbar.
        title: searchIsopen
            ? FxContainer(
                color: Colors.white,
                padding: EdgeInsets.only(left: 10, top: 8, bottom: 8),
                child: FormBuilderTextField(
                  name: "search",
                  onChanged: (x) {
                    setState(() {
                      searchKeyWord = x.toString();
                    });
                    doRefresh();
                  },
                  decoration: InputDecoration(
                    hintText: "Search ...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(MySize.size8!),
                        ),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(MySize.size8!),
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(MySize.size8!),
                        ),
                        borderSide: BorderSide.none),
                    isDense: true,
                    contentPadding: EdgeInsets.all(0),
                  ),
                  controller: search_controler,
                  focusNode: searchFocusNode,
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.name,
                ),
              )
            : FxText.titleLarge(
          'Financial Accounts',
                color: Colors.white,
                fontWeight: 700,
              ),
        actions: [
          InkWell(
            onTap: () {
              searchKeyWord = "";
              setState(() {
                searchIsopen = !searchIsopen;
                if (searchIsopen) {
                  searchFocusNode.requestFocus();
                } else {
                  searchFocusNode.unfocus();
                }
              });
              doRefresh();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 10),
              child: Icon(
                searchIsopen ? FeatherIcons.x : FeatherIcons.search,
                color: Colors.white,
              ),
            ),
          ),
          searchIsopen
              ? SizedBox()
              : InkWell(
                  onTap: () {
                    showShareBottomSheet();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 20),
                    child: Icon(
                      FeatherIcons.share2,
                      color: Colors.white,
                    ),
                  ),
                ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return myListLoaderWidget(context);
              }
              if (items.isEmpty) {
                return Center(
                    child: Column(
                  children: [
                    const Spacer(),
                    FxText('No item found.'),
                    FxButton.text(
                      child: FxText(
                        'Reload',
                        color: CustomTheme.primary,
                      ),
                      onPressed: () {
                        doRefresh(isRefresh: true);
                      },
                    ),
                    const Spacer(),
                  ],
                ));
              }

              return Container(
                child: RefreshIndicator(
                  backgroundColor: Colors.white,
                  onRefresh: doRefresh1,
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              toolbarHeight: Get.width / 5,
                              backgroundColor:
                                  CupertinoColors.lightBackgroundGray,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FxContainer(
                                    color: CupertinoColors.lightBackgroundGray,
                                    borderRadiusAll: 0,
                                    padding: EdgeInsets.only(top: 8),
                                    child: Wrap(
                                      runSpacing: 0,
                                      children: <Widget>[
                                        _buildChip('All'),
                                        _buildChip('Male'),
                                        _buildChip('Female'),
                                        _buildChip(
                                            '${selected_class_text.isEmpty ? "Class" : 'Class - $selected_class_text'}'),
                                        _buildChip('Fees'),
                                        _buildChip(selected_verification.isEmpty
                                            ? "Verification"
                                            : selected_verification),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    color: CustomTheme.primary,
                                    height: 0,
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.only(bottom: 10, top: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              FxText.bodyLarge(
                                                "Found ",
                                                fontWeight: 800,
                                              ),
                                              FxText.bodyLarge(
                                                "${items.length} students",
                                                color: Colors.black,
                                                fontWeight: 800,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                              automaticallyImplyLeading: false,
                              floating: true,
                              elevation: 1,
                              leadingWidth: 0,
                              stretch: true,
                              shadowColor: CustomTheme.primary,
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  UserModel m = items[index];
                                  return InkWell(
                                      onTap: () {
                                        if (widget.params['isSelect'] == true) {
                                          Get.back(result: m);
                                          return;
                                        }
                                        Get.to(() =>
                                            FinancialAccountScreen(data: m));
                                      },
                                      child: accountWidget(m));
                                },
                                childCount: items.length, // 1000 list items
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 5,
                        color: CustomTheme.primary,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 15,
                          bottom: 5,
                          right: 15,
                        ),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            FxText.titleLarge(
                              'TOTAL:',
                              fontWeight: 800,
                              color: Colors.black,
                            ),
                            Spacer(),
                            Column(
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                FxText.bodySmall(
                                  'UGX',
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            FxText.titleLarge(
                              Utils.moneyFormat(balance.toString()),
                              fontWeight: 800,
                              color: balance < 0
                                  ? Colors.red.shade800
                                  : Colors.green.shade800,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  List<UserModel> originalItems = [];
  int balance = 0;
  int count = 0;
  String shared_data = "";
  String shared_records = "";
  String shared_filters = "";

  Future<void> init({bool isRefresh = false}) async {
    originalItems = await UserModel.getItems();
    if (isRefresh || originalItems.isEmpty) {
    }
    if (classes.isEmpty) {
      classes = await MyClasses.getItems();
    }
    items.clear();

    shared_records = "";
    shared_data = "SCHOOL FEES BALANCES";
    balance = 0;
    count = 0;
    String _word = "";
    for (UserModel element in originalItems) {
      if (searchKeyWord.isNotEmpty) {
        if (!element.name
            .toLowerCase()
            .contains(searchKeyWord.toString().toLowerCase().trim())) {
          continue;
        }
        _word = "\n*KEYWORD:* $searchKeyWord}";
        if (!shared_filters.contains(_word)) {
          shared_filters += _word;
        }
      }

      if (filteredParameters.contains('Male')) {
        if (element.sex != 'Male') {
          continue;
        }
        _word = '\n*GENDER:* Male';
        if (!shared_filters.contains(_word)) {
          shared_filters += _word;
        }
      }
      if (filteredParameters.contains('Female')) {
        if (element.sex != 'Female') {
          continue;
        }
        _word = '\n*GENDER:* FEMALE';
        if (!shared_filters.contains(_word)) {
          shared_filters += _word;
        }
      }
      if (selected_class_id.isNotEmpty) {
        if (element.current_class_id != selected_class_id) {
          continue;
        }
        _word = '\n*CLASS:* ${selected_class_text}';
        if (!shared_filters.contains(_word)) {
          shared_filters += _word;
        }
      }

      if (selected_verification.isNotEmpty) {
        if (selected_verification == 'Verified') {
          if (element.verification != '1') {
            continue;
          }
          _word = '\n*VERIFICATION:* Verified';
          if (!shared_filters.contains(_word)) {
            //shared_filters += _word;
          }
        }

        if (selected_verification == 'Not Verified') {
          if (element.verification != '0') {
            continue;
          }
          _word = '\n*VERIFICATION:* Not Verified';
          if (!shared_filters.contains(_word)) {
            //shared_filters += _word;
          }
        }
      }



      balance += element.balance;
      items.add(element);
    }

    if (feesSort.isNotEmpty) {
      if (feesSort == 'Asc') {
        items.sort((a, b) => a.balance.compareTo(b.balance));
      } else {
        items.sort((b, a) => a.balance.compareTo(b.balance));
      }
    } else {
      items.sort((a, b) => a.name.compareTo(b.name));
    }

    count = 0;
    for (var element in items) {
      count++;
      shared_records +=
          "\n*${count}. ${element.name}* - ${element.current_class_text}\n*BALANCE:* UGX ${Utils.moneyFormat(element.balance.toString())}\n";
    }

    shared_data += "\n\n*FILTERS*" +
        '${(shared_filters.isNotEmpty) ? shared_filters : "\nALL STUDENTS"}';

    shared_data += "\n\n*TOTAL:* UGX ${Utils.moneyFormat(balance.toString())}";
    shared_data += "\n*AS ON:* UGX ${Utils.to_date(DateTime.now().toString())}";

    shared_data += "\n\n*STUDENTS\' ACCOUNTS*";
    shared_data += shared_records;

    setState(() {});
  }

  List<String> filteredParameters = ['All'];

  addItemToFilter(String label) async {
    if (label == 'Male') {
      filteredParameters.remove('Female');
      if (filteredParameters.contains('Male')) {
        filteredParameters.remove('Male');
      } else {
        filteredParameters.add('Male');
      }
    }
    if (label == 'Female') {
      filteredParameters.remove('Male');
      if (filteredParameters.contains('Female')) {
        filteredParameters.remove('Female');
      } else {
        filteredParameters.add('Female');
      }
    }

    if (label.contains('Class')) {
      if (classes.isEmpty) {
        Utils.toast('Fetching classes...');
        classes = await MyClasses.getItems();
      }
      showBottomSheetAccountPicker();
      return;
    }

    if (label == 'Fees') {
      filteredParameters.remove('Fees');
      filteredParameters.add('Fees');
      if (feesSort == 'Asc') {
        feesSort = 'Desc';
      } else {
        feesSort = 'Asc';
      }
    }

    if (label.contains('Verif')) {
      if (selected_verification.isEmpty) {
        selected_verification = 'Verified';
      } else if (selected_verification == 'Verified') {
        selected_verification = 'Not Verified';
      } else {
        selected_verification = '';
      }
    }

    if (label != 'All') {
      filteredParameters.remove('All');
    } else {
      filteredParameters.clear();
      selected_class_id = "";
      feesSort = "";
      selected_class_text = "";
      filteredParameters.add('All');
    }

    setState(() {});
    doRefresh();
  }

  String feesSort = "";

  List<MyClasses> classes = [];

  String selected_class_id = "";
  String selected_class_text = "";
  String selected_verification = "";

  void showBottomSheetAccountPicker() {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MySize.size16!),
                topRight: Radius.circular(MySize.size16!),
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FxText.titleMedium(
                          'Filter by class',
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: const Icon(
                            FeatherIcons.x,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: classes.length,
                        itemBuilder: (context, position) {
                          MyClasses c = classes[position];
                          return ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              selected_class_id = c.id.toString();
                              selected_class_text = c.short_name.toString();
                              setState(() {});
                              doRefresh();
                            },
                            title: FxText.titleMedium(
                              c.name,
                              color: CustomTheme.primary,
                              maxLines: 1,
                              fontWeight: 700,
                            ),
                            subtitle: FxText.bodySmall(
                              c.short_name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            visualDensity: VisualDensity.compact,
                            dense: true,
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildChip(String label) {
    bool isSelected = false;
    if (filteredParameters.contains(label)) {
      isSelected = true;
    } else {
      isSelected = false;
    }
    if (label.contains('Class') && selected_class_text.isNotEmpty) {
      isSelected = true;
    }

    if (selected_verification.contains('Verified') &&
        label.contains('Verified')) {
      isSelected = true;
    }
    return FxContainer(
      onTap: () {
        addItemToFilter(label);
      },
      margin: const EdgeInsets.only(right: 5, top: 5),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      borderRadiusAll: 20,
      borderColor: CustomTheme.primary,
      bordered: true,
      color: isSelected ? CustomTheme.primary : Colors.grey.shade100,
      child: FxText(
        label,
        fontSize: 10,
        fontWeight: 700,
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  void showShareBottomSheet() {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Share.share(shared_data,
                            subject: 'School Fees Balances');
                      },
                      leading: Icon(
                        FeatherIcons.messageCircle,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Share on Whatsapp",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        await Clipboard.setData(
                            ClipboardData(text: shared_data));
                        Utils.toast('Copied');
                      },
                      leading: Icon(
                        FeatherIcons.copy,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Copy to clipboard",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Share.share(shared_data);
                      },
                      leading: Icon(
                        FeatherIcons.share2,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Share with other applications",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
