import "package:flutter/material.dart";
import "package:flutter_common_classes/services/logger/logger_service.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:get/get.dart";
import "package:toastification/toastification.dart";

import "../../../../core/adapters/dio_adapter.dart";
import "../../../invitation/business/entities/guest_rsvp_form_entity.dart";
import "../../../invitation/presentation/getX/invitation_controller.dart";
import "../../business/use_cases/send_rsvp.dart";
import "../../data/data_sources/remote/rsvp_remote_data_source.dart";
import "../../data/models/params/send_rsvp_params.dart";
import "../../data/repositories/rsvp_repository_impl.dart";

/// Controller for the RSVP page.
class RsvpController extends GetxController {
  /// Reactive list of RSVP forms, one per guest.
  final RxList<GuestRsvpFormEntity> guestRsvpForms =
      <GuestRsvpFormEntity>[].obs;

  final _logger = getLogger("RsvpController");

  @override
  void onInit() {
    super.onInit();
    _getRsvp();
  }

  Future<void> _getRsvp() async {
    try {
      final guests = Get.find<InvitationController>().state?.guests;

      if (guests == null) {
        return;
      }

      guestRsvpForms.value = guests
          .map(
            (g) => GuestRsvpFormEntity(
              guest: g,
              formKey: GlobalKey<FormBuilderState>(
                debugLabel: "rsvp_form_${g.documentId}",
              ),
            ),
          )
          .toList();
    } catch (e) {
      _logger.e("Error getting RSVP: $e");
    }
  }

  /// Submits the RSVP forms.
  Future submitRsvp() async {
    for (var form in guestRsvpForms) {
      final key = form.formKey.currentState;

      if (key == null) {
        return;
      }

      if (!key.saveAndValidate()) {
        return;
      }
    }

    _logger.i(
      "Submitting RSVP forms: ${guestRsvpForms.map((f) => f.formKey.currentState?.value).join(", ")}",
    );

    final response = await Get.showOverlay(
      asyncFunction: () => SendRsvp(
        rsvpRepository: RsvpRepositoryImpl(
          remoteDataSource: RsvpRemoteDataSourceImpl(
            dio: Get.find<DioAdapter>(),
          ),
        ),
      ).call(
        params: SendRsvpParams(
          slug: Get.find<InvitationController>().state?.slug ?? "",
          responses: guestRsvpForms,
        ),
      ),
    );

    response.fold(
      (failure) => toastification.show(
        title: const Text("Error"),
        description: Text(failure.message),
        type: ToastificationType.error,
      ),
      (success) => toastification.show(
        title: const Text("Respuesta enviada"),
        description: const Text("Muchas gracias por tu tiempo"),
        type: ToastificationType.success,
      ),
    );
  }
}
