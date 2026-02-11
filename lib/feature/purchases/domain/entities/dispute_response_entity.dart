class DisputeResponseEntity {
  final String disputeId;
  final String message;

  const DisputeResponseEntity({
    required this.disputeId,
    required this.message,
  });
}

class EvidenceUploadResponseEntity {
  final String url;

  const EvidenceUploadResponseEntity({
    required this.url,
  });
}
