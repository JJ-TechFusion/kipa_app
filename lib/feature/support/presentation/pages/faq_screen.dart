import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/support/data/faq_data.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const BodyText(
          'Frequently Asked Questions',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          verticalSpace(8),
          ...kFaqData.map((categoryData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: BodySmall(
                    categoryData['category'],
                    fontWeight: FontWeight.w600,
                    color: AppColor.kipaGrey,
                  ),
                ),
                ...(categoryData['questions'] as List<dynamic>).map((q) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildFAQItem(
                      title: q['question'],
                      content: q['answer'],
                    ),
                  );
                }),
                verticalSpace(8),
              ],
            );
          }),
          verticalSpace(24),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String title, String? content}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: BodySmall(title, fontWeight: FontWeight.w600),
          childrenPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          children: [
            if (content != null)
              BodySmall(content, color: AppColor.kipaGrey2, lineHeight: 1.5),
          ],
        ),
      ),
    );
  }
}
