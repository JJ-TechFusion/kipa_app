import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/network/app_dio.dart';
import '../../../../utils/constant.dart';
import '../../data/datasources/support_remote_datasource.dart';
import '../../data/repositories/support_repository_impl.dart';
import '../../domain/repositories/support_repository.dart';
import '../../domain/usecases/get_or_create_support_conversation_usecase.dart';
import '../../domain/usecases/get_support_messages_usecase.dart';
import '../../domain/usecases/mark_support_messages_read_usecase.dart';
import '../../domain/usecases/send_support_message_usecase.dart';
import '../../domain/usecases/upload_support_media_usecase.dart';

final supportRemoteDataSourceProvider = Provider<SupportRemoteDataSource>((
  ref,
) {
  return SupportRemoteDataSource(dio: getIt<AppDio>());
});

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepositoryImpl(ref.read(supportRemoteDataSourceProvider));
});

final getOrCreateSupportConversationUseCaseProvider =
    Provider<GetOrCreateSupportConversationUseCase>((ref) {
      return GetOrCreateSupportConversationUseCase(
        ref.read(supportRepositoryProvider),
      );
    });

final getSupportMessagesUseCaseProvider = Provider<GetSupportMessagesUseCase>((
  ref,
) {
  return GetSupportMessagesUseCase(ref.read(supportRepositoryProvider));
});

final sendSupportMessageUseCaseProvider = Provider<SendSupportMessageUseCase>((
  ref,
) {
  return SendSupportMessageUseCase(ref.read(supportRepositoryProvider));
});

final markSupportMessagesReadUseCaseProvider =
    Provider<MarkSupportMessagesReadUseCase>((ref) {
      return MarkSupportMessagesReadUseCase(
        ref.read(supportRepositoryProvider),
      );
    });

final uploadSupportMediaUseCaseProvider = Provider<UploadSupportMediaUseCase>((
  ref,
) {
  return UploadSupportMediaUseCase(ref.read(supportRepositoryProvider));
});
