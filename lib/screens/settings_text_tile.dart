import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:settings_ui/settings_ui.dart';

class MyTextDialog extends StatefulWidget {
  //final String title;
  final Text title;
  final String prefKey;
  final String defaultText;
  final String? Function(String?)? validator;
  // return false to keep the menu open
  final bool? Function(String?)? onSave;
  final bool saveButton;
  final bool cancelButton;
  @Deprecated('Unable to specify button order, especially when using save/cancel') final List<Widget> extraActions;

  const MyTextDialog({
    required this.title,
    required this.prefKey,
    this.defaultText = '',
    this.validator, // Initialize the validator function
    this.onSave,
    this.saveButton = true,
    this.cancelButton = true,
    this.extraActions = const <Widget>[],
  });

  @override
  _MyTextDialogState createState() => _MyTextDialogState();
}

class _MyTextDialogState extends State<MyTextDialog> {
  late String textString;
  late TextEditingController _textEditingController;
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  void _loadText() {
    setState(() {
      textString = Provider.of<PreferencesProvider>(context, listen: false)
          .getOr<String>(widget.prefKey, widget.defaultText);
    });
  }

  void _saveText(String text) {
    setState(() {
      textString = text;
      Provider.of<PreferencesProvider>(context, listen: false)
          .set(widget.prefKey, textString);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadText();
    _textEditingController = TextEditingController(text: textString);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title, //Text(widget.title),
      // TODO test if form doesnt look tacky
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textEditingController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            //hintText: 'http://10.0.2.2/',
            suffixIcon: IconButton(
              onPressed: () {
                _textEditingController.clear();
                _focusNode.requestFocus();
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          validator: widget.validator, // Apply the validator function
        ),
      ),
      actions: <Widget>[
        if (widget.cancelButton)
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        if (widget.saveButton)
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              //if (_textEditingController.text.isNotEmpty) {
              if (_formKey.currentState!.validate()) {
                if (!(widget.onSave?.call(_textEditingController.text) == false)) {
                  Navigator.of(context).pop();
                }

                _saveText(_textEditingController.text);
              }
            },
          ),
        ...widget.extraActions,
      ],
    );
  }
}

SettingsTile createTextSettingsTile({
  required BuildContext context,
  // SettingsTile.navigation ctor:
  Widget? leading,
  Widget? trailing,
  Widget? value,
  required Text title,
  Widget? description,
  bool enabled = true,
  Key? key,
  // dialog ctor:
  required String prefKey,
  String defaultText = '',
  bool valueAsDescription = false,
  String? Function(String?)? validator,
  // return false to keep the menu open
  bool? Function(String?)? onSave,  
  @Deprecated('Unable to specify button order, especially when using save/cancel') List<Widget> extraActions = const <Widget>[],
  bool saveButton = true,
  bool cancelButton = true,
}) {
  return SettingsTile.navigation(
    leading: leading,
    trailing: trailing,
    value: value,
    title: title,
    //description: description,
    description: valueAsDescription
        ? Text(
            Provider.of<PreferencesProvider>(context)
                .getOr(prefKey, defaultText),
          )
        : description,
    //description: valueAsDescription ?
    //  Consumer<PreferencesProvider>(
    //    builder: (context, preferencesProvider, child) {
    //      return Text(preferencesProvider.getOr(prefKey, defaultText));
    //    }
    //  ) : description,
    enabled: enabled,
    key: key,
    onPressed: (context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyTextDialog(
            title: title,
            prefKey: prefKey,
            defaultText: defaultText,
            validator: validator,
            onSave: onSave,
            extraActions: extraActions,
            saveButton: saveButton,
            cancelButton: cancelButton,
          );
        },
      );
    },
  );
}
