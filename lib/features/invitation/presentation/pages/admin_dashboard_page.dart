import "dart:typed_data";

import "package:auto_route/auto_route.dart";
import "package:file_saver/file_saver.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";
import "package:get_it/get_it.dart";

import "../../../../core/gen/adobe_fonts.dart";
import "../../../../core/gen/assets.gen.dart";
import "../../../../core/routes/app_router.gr.dart";
import "../../../auth/presentation/cubits/auth_cubit.dart";
import "../../business/entities/invitation_entity.dart";
import "../../business/use_cases/export_guests_to_excel.dart";
import "../cubits/admin_dashboard_cubit.dart";
import "../cubits/admin_dashboard_state.dart";
import "../widgets/admin/dashboard_stats_card.dart";
import "../widgets/admin/delete_invitation_dialog.dart";
import "../widgets/admin/invitation_card.dart";
import "../widgets/admin/invitation_form_dialog.dart";

/// Admin dashboard page for managing invitations and tracking guest RSVPs
@RoutePage()
class AdminDashboardPage extends StatelessWidget {
  /// Creates an [AdminDashboardPage] instance
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<AdminDashboardCubit>(
        create: (_) => AdminDashboardCubit(
          getAllInvitations: GetIt.I(),
          createInvitation: GetIt.I(),
          updateInvitation: GetIt.I(),
          deleteInvitation: GetIt.I(),
          toggleInvitationSentStatus: GetIt.I(),
          toggleGuestConfirmationStatus: GetIt.I(),
        )..loadInvitations(),
        child: const _AdminDashboardView(),
      );
}

class _AdminDashboardView extends StatefulWidget {
  const _AdminDashboardView();

  @override
  State<_AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<_AdminDashboardView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCreateDialog(BuildContext context) {
    final cubit = context.read<AdminDashboardCubit>();
    showDialog(
      context: context,
      builder: (_) => InvitationFormDialog(
        onSave: cubit.createInvitation,
      ),
    );
  }

  void _openEditDialog(BuildContext context, InvitationEntity invitation) {
    final cubit = context.read<AdminDashboardCubit>();
    showDialog(
      context: context,
      builder: (_) => InvitationFormDialog(
        invitation: invitation,
        onSave: cubit.updateInvitation,
      ),
    );
  }

  void _openDeleteDialog(BuildContext context, InvitationEntity invitation) {
    final cubit = context.read<AdminDashboardCubit>();
    showDialog(
      context: context,
      builder: (_) => DeleteInvitationDialog(
        invitation: invitation,
        onConfirm: () => cubit.deleteInvitation(invitation.id),
      ),
    );
  }

