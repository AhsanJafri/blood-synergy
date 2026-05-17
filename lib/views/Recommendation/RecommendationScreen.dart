import 'package:blood_synergy_app/Models/RecommendationsModel.dart';
import 'package:blood_synergy_app/helpers/utils.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:blood_synergy_app/views/screens/Supplement/supplements_screen.dart';
import 'package:blood_synergy_app/views/screens/faqs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendationScreen extends StatelessWidget {
  final List<RecommendationsModel>? model;
  const RecommendationScreen(this.model);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 130.h,
            width: 375.w,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(207, 27, 33, 1),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, top: 0).r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    //color: Colors.amber,
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 15),
                                    child: Image.asset(
                                      'assets/images/back.png',
                                    ),
                                  ),
                                ),
                                Text(
                                  'Recommendations',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: appTextTheme.giloryBold22White
                                      .copyWith(height: 1.1),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                      top: 0, bottom: 8.0, right: 8.0, left: 65)
                                  .r,
                              child: Text(
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: appTextTheme.giloryBold22White.copyWith(
                                    height: 1.1,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //   SizedBox(height: 20.h),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: (model?.isEmpty == false ? model?.length : 1),
              itemBuilder: (context, index) {
                return (model?.isEmpty ?? true)
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'No Recommendations given',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : CustomExpansionTile(
                        title: model?[index].title ?? 'No title available',
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        isHTML: true,
                        description: model?[index].recommendation ?? '',
                        backgroundColor:
                            hexToRgba(model?[index].color ?? '0xffffff', 0.8),
                      );
              },
            ),
          ),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      Util.showToast('Link address is not available!');
    }
  }
}
