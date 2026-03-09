import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/textfields/custom_field.dart';
import 'package:kipa/theme/app_colors.dart';

class ChipInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final List<String> selectedItems;
  final Function(String) onAddItem;
  final Function(String) onRemoveItem;
  final List<String>? suggestions;

  const ChipInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.selectedItems,
    required this.onAddItem,
    required this.onRemoveItem,
    this.suggestions,
  });

  @override
  State<ChipInputField> createState() => _ChipInputFieldState();
}

class _ChipInputFieldState extends State<ChipInputField> {
  List<String> filteredSuggestions = [];
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_filterSuggestions);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_filterSuggestions);
    super.dispose();
  }

  void _filterSuggestions() {
    if (widget.suggestions == null) return;

    final query = widget.controller.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        showSuggestions = false;
        filteredSuggestions = [];
      });
      return;
    }

    setState(() {
      showSuggestions = true;
      filteredSuggestions = widget.suggestions!
          .where(
            (suggestion) =>
                suggestion.toLowerCase().contains(query) &&
                !widget.selectedItems.contains(suggestion),
          )
          .toList();
    });
  }

  void _addItem() {
    final value = widget.controller.text;
    if (value.trim().isNotEmpty) {
      widget.onAddItem(value);
      setState(() {
        showSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInputField(
          label: widget.label,
          hintText: widget.hintText,
          controller: widget.controller,
          onEditingDone: _addItem,
          onChanged: (value) {},
          prefixIcon: Icon(CupertinoIcons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.add, color: AppColor.primary),
            onPressed: _addItem,
          ),
        ),

        if (showSuggestions && filteredSuggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 3),
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: filteredSuggestions
                  .take(5) // Limit number of suggestions
                  .map(
                    (suggestion) => ListTile(
                      dense: true,
                      title: Text(suggestion),
                      onTap: () {
                        widget.controller.clear();
                        widget.onAddItem(suggestion);
                        setState(() {
                          showSuggestions = false;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        if (widget.selectedItems.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedItems
                .map(
                  (item) => Container(
                    decoration: BoxDecoration(
                      color: AppColor.neutral,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 5,
                    ),
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BodySmall(item, color: AppColor.lightText),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () => widget.onRemoveItem(item),
                          child: Icon(
                            CupertinoIcons.clear_circled_solid,
                            color: AppColor.primaryText,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
