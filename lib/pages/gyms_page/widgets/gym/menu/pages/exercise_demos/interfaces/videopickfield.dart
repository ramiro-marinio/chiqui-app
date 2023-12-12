import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gymapp/functions/showwarningdialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/interfaces/widgets/videoprogressbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickField extends StatefulWidget {
  final String? initialVideo;
  final Function(String? path) chooseVideo;
  const VideoPickField(
      {super.key, required this.chooseVideo, this.initialVideo});

  @override
  State<VideoPickField> createState() => _VideoPickFieldState();
}

class _VideoPickFieldState extends State<VideoPickField> {
  String? videoPath;
  late VideoPlayerController _controller;
  double aspectRatio = 1;
  @override
  void initState() {
    super.initState();
    videoPath = widget.initialVideo;
    _controller = widget.initialVideo == videoPath
        ? VideoPlayerController.networkUrl(Uri.parse(videoPath ?? ''))
        : VideoPlayerController.file(File(videoPath ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    _controller = widget.initialVideo == videoPath
        ? VideoPlayerController.networkUrl(Uri.parse(videoPath ?? ''))
        : VideoPlayerController.file(File(videoPath ?? ''));
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    Future<void> init = _controller.initialize();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.video_call),
              ),
              Text(
                "Demonstration Video",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: init,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              aspectRatio = _controller.value.aspectRatio;
              _controller.play();
              return videoPath != null
                  ? Column(
                      children: [
                        SizedBox(
                          width: 300,
                          child: AspectRatio(
                            aspectRatio: aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                        VideoProgressBar(controller: _controller),
                      ],
                    )
                  : const SizedBox();
            } else {
              return const SizedBox();
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                  child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: videoPath?.isEmpty ?? true
                    ? null
                    : () {
                        showWarningDialog(
                          title: 'Delete Video?',
                          context: context,
                          yes: () {
                            widget.chooseVideo(null);
                            setState(() {
                              _controller.pause();
                              _controller.dispose();
                              videoPath = null;
                            });
                          },
                        );
                      },
              )),
              ElevatedButton(
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  ImageSource? imageSource;
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pick a Source'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            imageSource = ImageSource.camera;
                            Navigator.pop(context);
                          },
                          child: const Text('Camera'),
                        ),
                        TextButton(
                          onPressed: () {
                            imageSource = ImageSource.gallery;
                            Navigator.pop(context);
                          },
                          child: const Text('Gallery'),
                        )
                      ],
                    ),
                  );
                  if (imageSource == null) {
                    return;
                  }
                  XFile? xfile = await imagePicker.pickVideo(
                      source: imageSource!,
                      preferredCameraDevice: CameraDevice.rear);
                  _controller.dispose();

                  setState(() {
                    if (xfile != null) {
                      videoPath = xfile.path;
                    }
                  });

                  widget.chooseVideo(videoPath);
                },
                child: const Text("Pick a Video"),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
