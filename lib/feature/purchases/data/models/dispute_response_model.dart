import '../../domain/entities/dispute_response_entity.dart';

class DisputeResponseModel {
  final String disputeId;
  final String message;

  const DisputeResponseModel({
    required this.disputeId,
    required this.message,
  });

  factory DisputeResponseModel.fromJson(Map<String, dynamic> json) {
    return DisputeResponseModel(
      disputeId: json['dispute_id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  DisputeResponseEntity toEntity() {
    return DisputeResponseEntity(
      disputeId: disputeId,
      message: message,
    );
  }
}

class EvidenceUploadResponseModel {
  final String url;

  const EvidenceUploadResponseModel({
    required this.url,
  });

  factory EvidenceUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return EvidenceUploadResponseModel(
      url: json['url']?.toString() ?? '',
    );
  }

  EvidenceUploadResponseEntity toEntity() {
    return EvidenceUploadResponseEntity(
      url: url,
    );
  }
}
