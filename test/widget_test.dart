import "package:boda_ma/boda_ma_app.dart";
import "package:boda_ma/features/invitation/business/repositories/invitation_repository.dart";
import "package:boda_ma/features/invitation/business/use_cases/get_invitation.dart";
import "package:boda_ma/features/invitation/business/use_cases/update_guest_rsvp.dart";
import "package:boda_ma/features/invitation/presentation/cubits/invitation_cubit.dart";
import "package:flutter_test/flutter_test.dart";
import "package:get_it/get_it.dart";

class FakeInvitationRepository implements InvitationRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() {
    final repository = FakeInvitationRepository();
    if (!GetIt.I.isRegistered<InvitationCubit>()) {
      GetIt.I.registerLazySingleton<InvitationCubit>(
        () => InvitationCubit(
          getInvitation: GetInvitation(invitationRepository: repository),
          updateGuestRsvp: UpdateGuestRsvp(invitationRepository: repository),
        ),
      );
    }
  });

  tearDown(() {
    GetIt.I.reset();
  });

  testWidgets("App smoke test", (tester) async {
    await tester.pumpWidget(const BodaMaApp());
    expect(find.byType(BodaMaApp), findsOneWidget);
  });
}
