import 'package:flutter/material.dart';

class CrawlText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  const CrawlText({required this.text, super.key, this.textStyle});

  @override
  State<CrawlText> createState() => _CrawlTextState();
}

class _CrawlTextState extends State<CrawlText> {
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      double maxExtent = _controller.position.maxScrollExtent;
      double minExtent = _controller.position.minScrollExtent;
      autoSlide(maxExtent, minExtent, maxExtent);
    });
  }

  void autoSlide(double max, double min, double direction) {
    double distance = max - min;
    _controller
        .animateTo(
      direction,
      duration: Duration(milliseconds: distance.toInt() * 35),
      curve: Curves.linear,
    )
        .then((_) {
      if (direction == max) {
        direction = 0;
      } else {
        direction = max;
      }
      Future.delayed(
        const Duration(seconds: 1),
        () {
          autoSlide(max, min, direction);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Text(
            widget.text,
            style: widget.textStyle,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
