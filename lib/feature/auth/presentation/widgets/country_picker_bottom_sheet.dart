import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/textfields/custom_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';

class CountryPickerBottomSheet extends StatefulWidget {
  final Function(String code, String flag) onCountrySelected;

  const CountryPickerBottomSheet({super.key, required this.onCountrySelected});

  @override
  State<CountryPickerBottomSheet> createState() =>
      _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  List<Map<String, String>> countries = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/countries/countries.json',
      );
      final List<dynamic> data = json.decode(response);
      setState(() {
        countries = data
            .map(
              (country) => {
                'code': country['code'] as String,
                'flag': country['flag'] as String,
                'name': country['name'] as String,
              },
            )
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCountries = countries.where((country) {
      return country['name']!.toLowerCase().contains(
            searchQuery.toLowerCase(),
          ) ||
          country['code']!.contains(searchQuery);
    }).toList();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            verticalSpace(16),

            const H3('Select Country'),
            verticalSpace(16),

            TextInputField(
              hintText: 'Find your country',
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            verticalSpace(8),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filteredCountries.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final country = filteredCountries[index];
                    return ListTile(
                      leading: Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: Row(
                        children: [
                          BodyText(
                            country['code']!,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: BodyText(
                              country['name']!,
                              color: AppColor.primaryText,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        widget.onCountrySelected(
                          country['code']!,
                          country['flag']!,
                        );
                      },
                    );
                  },
                ),
              ),
            verticalSpace(16),
          ],
        ),
      ),
    );
  }
}
