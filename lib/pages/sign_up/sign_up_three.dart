import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmsystem/data/models/sign_in/hobby_list_model.dart';
import 'package:filmsystem/data/network/api.dart';
import 'package:filmsystem/data/network/api_path.dart';
import 'package:filmsystem/data/network/core/api_adapter.dart';
import 'package:filmsystem/data/network/core/api_error.dart';
import 'package:filmsystem/data/network/core/base_request.dart';
import 'package:filmsystem/pages/sign_up/sign_up_controller.dart';
import 'package:filmsystem/pages/sign_up/sign_up_four.dart';
import 'package:filmsystem/pages/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpThree extends StatefulWidget {
  const SignUpThree({super.key});

  @override
  State<SignUpThree> createState() => _SignUpThreeState();
}

class _SignUpThreeState extends State<SignUpThree> {

  late SignUpController _controller; // 控制器实例

  HobbyListModel? hobbyListModel;

  List<HobbyModel> selectedHobbyModel = [];

  @override
  void initState() {
    _controller = Get.find<SignUpController>();
    super.initState();
    getData();
  }

  void getData() async {
    BaseRequest request = BaseRequest();
    request.path = ApiPath.hobby;
    try {
      ApiResponse response = await Api().fire(request);
      setState(() {
        hobbyListModel = HobbyListModel.fromJson(response.data);
      });
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  SliverToBoxAdapter _topWidget() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'step_three'.tr,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${_controller.name}，${"step_three_subtitle".tr}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RichText(
            text: TextSpan(
              text: 'step_three_desc1'.tr,
              style: const TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: 'step_three_desc2'.tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _bottomBtn() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              SizedBox(
                height: 50,
                child: Button(
                  text: 'step_two_btn_left'.tr,
                  textColor: Colors.black87,
                  backgroundColor: Colors.white70,
                  radius: 8,
                  textStyle: const TextStyle(fontSize: 15),
                  click: () {
                    Get.back();
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Button(
                    text: selectedHobbyModel.length < 3 ? selectCountText() : 'step_two_btn_right2'.tr ,
                    textColor: selectedHobbyModel.length < 3 ? Colors.black87 : Colors.white,
                    backgroundColor: selectedHobbyModel.length < 3 ? Colors.white70 : Colors.redAccent,
                    radius: 8,
                    textStyle: const TextStyle(fontSize: 15),
                    click: () {
                      if(selectedHobbyModel.isEmpty){
                        return;
                      }
                      _controller.selectedHobbyModel = selectedHobbyModel;
                      Get.to(() => const SignUpFour());
                    },
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  String selectCountText() {
    return "${"step_three_desc3".tr}${3 - (selectedHobbyModel.length)}${"step_three_desc4".tr}";
  }

  SliverGrid _sliverGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                HobbyModel? model = hobbyListModel?.data?[index];
                if(selectedHobbyModel.contains(model)) {
                  selectedHobbyModel.remove(model);
                }else{
                  selectedHobbyModel.add(model!);
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: selectedHobbyModel.contains(hobbyListModel?.data?[index])
                    ? Border.all(color: Colors.green, width: 2.0)
                    : null,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: CachedNetworkImage(
                key: ValueKey(
                    hobbyListModel?.data?[index]?.posterUrl ?? ""),
                fit: BoxFit.fitHeight,
                placeholder: (context, url) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const SizedBox(),
                  );
                },
                imageUrl:hobbyListModel?.data?[index]?.posterUrl ?? "",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // 设置圆角半径
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('image_loading_error'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          )),
                    ),
                  );
                },
              ),
            ),
          );
        },
        childCount: hobbyListModel?.data?.length ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: Builder(
          builder: (context) => GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
              ),
              onTap: () => Get.back()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: CustomScrollView(
          slivers: [
            _topWidget(),
            _sliverGrid(),
            _bottomBtn(),
          ],
        ),
      ),
    );
  }

}
