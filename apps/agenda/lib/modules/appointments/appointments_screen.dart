import 'package:app_core/app_core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_route_names.dart';
import '../../shared/formatters.dart';
import 'appointments_controller.dart';
import 'appointments_status.dart';
import 'widgets/appointment_tile.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // Every controller this State created is released here - unconditionally.
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 320) {
      context.read<AppointmentsController>().loadNextPage();
    }
  }

  Future<void> _openForm([Appointment? appointment]) async {
    final saved = await Navigator.of(
      context,
    ).pushNamed<bool>(AppRouteNames.appointmentForm, arguments: appointment);
    // `context` crossed an await: prove the State is still mounted.
    if (!mounted || saved != true) return;
    await context.read<AppointmentsController>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              DSSpacing.md,
              0,
              DSSpacing.md,
              DSSpacing.md,
            ),
            child: DSTextField(
              label: 'Search by client',
              controller: _searchController,
              onChanged: context.read<AppointmentsController>().search,
              textInputAction: TextInputAction.search,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
      body: BlocBuilder<AppointmentsController, AppointmentsStatus>(
        builder: (context, status) {
          // Exhaustive over the sealed status - no `default:` branch.
          return switch (status) {
            AppointmentsStatusEmpty() || AppointmentsStatusLoading() =>
              const Center(child: CircularProgressIndicator()),
            AppointmentsStatusError(:final message) => DSEmptyState(
              title: 'Could not load',
              message: message,
              icon: Icons.cloud_off_outlined,
              action: DSButton(
                label: 'Try again',
                onPressed: context.read<AppointmentsController>().load,
              ),
            ),
            AppointmentsStatusSuccess(:final page, :final isLoadingMore) =>
              page.items.isEmpty
                  ? DSEmptyState(
                      title: 'Nothing scheduled',
                      message: 'New appointments will show up here.',
                      action: DSButton(
                        label: 'Add the first one',
                        icon: Icons.add,
                        onPressed: _openForm,
                      ),
                    )
                  : _AppointmentsList(
                      page: page,
                      isLoadingMore: isLoadingMore,
                      scrollController: _scrollController,
                      onRefresh: context.read<AppointmentsController>().load,
                    ),
          };
        },
      ),
    );
  }
}

/// A private widget class, not a `Widget _buildList()` helper.
///
/// A helper method has no element of its own, so it rebuilds with the parent
/// and can never be const. This can be skipped.
class _AppointmentsList extends StatelessWidget {
  const _AppointmentsList({
    required this.page,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onRefresh,
  });

  final Paginated<Appointment> page;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(
          DSSpacing.md,
          DSSpacing.md,
          DSSpacing.md,
          DSSpacing.xxl,
        ),
        itemCount: page.items.length + (isLoadingMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: DSSpacing.sm),
        itemBuilder: (context, index) {
          if (index >= page.items.length) {
            return const Padding(
              padding: EdgeInsets.all(DSSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final appointment = page.items[index];
          return AppointmentTile(
            // A stable key: without it Flutter matches by position and the
            // wrong row keeps the wrong state after an insert.
            key: ValueKey(appointment.id),
            appointment: appointment,
            subtitle: Formatters.dateTime(appointment.scheduledAt),
            onTap: () => Navigator.of(context).pushNamed(
              AppRouteNames.appointmentDetail,
              arguments: appointment.id,
            ),
          );
        },
      ),
    );
  }
}
