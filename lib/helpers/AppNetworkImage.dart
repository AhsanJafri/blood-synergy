import 'dart:math';

import 'package:blood_synergy_app/helpers/Constants.dart';
import 'package:blood_synergy_app/helpers/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppNetworkImage extends StatelessWidget {
  AppNetworkImage({
    required this.path,
    this.errorText,
    this.height,
    this.width,
    this.isCircular = false,
    this.assetPath = '',
    this.isSvg = false,
    this.showFullScreen = false,
    this.showRandomColor = false,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.child, String? url,
  });

  final String? path;
  final String? errorText;
  final alphaBetColor =
      Colors.primaries[Random().nextInt(Colors.primaries.length)];
  final double? height;
  final double? width;
  final bool isCircular;
  final String assetPath;
  final bool isSvg;
  final bool showFullScreen;
  final bool showRandomColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showFullScreen
          ? () {
              // if (assetPath.isEmpty) {
              // final imageProvider = Image.network(path);
              // showImageViewer(
              //   context,
              //   immersive: false,
              //   useSafeArea: false,
              //   swipeDismissible: true,
              //   doubleTapZoomable: true,
              //   imageProvider.image,
              //   onViewerDismissed: () {
              //     debugPrint("dismissed");
              //   },
              // );
              // }
            }
          : null,
      child: (showRandomColor == false)
          ? FutureBuilder(
              key: ValueKey(path), // or use UniqueKey()
              future: Future.delayed(const Duration(milliseconds: 500)),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return ClipOval(
                    clipBehavior: isCircular ? Clip.antiAlias : Clip.none,
                    child: assetPath.isEmpty
                        ? /*FadeInImage.assetNetwork(
                            height: height,
                            width: width,
                            image: path,
                            fit: BoxFit.cover,
                            placeholder:
                                'assets/animations/loader_cupertino_2.gif',
                            imageErrorBuilder: (context, value, _) {
                              return Container(
                                height: height,
                                width: width,
                                decoration: BoxDecoration(
                                  shape: isCircular
                                      ? BoxShape.circle
                                      : BoxShape.rectangle,
                                  color: showRandomColor ? alphaBetColor : null,
                                ),
                                child: showRandomColor
                                    ? null
                                    : Image.asset(
                                        'assets/images/profile/user_empty.png'),
                              );
                            },
                          )*/
                        CachedNetworkImage(
                            imageUrl: path ?? Constants.placeHolderImage,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: ClipOval(
                                clipBehavior:
                                    isCircular ? Clip.antiAlias : Clip.none,
                                child: Container(
                                  width: width,
                                  height: height,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffDBDBDB),
                                    shape: isCircular
                                        ? BoxShape.circle
                                        : BoxShape.rectangle,
                                    border: Border.all(
                                        color: borderColor ??
                                            const Color(0xffF2F2F2),
                                        width: borderWidth ?? .5),
                                  ),
                                  child: const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            imageBuilder: isCircular
                                ? (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        shape: isCircular
                                            ? BoxShape.circle
                                            : BoxShape.rectangle,
                                        border: Border.all(
                                          color: borderColor ?? Colors.red,
                                          width: borderWidth ?? .5,
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: isCircular
                                              ? BoxShape.circle
                                              : BoxShape.rectangle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                : null,
                            height: height,
                            width: width,
                            errorWidget: (context, value, _) {
                              return Container(
                                height: height,
                                width: width,
                                decoration: BoxDecoration(
                                  shape: isCircular
                                      ? BoxShape.circle
                                      : BoxShape.rectangle,
                                  color: showRandomColor ? alphaBetColor : null,
                                ),
                                child: showRandomColor
                                    ? null
                                    : Image.asset(
                                        'assets/images/profilePlaceHolder.jpg'),
                              );
                            },
                          )
                        : Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(
                              shape: isCircular
                                  ? BoxShape.circle
                                  : BoxShape.rectangle,
                              // color: alphaBetColor,
                            ),
                            child: isSvg
                                ? SvgPicture.asset(assetPath)
                                : Image.asset(assetPath),
                          ));
              },
            )
          : Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: isCircular ? null : BorderRadius.circular(8.r),
                shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                border: Border.all(color: Colors.white, width: 1),
                color: backgroundColor ?? alphaBetColor,
              ),
              child: child,
            ),
    );
  }
}
