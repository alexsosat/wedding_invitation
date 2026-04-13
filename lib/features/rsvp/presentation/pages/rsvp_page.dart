import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:get/get.dart";

import "../../../invitation/business/entities/guest_rsvp_form_entity.dart";
import "../getX/rsvp_controller.dart";

/// Page to display the RSVP form.
class RsvpPage extends StatelessWidget {
  /// Page to display the RSVP form.
  const RsvpPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: GetX<RsvpController>(
          init: RsvpController(),
          builder: (controller) {
            final forms = controller.guestRsvpForms;

            if (forms.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: forms.length,
                    itemBuilder: (context, index) => _GuestRsvpForm(
                      form: forms[index],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.submitRsvp,
                      child: const Text("Guardar"),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class _GuestRsvpForm extends StatefulWidget {
  const _GuestRsvpForm({
    required this.form,
  });

  final GuestRsvpFormEntity form;

  @override
  State<_GuestRsvpForm> createState() => _GuestRsvpFormState();
}

class _GuestRsvpFormState extends State<_GuestRsvpForm> {
  late AttendanceOption? _selectedAttendance;

  @override
  void initState() {
    super.initState();
    _selectedAttendance = widget.form.attendance;
  }

  @override
  void didUpdateWidget(_GuestRsvpForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.form.attendance != widget.form.attendance) {
      _selectedAttendance = widget.form.attendance;
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = widget.form;
    final showFoodOption = _selectedAttendance == AttendanceOption.willGo;

    return Card(
      key: ValueKey(
        "${form.guest.documentId}-${form.attendance}-${form.food}",
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: form.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                form.guest.name,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderDropdown<AttendanceOption>(
                name: "attendance",
                initialValue: form.attendance,
                decoration: const InputDecoration(
                  labelText: "Asistencia",
                  border: OutlineInputBorder(),
                ),
                items: AttendanceOption.values
                    .map(
                      (o) => DropdownMenuItem(
                        value: o,
                        child: Text(o.label),
                      ),
                    )
                    .toList(),
                validator: FormBuilderValidators.required(),
                onChanged: (value) {
                  setState(() => _selectedAttendance = value);
                  if (value == AttendanceOption.wontGo) {
                    form.formKey.currentState?.patchValue({"food": null});
                  }
                },
              ),
              if (showFoodOption) ...[
                const SizedBox(height: 12),
                FormBuilderDropdown<FoodOption>(
                  name: "food",
                  initialValue: form.food,
                  decoration: const InputDecoration(
                    labelText: "Comida",
                    border: OutlineInputBorder(),
                  ),
                  items: FoodOption.values
                      .map(
                        (o) => DropdownMenuItem(
                          value: o,
                          child: Text(o.label),
                        ),
                      )
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
