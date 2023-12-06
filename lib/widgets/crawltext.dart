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
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        setState(
          () {},
        );
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          int distance = (_controller.position.maxScrollExtent -
                  _controller.position.minScrollExtent)
              .toInt();
          _controller.jumpTo(0);
          await _controller.animateTo(_controller.position.maxScrollExtent,
              duration:
                  Duration(milliseconds: ((distance / 10) * 1000).toInt()),
              curve: Curves.linear);
          await Future.delayed(const Duration(seconds: 3));
          await _controller.animateTo(_controller.position.minScrollExtent,
              duration:
                  Duration(milliseconds: ((distance / 10) * 1000).toInt()),
              curve: Curves.linear);
          await Future.delayed(const Duration(seconds: 3));
          if (context.mounted) {
            setState(() {});
          }
        });
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
