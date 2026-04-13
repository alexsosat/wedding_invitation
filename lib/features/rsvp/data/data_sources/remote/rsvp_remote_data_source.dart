// ignore_for_file: one_member_abstracts

import "package:flutter_common_classes/services/logger/logger_service.dart";

import "../../../../../core/adapters/dio_adapter.dart";
import "../../models/params/send_rsvp_params.dart";

/// Remote data source for the Rsvp collection
abstract class RsvpRemoteDataSource {
  /// Sends the RSVP form values to the server.
  Future<void> sendRsvp(SendRsvpParams params);
}

/// Remote data source for the Rsvp collection
class RsvpRemoteDataSourceImpl implements RsvpRemoteDataSource {
  /// Remote data source for the Rsvp collection
  RsvpRemoteDataSourceImpl({
    required this.dio,
  });

  /// Dio instance
  final DioAdapter dio;

  final _logger = getLogger("RsvpRemoteDataSource");

  @override
  Future<void> sendRsvp(SendRsvpParams params) async {
    _logger.i("Sending RSVP for slug: ${params.slug}");

    final body = {
      "data": {
        "invitation": params.slug,
        "responses": params.responses.map(
          (r) {
            final values = r.formKey.currentState?.value;

            return {
              "guest": r.guest.documentId,
              "asistencia": values?["attendance"]?.label,
              "comida": values?["food"]?.label,
            };
          },
        ).toList(),
      },
    };

    await dio.post("/rsvps", data: body);

    _logger.i("RSVP sent successfully");
  }
}
