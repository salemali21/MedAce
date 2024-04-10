import 'package:flutter/material.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

import '../../../../../core/env.dart';

class VdoPlaybackArgs {
  VdoPlaybackArgs(
      this.title,
      this.otp,
      this.playbackInfo,
      );

  final String title;
  final String otp;
  final String playbackInfo;
}

class VdoPlaybackView extends StatefulWidget {

  static const String routeName = '/VdoPlaybackView';

  @override
  _VdoPlaybackViewState createState() => _VdoPlaybackViewState();
}

class _VdoPlaybackViewState extends State<VdoPlaybackView> {
  VdoPlayerController? _controller;
  final double aspectRatio = 16/9;
  ValueNotifier<bool> _isFullScreen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final VdoPlaybackArgs args = ModalRoute.of(context)!.settings.arguments as VdoPlaybackArgs;
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                  valueListenable: _isFullScreen,
                  builder: (context, dynamic value, child) {
                    return value ? SizedBox.shrink() : _nonFullScreenContent(args.title);
                  }),
              Flexible(child: Container(
                child: VdoPlayer(
                  embedInfo: EmbedInfo.streaming(
                      otp: args.otp,
                      playbackInfo: args.playbackInfo,
                      embedInfoOptions: EmbedInfoOptions(
                          autoplay: true
                      ),
                  ),
                  onPlayerCreated: (controller) => _onPlayerCreated(controller),
                  onFullscreenChange: _onFullscreenChange,
                  onError: _onVdoError,
                  controls: true, //optional, set false to disable player controls
                ),
                width: MediaQuery.of(context).size.width,
                height: _isFullScreen.value ? MediaQuery.of(context).size.height : _getHeightForWidth(MediaQuery.of(context).size.width),
              )),
            ]),
    );
  }

  _onVdoError(VdoError vdoError)  {
    print("Oops, the system encountered a problem: " + vdoError.message);
  }

  _onPlayerCreated(VdoPlayerController? controller) {
    setState(() {
      _controller = controller;
      _onEventChange(_controller);
    });
  }

  _onEventChange(VdoPlayerController? controller) {
    controller!.addListener(() {
      VdoPlayerValue value = controller.value;

      print("VdoControllerListner"
          "\nloading: ${value.isLoading} "
          "\nplaying: ${value.isPlaying} "
          "\nbuffering: ${value.isBuffering} "
          "\nended: ${value.isEnded}"
      );
    });
  }

  _onFullscreenChange(isFullscreen) {
    setState(() {
      _isFullScreen.value = isFullscreen;
    });
  }

  _nonFullScreenContent(String title) {
    return Column(
        children: [
          Text(unescape.convert(title), style: TextStyle(fontSize: 20.0),),
        ]);
  }

  double _getHeightForWidth(double width) {
    return width / aspectRatio;
  }
}


