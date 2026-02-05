import 'package:flutter/material.dart';

class OnboardingPageEntity {
  final String title;
  final String description;
  final String imageAsset;
  final Color backgroundColor;

  const OnboardingPageEntity({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.backgroundColor,
  });
}
