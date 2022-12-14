import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/screens/home/web/web_banner_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_category_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_popular_food_view.dart';
import 'package:efood_multivendor/view/screens/home/web/widgets/campain.dart';
import 'package:efood_multivendor/view/screens/home/web/widgets/four.dart';
import 'package:efood_multivendor/view/screens/home/web/widgets/fourteen.dart';
import 'package:efood_multivendor/view/screens/home/web/widgets/one-one-seven.dart';
import 'package:efood_multivendor/view/screens/home/web/widgets/one_category.dart';
import 'package:efood_multivendor/view/screens/home/web/widgets/seven.dart';
import 'package:efood_multivendor/view/screens/home/web/widgets/three.dart';
import 'package:efood_multivendor/view/screens/home/web/widgets/twelve.dart';
import 'package:efood_multivendor/view/screens/home/web/widgets/two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../controller/category_controller.dart';
import '../../../helper/route_helper.dart';
import '../../base/custom_image.dart';

class WebHomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  WebHomeScreen({@required this.scrollController});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  ConfigModel _configModel;
  // final _webViewPlugin = FlutterWebviewPlugin();
  final Completer<WebViewController> _controllerWeb =
      Completer<WebViewController>();
  final Completer<WebViewController> _controllerWeb1 =
      Completer<WebViewController>();

  // void registerWebViewWebImplementation() {
  //   WebView.platform = WebWebViewPlatform();
  // }

  VideoPlayerController _controller;
  VideoPlayerController _controller1;

  ChewieController _chewieController;
  ChewieController _chewieController1;

  @override
  void initState() {
    // WebView.platform = WebWebViewPlatform();
    super.initState();
    // ignore: undefined_prefixed_name

    // _webViewPlugin.onDestroy.listen((_) {
    //   if (Navigator.canPop(context)) {
    //     // exiting the screen
    //     Navigator.of(context).pop();
    //   }
    // });
    _controller1 = VideoPlayerController.network(
        'https://k135.github.io/bigmeatmart/bigme.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    Get.find<BannerController>().setCurrentIndex(0, false);
    _configModel = Get.find<SplashController>().configModel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        controller: widget.scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
              child: GetBuilder<BannerController>(builder: (bannerController) {
            return bannerController.bannerImageList == null
                ? WebBannerView(bannerController: bannerController)
                : bannerController.bannerImageList.length == 0
                    ? SizedBox()
                    : WebBannerView(bannerController: bannerController);
          })),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Center(
                    child: SizedBox(
                        width: Dimensions.WEB_MAX_WIDTH,
                        child: Column(
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WebCategoryView(),
                                  SizedBox(
                                      width: Dimensions.PADDING_SIZE_LARGE),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // _configModel.popularRestaurant == 1 ? WebPopularRestaurantView(isPopular: true) : SizedBox(),

                                          // CategoryView1(),

                                          SizedBox(
                                            height: 30,
                                          ),
                                          Container(
                                            height: 450,
                                            child: WebView(

                                              initialUrl:
                                              'https://blog.bigmeatmart.com/banner-top',
                                              onWebViewCreated: (WebViewController controller) {
                                                _controllerWeb1.complete(controller);
                                              },
                                            ),
                                          ),
                                          // Image.asset(
                                          //   'assets/image/b3.png',
                                          //   height: 200,
                                          //   width: double.infinity,
                                          //   fit: BoxFit.fill,
                                          // ),
                                          // SizedBox(
                                          //   height: 20,
                                          // ),
                                          CampaignView(),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          WebPopularFoodView(isPopular: true), SizedBox(
                                            height: 8,
                                          ),
                                          OneOneSevenCategory(), SizedBox(
                                            height: 8,
                                          ),
                                          FourCategory(), SizedBox(
                                            height: 8,
                                          ),
                                          OneCategory(), SizedBox(
                                            height: 8,
                                          ),
                                          TwoCategory(), SizedBox(
                                            height: 8,
                                          ),
                                          ThreeCategory(), SizedBox(
                                            height: 8,
                                          ),
                                          SevenCategory(), SizedBox(
                                            height: 8,
                                          ),
                                          TwelveCategory(), SizedBox(
                                            height: 8,
                                          ),
                                          // OneTwoOneCategory(),
                                          FourteenCategory(), SizedBox(
                                            height: 8,
                                          ),
                                          // ItemCampaignView1(),

                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/image/b2.png'),
                                                    fit: BoxFit.cover)),
                                            child:
                                                GetBuilder<CategoryController>(
                                                    builder:
                                                        (categoryController) {
                                              return (categoryController
                                                              .categoryList !=
                                                          null &&
                                                      categoryController
                                                              .categoryList
                                                              .length ==
                                                          0)
                                                  ? SizedBox()
                                                  : Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        Center(
                                                            child: Text(
                                                          "Categories",
                                                          style: TextStyle(
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child:
                                                              GridView.builder(
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                                maxCrossAxisExtent:
                                                                    150,
                                                                childAspectRatio:
                                                                    1,
                                                                crossAxisSpacing:
                                                                    10,
                                                                mainAxisSpacing:
                                                                    10),
                                                            itemCount: categoryController
                                                                        .categoryList
                                                                        .length >
                                                                    15
                                                                ? 15
                                                                : categoryController
                                                                    .categoryList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return InkWell(
                                                                onTap: () {
                                                                  Get.toNamed(
                                                                      RouteHelper
                                                                          .getCategoryProductRoute(
                                                                    categoryController
                                                                        .categoryList[
                                                                            index]
                                                                        .id,
                                                                    categoryController
                                                                        .categoryList[
                                                                            index]
                                                                        .name,
                                                                  ));
                                                                },
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child:
                                                                      CustomImage(
                                                                    image:
                                                                        '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: double
                                                                        .infinity,
                                                                    // height: 120,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                            }),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),

                                          SizedBox(
                                            height: 20,
                                          ),
                                          // _configModel.newRestaurant == 1 ? WebPopularRestaurantView(isPopular: false) : SizedBox(),
                                          //
                                          // _configModel.mostReviewedFoods == 1 ? WebPopularFoodView(isPopular: false) : SizedBox(),
                                        ]),
                                  ),
                                ]),
                          ],
                        ))),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              height: 850,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: 'https://blog.bigmeatmart.com/footer/',
                onWebViewCreated: (WebViewController controller) {
                  _controllerWeb.complete(controller);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
