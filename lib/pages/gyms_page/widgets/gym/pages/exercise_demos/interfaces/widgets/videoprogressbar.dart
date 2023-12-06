import 'package:flutter/material.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/functions/formatduration.dart';
import 'package:video_player/video_player.dart';

class VideoProgressBar extends StatefulWidget {
  final VideoPlayerController controller;
  const VideoProgressBar({super.key, required this.controller});

  @override
  State<VideoProgressBar> createState() => _VideoProgressBarState();
}

class _VideoProgressBarState extends State<VideoProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final VideoPlayerController controller = widget.controller;
      String timeString = "";
      double currentPosition = 0;
      bool isSliding = false;
      return StatefulBuilder(
        builder: (context, setState) {
          controller.addListener(
            () {
              setState(
                () {
                  currentPosition =
                      controller.value.position.inMilliseconds.toDouble();
                },
              );
            },
          );
          return Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: const SliderThemeData(
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                    showValueIndicator: ShowValueIndicator.always,
                  ),
                  child: Slider(
                    activeColor: adaptiveColor(
                        const Color.fromARGB(255, 50, 50, 180),
                        Colors.blue,
                        context),
                    value: currentPosition,
                    max: controller.value.duration.inMilliseconds.toDouble(),
                    onChangeStart: (value) {
                      isSliding = true;
                      controller.pause();
                    },
                    onChangeEnd: (value) {
                      isSliding = false;
                      setState(
                        () {
                          controller
                              .seekTo(Duration(milliseconds: value.toInt()));
                        },
                      );
                      controller.play();
                    },
                    label: timeString,
                    onChanged: (value) {
                      setState(
                        () {
                          currentPosition = value;
                          timeString = formatDuration(
                            Duration(
                              milliseconds: value.toInt(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  formatDuration(
                    Duration(
                      milliseconds: currentPosition.toInt(),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: !isSliding
                    ? () {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      }
                    : null,
                icon: Icon(controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow),
              )
            ],
          );
        },
      );
    });
  }
}
