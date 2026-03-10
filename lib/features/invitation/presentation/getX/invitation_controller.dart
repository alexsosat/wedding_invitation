import "package:get/get.dart";

import "../../../../core/adapters/dio_adapter.dart";
import "../../../shared/business/entities/invitation_entity.dart";
import "../../business/entities/guest_rsvp_form_entity.dart";
import "../../business/use_cases/get_invitation.dart";
import "../../data/data_sources/remote/invitation_remote_data_source.dart";
import "../../data/models/params/invitation_params.dart";
import "../../data/repositories/invitation_repository_impl.dart";

/// Controller for the Invitation page.
class InvitationController extends GetxController
    with StateMixin<InvitationEntity> {
  @override
  void onInit() {
    super.onInit();
    _getInvitation();
  }

  Future<void> _getInvitation() async {
    change(null, status: RxStatus.loading());

    final slug = Get.parameters["tag"] ?? "";

    if (slug.isEmpty) {
      change(null, status: RxStatus.error("Slug is empty"));
      return;
    }

    final result = await GetInvitation(
      invitationRepository: InvitationRepositoryImpl(
        remoteDataSource: InvitationRemoteDataSourceImpl(
          dio: Get.find<DioAdapter>(),
        ),
      ),
    ).call(
      params: InvitationParams(slug: Get.parameters["tag"] ?? ""),
    );

    result.fold(
      (failure) => change(null, status: RxStatus.error(failure.title)),
      (invitation) {
        change(invitation, status: RxStatus.success());
      },
    );
  }
}
