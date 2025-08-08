import 'package:dart_backend/controllers/event_controller.dart';
import 'package:dart_backend/models/event_response.dart';
import 'package:dart_backend/utils/index.dart';
import 'package:dart_backend/views/functions/toastification.dart';
import 'package:dart_backend/views/widgets/components/color_picker_builder.dart';
import 'package:dart_backend/views/widgets/components/date_picker_builder.dart';
import 'package:dart_backend/views/widgets/components/input_builder.dart';
import 'package:dart_backend/views/widgets/components/select_option_builder.dart';
import 'package:dart_backend/views/widgets/components/submit_form_builder.dart';
import 'package:dart_backend/views/widgets/components/time_picker_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class EventForm extends StatefulWidget {
  final EventResponse? model;
  final EventController controller;

  const EventForm({super.key, this.model, required this.controller});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final EventResponse? _model;
  late final EventController _controller;
  final remindOptions = [5, 10, 15, 20];

  @override
  void initState() {
    super.initState();
    _model = widget.model;
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isCreate = _model == null;

    return SubmitFormBuilder(
      formKey: _formKey,
      labelBtn: isCreate ? 'Save' : 'Update',
      iconBtn: isCreate ? Icons.save : Icons.update,
      colorBtn: isCreate ? colors.primary : colors.outline,
      children: [
        InputBuilder(
          isBorderd: true,
          name: 'title',
          label: 'Title',
          initVal: _model?.title ?? '',
          validator: (val) =>
              (val == null || val.isEmpty) ? 'This field is required' : null,
        ),
        _dateTime(),
        _selectOption(),
        InputBuilder(
          isBorderd: true,
          name: 'note',
          label: 'Note',
          maxLines: 2,
          initVal: _model?.note ?? '',
        ),
        ColorPickerBuilder(
          name: 'color',
          initVal: _model?.color,
        ),
      ],
      onSubmit: () async {
        final formState = _formKey.currentState;
        final err = _controller.errorMessage.value;

        if (formState == null) return;
        if (!formState.saveAndValidate()) {
          // show errors in the UI
          return;
        }

        final data = Map<String, dynamic>.from(formState.value);
        // reinject the id for update mode:
        if (!isCreate) {
          data['id'] = _model!.id;
        } else {
          // Ensure we don’t accidentally carry over an old ID:
          data.remove('id');
        }

        final req = EventResponse.formData(data);

        await _controller.saveChange(req);

        if (!context.mounted) return;
        if (err.isNotEmpty) {
          showToast(
            context,
            type: Toast.error,
            autoClose: 5,
            title: 'Create Or Update Failed!',
            message: err,
          );
          debugPrint(err);
        } else if (isCreate) {
          showToast(
            context,
            type: Toast.info,
            title: 'Posted!',
            message: 'Created successfully.',
          );

          await _controller.index();
          _formKey.currentState!.reset();
          Get.back();
        } else {
          showToast(
            context,
            title: 'Changed!',
            message: 'Updated successfully.',
          );

          _formKey.currentState!.reset();
          Get.back();
        }
      },
    );
  }

  Widget _dateTime() {
    return Column(
      spacing: 14,
      children: [
        DatePickerBuilder(
          name: 'event_date',
          label: 'Due Date',
          isBorderd: true,
          initVal: _model?.eventDate ?? dtNow(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TimePickerBuilder(
              name: 'start_time',
              isBorderd: true,
              label: 'Start Time',
              width: .45,
              initVal: _model?.startTime ?? dtNow(),
            ),
            TimePickerBuilder(
              name: 'end_time',
              isBorderd: true,
              label: 'End Time',
              width: .45,
              initVal: _model?.endTime ?? dtNow(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _selectOption() {
    return Wrap(
      children: [
        SelectOptionBuilder<int>(
          name: 'remind_min',
          label: 'Remind',
          initVal: _model?.remindMin ?? 5,
          options: remindOptions.map((item) {
            return DropdownMenuItem<int>(
              value: item,
              child: Text(
                '$item minutes early',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
        SelectOptionBuilder<RepeatRule>(
          name: 'repeat_rule',
          label: 'Repeat',
          initVal: _model?.repeatRule ?? RepeatRule.none,
          formatVal: (val) => (val as RepeatRule).code,
          options: RepeatRule.values.map((item) {
            return DropdownMenuItem<RepeatRule>(
              value: item,
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
        SelectOptionBuilder<Status>(
          label: 'Status',
          name: 'status',
          initVal: _model?.status ?? Status.pending,
          formatVal: (val) => (val as Status).code,
          options: Status.values.map((item) {
            return DropdownMenuItem<Status>(
              value: item,
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
