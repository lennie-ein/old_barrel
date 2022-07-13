import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  const EntryField({
    Key? key,
    this.label,
    this.hint,
    this.noBorder = false,
    this.initialValue,
  }) : super(key: key);

  final String? label;
  final String? hint;
  final bool noBorder;
  final String? initialValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label!,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Theme.of(context).hintColor),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            initialValue: initialValue,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: noBorder
                        ? BorderSide.none
                        : BorderSide(color: Theme.of(context).hintColor)),
                hintText: hint,
                hintStyle: Theme.of(context).textTheme.bodyText2),
          ),
        ],
      ),
    );
  }
}
