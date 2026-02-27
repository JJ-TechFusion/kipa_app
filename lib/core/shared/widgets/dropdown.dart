import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kipa/core/shared/widgets/widgets.dart';

import '../../../theme/app_colors.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    super.key,
    this.onSelect,
    required this.initialValue,
    this.validator,
    required this.hintText,
    this.showSearch = true,
    this.label,
    this.selectedValue,
  });

  final String hintText;
  final Function(String?)? onSelect;
  final List<String> initialValue;
  final String? Function(String?)? validator;
  final bool showSearch;
  final String? label;
  final String? selectedValue;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  TextEditingController searchController = TextEditingController();
  bool isMenuOpen = false;
  List<String> filteredItems = [];
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.initialValue;
    _selectedValue = widget.selectedValue;
    if (widget.showSearch) {
      searchController.addListener(_filterItems);
    }
  }

  void _filterItems() {
    setState(() {
      filteredItems = widget.initialValue
          .where(
            (value) => value.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodySmall(
          widget.label ?? '',
          color: AppColor.darkPrimary,
          fontWeight: FontWeight.w500,
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isMenuOpen = !isMenuOpen;
                  });
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    hintStyle: TextStyle(
                      color: AppColor.kipaGrey.withAlpha(80),
                    ),
                    fillColor: AppColor.kipaGrey.withAlpha(60),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    suffixIcon: Icon(
                      isMenuOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    ),
                    contentPadding: EdgeInsets.only(left: 10, top: 12),
                  ),
                  child: Text(
                    _selectedValue ?? widget.hintText,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: _selectedValue != null
                          ? Colors.black
                          : AppColor.kipaGrey.withAlpha(80),
                    ),
                  ),
                ),
              ),
              if (isMenuOpen)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.withAlpha(40)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showSearch)
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search country...',
                              hintStyle: TextStyle(color: AppColor.kipaGrey),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.withAlpha(40),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.withAlpha(40),
                                ),
                              ),
                              fillColor: AppColor.kipaGrey.withAlpha(60),
                              filled: true,
                            ),
                          ),
                        ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: filteredItems.length > 3 ? 150 : filteredItems.length * 56.0,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final value = filteredItems[index];
                            final isSelected = value == _selectedValue;
                            return ListTile(
                              title: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: GoogleFonts.nunito().fontFamily,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? AppColor.primary
                                      : Colors.black,
                                ),
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: AppColor.primary,
                                      size: 18,
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedValue = value;
                                  isMenuOpen = false;
                                });
                                widget.onSelect?.call(value);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
