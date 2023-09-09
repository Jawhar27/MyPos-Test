import 'package:flutter/material.dart';

class LabelTextField extends StatelessWidget {
  const LabelTextField(
      {Key? key,
      this.height = 80.0,
      required this.keyboardType,
      required this.textFieldController,
      this.validator,
      this.onChanged,
      required this.hintText,
      this.isMultilineField = false,
      required this.labelText})
      : super(key: key);

  final double height;
  final TextInputType keyboardType;
  final TextEditingController textFieldController;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String hintText;
  final String labelText;
  final bool isMultilineField;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 4, 79, 140),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: textFieldController,
              validator: validator,
              onChanged: onChanged,
              keyboardType: keyboardType,
              maxLines: isMultilineField ? 3 : 1,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 16),
                fillColor: const Color.fromARGB(255, 246, 243, 243),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
