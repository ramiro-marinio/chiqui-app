import 'package:flutter/material.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/interfaces/widgets/videoprogressbar.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  final String? url;
  const VideoViewer({super.key, required this.url});

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;
  late Future<void> init;
  double aspectRatio = 1;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url ?? ''));
    init = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.url != null,
      child: FutureBuilder(
        future: init,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                const Text(
                  'Demonstration Video',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 300,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
                VideoProgressBar(controller: _controller),
              ],
            );
          } else {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
