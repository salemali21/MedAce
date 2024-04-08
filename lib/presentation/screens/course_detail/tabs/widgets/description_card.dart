import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:medace_app/main.dart';
import 'package:medace_app/theme/app_color.dart';

class DescriptionCard extends StatefulWidget {
  const DescriptionCard({
    Key? key,
    required this.descriptionUrl,
    required this.scrollCallback,
  }) : super(key: key);

  final String? descriptionUrl;
  final VoidCallback scrollCallback;

  @override
  State<DescriptionCard> createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<DescriptionCard> {
  InAppWebViewController? webViewController;
  bool showMore = false;
  double? contentHeight;

  @override
  Widget build(BuildContext context) {
    double webContainerHeight;

    if (contentHeight != null && showMore) {
      webContainerHeight = contentHeight!;
    } else {
      webContainerHeight = 160;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: webContainerHeight,
          ),
          child: InAppWebView(
            initialData: InAppWebViewInitialData(data: widget.descriptionUrl!),
            onLoadStop: (InAppWebViewController controller, Uri? uri) async {
              int? height = await controller.getContentHeight();
              double? zoomScale = await controller.getZoomScale();
              double htmlHeight = height!.toDouble() * zoomScale!;
              double htmlHeightFixed = double.parse(htmlHeight.toStringAsFixed(2));
              if (htmlHeightFixed == 0.0) {
                return;
              }
              setState(() {
                contentHeight = htmlHeightFixed + 0.1;
              });
            },
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
              ),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                showMore = !showMore;
                if (!showMore) widget.scrollCallback.call();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  showMore
                      ? localizations.getLocalization('show_less_button')
                      : localizations.getLocalization('show_more_button'),
                  textScaleFactor: 1.0,
                  style: TextStyle(color: ColorApp.mainColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