  Future<void> _exportGuestsToExcel(
    BuildContext context,
    List<InvitationEntity> invitations,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    if (invitations.isEmpty) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text("No hay invitados registrados para exportar."),
          backgroundColor: theme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      final exportUseCase = GetIt.I<ExportGuestsToExcel>();
      final result = exportUseCase(
        params: ExportGuestsToExcelParams(invitations: invitations),
      );

      await result.fold(
        (failure) async {
          messenger.showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        (bytes) async {
          final now = DateTime.now();
          final formattedDate =
              "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}";
          final fileName = "lista_invitados_$formattedDate";

          final filePath = await FileSaver.instance.saveFile(
            name: fileName,
            bytes: Uint8List.fromList(bytes),
            ext: "xlsx",
            mimeType: MimeType.microsoftExcel,
          );

          if (filePath.isNotEmpty) {
            messenger.showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text("Lista de invitados exportada con éxito."),
                    ),
                  ],
                ),
                backgroundColor: Color(0xff2E7D32),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text("Error al exportar archivo: $e"),
          backgroundColor: theme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
          elevation: 0,
          title: Row(
            children: [
              Assets.images.logos.logo.svg(
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  context.colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Mayte & Alex",
                      style: TextStyle(
                        fontFamily: AdobeFonts.altesse,
                        fontSize: 22,
                        color: context.colorScheme.onPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Panel de Administración",
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onPrimary
                            .withValues(alpha: 0.8),
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download_outlined),
              tooltip: "Descargar Excel",
              onPressed: () {
                final state = context.read<AdminDashboardCubit>().state;
                if (state is AdminDashboardLoaded) {
                  _exportGuestsToExcel(context, state.invitations);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: "Actualizar",
              onPressed: () =>
                  context.read<AdminDashboardCubit>().loadInvitations(),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Cerrar Sesión",
              onPressed: () async {
                if (GetIt.I.isRegistered<AuthCubit>()) {
                  await GetIt.I<AuthCubit>().logOut();
                }
                if (context.mounted) {
                  await context.router.replace(const LoginRoute());
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
          onPressed: () => _openCreateDialog(context),
          icon: const Icon(Icons.add),
          label: const Text("Nueva Invitación"),
        ),
        body: BlocConsumer<AdminDashboardCubit, AdminDashboardState>(
          listener: (context, state) {
            if (state is AdminDashboardLoaded &&
                state.actionSuccessMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionSuccessMessage!),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: context.colorScheme.primary,
                ),
              );
              context.read<AdminDashboardCubit>().clearActionMessage();
            } else if (state is AdminDashboardError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failure.message),
                  backgroundColor: context.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AdminDashboardLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state is AdminDashboardError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: context.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Error al cargar las invitaciones",
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.failure.message,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context
                            .read<AdminDashboardCubit>()
                            .loadInvitations(),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Reintentar"),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is! AdminDashboardLoaded) {
              return const SizedBox.shrink();
            }

            final invitations = state.filteredInvitations;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: CustomScrollView(
                  slivers: [
                    // 1. Stats Overview Section
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                Text(
                                  "Resumen General",
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                                FilledButton.tonalIcon(
                                  onPressed: () => _exportGuestsToExcel(
                                    context,
                                    state.invitations,
                                  ),
                                  icon: const Icon(
                                    Icons.file_download_outlined,
                                    size: 18,
                                  ),
                                  label: const Text("Descargar Excel"),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: context
                                        .colorScheme.primaryContainer
                                        .withValues(alpha: 0.5),
                                    foregroundColor:
                                        context.colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth > 650;
                                final isNarrow = constraints.maxWidth < 360;
                                final crossAxisCount =
                                    isWide ? 4 : (isNarrow ? 1 : 2);
                                final childAspectRatio =
                                    isWide ? 1.5 : (isNarrow ? 2.3 : 1.15);
                                return GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: childAspectRatio,
                                  children: [
                                    DashboardStatsCard(
                                      title: "Total Invitaciones",
                                      value: "${state.totalInvitations}",
                                      icon: Icons.mail_outline,
                                      color: const Color(0xff30405F),
                                      subtitle:
                                          "${state.sentInvitationsCount} enviadas / ${state.unsentInvitationsCount} pendientes",
                                    ),
                                    DashboardStatsCard(
                                      title: "Total Invitados",
                                      value: "${state.totalGuests}",
                                      icon: Icons.people_outline,
                                      color: const Color(0xff5C80A3),
                                      subtitle: "Cupos asignados",
                                    ),
                                    DashboardStatsCard(
                                      title: "Confirmados",
                                      value: "${state.totalConfirmedGuests}",
                                      icon: Icons.check_circle_outline,
                                      color: Colors.green,
                                      subtitle: state.totalGuests > 0
                                          ? "${((state.totalConfirmedGuests / state.totalGuests) * 100).toStringAsFixed(1)}% del total"
                                          : "0%",
                                    ),
                                    DashboardStatsCard(
                                      title: "Por Responder",
                                      value: "${state.totalPendingGuests}",
                                      icon: Icons.hourglass_empty,
                                      color: Colors.orange,
                                      subtitle:
                                          "${state.totalDeclinedGuests} declinados",
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Preferencias de Menú",
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth > 650;
                                final crossAxisCount = isWide ? 3 : 1;
                                final childAspectRatio = isWide ? 1.8 : 2.2;
                                return GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: childAspectRatio,
                                  children: [
                                    DashboardStatsCard(
                                      title: "Menú Carne",
                                      value: "${state.totalMeatGuests}",
                                      icon: Icons.restaurant,
                                      color: const Color(0xff9E5A22),
                                      subtitle:
                                          "Total de invitados con menú carne",
                                    ),
                                    DashboardStatsCard(
                                      title: "Menú Vegetariano",
                                      value: "${state.totalVegetarianGuests}",
                                      icon: Icons.eco_outlined,
                                      color: const Color(0xff2E7D32),
                                      subtitle:
                                          "Total de invitados vegetarianos",
                                    ),
                                    DashboardStatsCard(
                                      title: "Menú Vegano",
                                      value: "${state.totalVeganGuests}",
                                      icon: Icons.spa_outlined,
                                      color: const Color(0xff558B2F),
                                      subtitle: "Total de invitados veganos",
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 2. Search & Filter Bar
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText:
                                    "Buscar por familia, invitado, nota de dieta o enlace...",
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _searchController.clear();
                                          context
                                              .read<AdminDashboardCubit>()
                                              .updateSearchQuery("");
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: context.colorScheme.surfaceBright,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: context.colorScheme.outline
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              onChanged: (val) => context
                                  .read<AdminDashboardCubit>()
                                  .updateSearchQuery(val),
                            ),
                            const SizedBox(height: 12),
                            // Status Filters
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    "Estado:",
                                    style:
                                        context.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          context.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ...InvitationFilterStatus.values
                                      .map((filter) {
                                    final isSelected =
                                        state.selectedFilter == filter;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: FilterChip(
                                        selected: isSelected,
                                        label: Text(filter.label),
                                        onSelected: (_) => context
                                            .read<AdminDashboardCubit>()
                                            .updateFilter(filter),
                                        selectedColor: context
                                            .colorScheme.primaryContainer
                                            .withValues(alpha: 0.3),
                                        checkmarkColor:
                                            context.colorScheme.primary,
                                        labelStyle: TextStyle(
                                          color: isSelected
                                              ? context.colorScheme.primary
                                              : context
                                                  .colorScheme.onSurfaceVariant,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Dietary Filters
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    "Dieta:",
                                    style:
                                        context.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          context.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ...DietaryFilterStatus.values
                                      .map((dietaryFilter) {
                                    final isSelected =
                                        state.selectedDietaryFilter ==
                                            dietaryFilter;
                                    final (icon, activeColor) =
                                        switch (dietaryFilter) {
                                      DietaryFilterStatus.all => (
                                          Icons.filter_list,
                                          context.colorScheme.primary
                                        ),
                                      DietaryFilterStatus.meat => (
                                          Icons.restaurant,
                                          const Color(0xff9E5A22)
                                        ),
                                      DietaryFilterStatus.vegetarian => (
                                          Icons.eco_outlined,
                                          const Color(0xff2E7D32)
                                        ),
                                      DietaryFilterStatus.vegan => (
                                          Icons.spa_outlined,
                                          const Color(0xff558B2F)
                                        ),
                                      DietaryFilterStatus.none => (
                                          Icons.check_circle_outline,
                                          const Color(0xff5C80A3)
                                        ),
                                    };

                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: FilterChip(
                                        selected: isSelected,
                                        avatar: Icon(
                                          icon,
                                          size: 15,
                                          color: isSelected
                                              ? activeColor
                                              : context
                                                  .colorScheme.onSurfaceVariant,
                                        ),
                                        label: Text(dietaryFilter.label),
                                        onSelected: (_) => context
                                            .read<AdminDashboardCubit>()
                                            .updateDietaryFilter(
                                              dietaryFilter,
                                            ),
                                        selectedColor:
                                            activeColor.withValues(alpha: 0.15),
                                        checkmarkColor: activeColor,
                                        labelStyle: TextStyle(
                                          color: isSelected
                                              ? activeColor
                                              : context
                                                  .colorScheme.onSurfaceVariant,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    // 3. Invitations List
                    if (invitations.isEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.all(40),
                        sliver: SliverToBoxAdapter(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 54,
                                  color: context.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  state.searchQuery.isNotEmpty ||
                                          state.selectedFilter !=
                                              InvitationFilterStatus.all ||
                                          state.selectedDietaryFilter !=
                                              DietaryFilterStatus.all
                                      ? "No se encontraron invitaciones para los filtros seleccionados"
                                      : "No hay invitaciones registradas aún",
                                  textAlign: TextAlign.center,
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                FilledButton.icon(
                                  onPressed: () => _openCreateDialog(context),
                                  icon: const Icon(Icons.add),
                                  label: const Text("Crear Primera Invitación"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final invitation = invitations[index];
                              return InvitationCard(
                                key: ValueKey(invitation.id),
                                invitation: invitation,
                                onEdit: () =>
                                    _openEditDialog(context, invitation),
                                onDelete: () =>
                                    _openDeleteDialog(context, invitation),
                                onToggleSent: (isSent) => context
                                    .read<AdminDashboardCubit>()
                                    .toggleSentStatus(
                                      invitation.id,
                                      isSent,
                                    ),
                                onToggleGuestConfirmation:
                                    (guestId, isConfirmed) => context
                                        .read<AdminDashboardCubit>()
                                        .toggleGuestConfirmation(
                                          invitation.id,
                                          guestId,
                                          isConfirmed,
                                        ),
                              );
                            },
                            childCount: invitations.length,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
