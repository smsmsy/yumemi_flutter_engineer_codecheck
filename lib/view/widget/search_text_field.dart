import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.onCancelButtonPressed,
    this.labelText,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onCancelButtonPressed;
  final String? labelText;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: TextField(
        controller: controller ?? TextEditingController(),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: onCancelButtonPressed,
            icon: const Icon(Icons.cancel),
          ),
          labelText: labelText,
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<TextEditingController?>('controller', controller),
    );
    properties.add(
      ObjectFlagProperty<void Function(String p1)?>.has('onChanged', onChanged),
    );
    properties.add(
      DiagnosticsProperty<void Function()?>(
        'onCancelButtonPressed',
        onCancelButtonPressed,
      ),
    );
    properties.add(StringProperty('labelText', labelText));
    properties.add(
      ObjectFlagProperty<void Function(String p1)?>.has(
        'onSubmitted',
        onSubmitted,
      ),
    );
  }
}
