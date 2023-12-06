import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageTyper extends StatefulWidget {
  final Function(String value) onSubmit;
  const MessageTyper({super.key, required this.onSubmit});

  @override
  State<MessageTyper> createState() => _MessageTyperState();
}

class _MessageTyperState extends State<MessageTyper> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              inputFormatters: [
                LengthLimitingTextInputFormatter(500),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot send an empty message.';
                }
                return null;
              },
              onFieldSubmitted: (value) {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                widget.onSubmit(_controller.text);
                _controller.clear();
              },
            ),
          ),
          IconButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                widget.onSubmit(_controller.text);
                _controller.clear();
              },
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
