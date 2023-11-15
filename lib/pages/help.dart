import 'package:filmsystem/data/models/help/help_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/standard_search_bar.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {

  Future<HelpModel?>? helpModel;

  late String input;
  
  @override
  void initState() {
    super.initState();
    helpModel = getData();
  }

  Future<HelpModel?> getData() async {
    BaseRequest request = BaseRequest();
    request.path = ApiPath.help;
    try {
      ApiResponse response = await Api().fire(request);
      return Future.value(HelpModel.fromJson(response.data));
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<HelpModel?> getSearchData() async {
    BaseRequest request = BaseRequest();
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.helpQuery;
    request.add("question", input);
    try {
      ApiResponse response = await Api().fire(request);
      return Future.value(HelpModel.fromJson(response.data));
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
              onTap: () => Get.back()),
        ),
        title: StandardSearchBarInner(
          hint: 'help_search_hint'.tr,
          autofocus: false,
          callback: (text) async {
            if (text.isNotEmpty) {
              input = text;
              setState(() {
                helpModel = getSearchData();
              });
            }
          },
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'cancel'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  helpModel = getData();
                });
              }),
        ],
      ),
      body:  FutureBuilder<HelpModel?>(
        future: helpModel,
        builder: (BuildContext context, AsyncSnapshot<HelpModel?> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.data?.length ?? 0,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  title: Text(snapshot.data?.data?[index]?.question ?? "", style: const TextStyle(color: Colors.white),),
                  children: [
                    ListTile(
                      title: Text(snapshot.data?.data?[index]?.answer ?? "", style: const TextStyle(color: Colors.white),),
                    ),
                  ],
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
