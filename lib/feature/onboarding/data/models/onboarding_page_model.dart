import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';

class OnboardingPageModel extends OnboardingPageEntity {
  const OnboardingPageModel({
    required super.title,
    required super.description,
    required super.imageAsset,
    required super.backgroundColor,
  });

  factory OnboardingPageModel.fromEntity(OnboardingPageEntity entity) {
    return OnboardingPageModel(
      title: entity.title,
      description: entity.description,
      imageAsset: entity.imageAsset,
      backgroundColor: entity.backgroundColor,
    );
  }

  OnboardingPageEntity toEntity() {
    return OnboardingPageEntity(
      title: title,
      description: description,
      imageAsset: imageAsset,
      backgroundColor: backgroundColor,
    );
  }

  factory OnboardingPageModel.fromJson(Map<String, dynamic> json) {
    return OnboardingPageModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imageAsset: json['imageAsset'] as String,
      backgroundColor: Color(json['backgroundColor'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageAsset': imageAsset,
      'backgroundColor': backgroundColor.toARGB32(),
    };
  }
}
