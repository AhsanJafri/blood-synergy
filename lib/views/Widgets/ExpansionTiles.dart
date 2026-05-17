import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    Key? key,
    required this.title,
    this.children = const <Widget>[],
    this.trailingGridView,
  }) : super(key: key);

  final Widget title;
  final List<Widget> children;
  final List<Widget>? trailingGridView;

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;
  double calculateAspectRatio(double height, double width) {
    return height / width;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: widget.title),
                if (widget.trailingGridView != null &&
                    widget.trailingGridView!.isNotEmpty)
                  if (widget.trailingGridView != null &&
                      widget.trailingGridView!.isNotEmpty)
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        // color: Colors.amber,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 39.w),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              //  crossAxisSpacing: 5.w,
                              //mainAxisSpacing: 5.0.w,
                            ),
                            itemCount: widget.trailingGridView!.length,
                            itemBuilder: (context, index) {
                              return widget.trailingGridView![index];
                            },
                          ),
                        ),
                      ),
                    ),
              ],
            ),
            if (_isExpanded)
              Divider(
                color: Colors.grey.shade400,
              ),
            if (_isExpanded)
              Column(
                children: [
                  ...widget.children,
                ],
              ),
          ],
        ),
      ),
    );
  }
}
