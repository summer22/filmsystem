import 'package:chewie/chewie.dart';
import 'package:filmsystem/data/dao/download/download_dao.dart';
import 'package:filmsystem/data/dao/download/download_info_model.dart';
import 'package:filmsystem/data/models/video/video_model.dart';
import 'package:filmsystem/network/api.dart';
import 'package:filmsystem/network/api_path.dart';
import 'package:filmsystem/network/core/api_adapter.dart';
import 'package:filmsystem/network/core/api_error.dart';
import 'package:filmsystem/network/core/base_request.dart';
import 'package:filmsystem/network/video_downloader.dart';
import 'package:filmsystem/pages/widgets/video/custom_material_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../utils/storage.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoModel? videoModel;
  final String headNo = Get.arguments["headNo"];
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final VideoDownloader downloader = VideoDownloader();

  @override
  void initState() {
    super.initState();
    // _getData();
    const url = "http://localhost/320.mp4";
    initialize(url);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _getData() async {
    BaseRequest request = BaseRequest();
    request.isShowLoading = false;
    request.httpMethod = HttpMethod.post;
    request.path = ApiPath.video;
    request.add("headNo", headNo);
    try {
      ApiResponse response = await Api().fire(request);
      videoModel = VideoModel.fromJson(response.data);
      // videoModel?.data?.first?.filmUrl = "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";
      initializePlayer();
    } on ApiError catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> initializePlayer() async {
    // List<DownloadInfoModel> list = await DownloadDao.searchDatas();
    // _videoPlayerController = VideoPlayerController.file(File(list.first.filePath ?? ""));
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoModel?.data?.first?.filmUrl ?? ""));
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  Future<void> initialize(String url) async {
    // List<DownloadInfoModel> list = await DownloadDao.searchDatas();
    // _videoPlayerController = VideoPlayerController.file(File(list.first.filePath ?? ""));
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      zoomAndPan: true,
      // aspectRatio: 16 / 9,
      progressIndicatorDelay: null,
      customControls: CustomMaterialControls(
        callback: () async {
          // const url = "https://cvws.icloud-content.com.cn/B/Adbqg7D0lwYIcFH_bQBH23GNG4acAVyuy5TcqMB3GPCEwKm3Pwrov61K/public.mp4?o=Ajz5TDvTbLfRSy4Oopo5u-ZI-1MYzE7Xr6pDeAAwKNh9&v=1&x=3&a=CAogsM06OqsukfxByewHlw6hANJmWMbU5Fm1frIe7_6qUrASbRCQ9M3EwzEYkNGpxsMxIgEAUgSNG4acWgTov61Kaia4KLDTAYZrOIdP3GrtzDlYst0lqQK0J2vd8ZwbTA6rXnEuE6u6pXImjSKuCv5Qmmi_6FBPGDLe0kLucS6qbWRbH3INaP3dmR8V0DYG64Q&e=1701759838&fl=&r=a8e0c9e2-4391-4a65-b72c-61353baae131-1&k=Sx5HNDlAfe8bqQCHV30ifw&ckc=com.apple.photos.cloud&ckz=PrimarySync&y=1&p=211&s=1eLVaYyeT03voXtVXKbRpNp4y18";
          // initialize(url);
          _scaffoldKey.currentState?.openEndDrawer();
        },
        downloadCallBack: () async {
          // const url = "http://localhost/320.mp4";
          // initialize(url);
          // String email = Storage.readUserInfo().data?.email ?? "";
          // DownloadInfoModel model = DownloadInfoModel(
          //   id:videoModel?.data?.first?.id,
          //   email: email,
          //   headNo:videoModel?.data?.first?.headNo,
          //   dramaNumber:videoModel?.data?.first?.dramaNumber,
          //   dramaUrl:videoModel?.data?.first?.dramaUrl,
          //   dramaUrl1:videoModel?.data?.first?.dramaUrl1,
          //   dramaUrl2:videoModel?.data?.first?.dramaUrl2,
          //   dramaTitle:videoModel?.data?.first?.dramaTitle,
          //   intro:videoModel?.data?.first?.intro,
          //   filmUrl:videoModel?.data?.first?.filmUrl,
          //   duration:videoModel?.data?.first?.duration,
          //   createDate:videoModel?.data?.first?.createDate,
          //   updateDate:videoModel?.data?.first?.updateDate,
          // );
          // downloader.downloadVideo(model);
        },
      ),
      hideControlsTimer: const Duration(seconds: 1),
      showControls: true,
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign GlobalKey to the Scaffold
      backgroundColor: Colors.black,
      endDrawer: Drawer(
        backgroundColor: Colors.black87,
        width: 220,
        child: Container(
          height: Get.height,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          decoration: const BoxDecoration(
            color: Colors.black87,
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 指定每行的列数
              crossAxisSpacing: 10.0, // 列之间的水平间距
              mainAxisSpacing: 10.0, // 行之间的垂直间距
              childAspectRatio: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Center(
                  child: Text(
                    '第${videoModel?.data?.first?.dramaNumber}集',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
            itemCount: 1, // 列表中的总项目数
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: _chewieController!,
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Loading',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
