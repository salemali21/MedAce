import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerWidget extends StatefulWidget {
  const YouTubePlayerWidget({Key? key, required this.videoLink}) : super(key: key);

  final String videoLink;

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoLink)!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: YoutubePlayer(
            aspectRatio: 16 / 9,
            controller: _youtubeController!,
            showVideoProgressIndicator: true,
            onReady: () {},
          ),
        ),
        Positioned(
          top: 40,
          right: 0,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
