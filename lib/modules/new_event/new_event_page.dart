import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/keyboard.dart';
import 'package:app_tcc/utils/widgets/loading_wrapper.dart';
import 'package:app_tcc/utils/widgets/routing_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'new_event_bloc.dart';
import 'new_event_state.dart';

class NewEventPage extends StatefulWidget {
  @override
  _NewEventPageState createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final NewEventBloc _newEventBloc = inject();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Subject _subject;
  String _description = '';
  DateTime _date;
  EventType _eventType;
  final dateTextController = TextEditingController();

  Future<void> _selectDate() async => dismissKeyboard(
        context,
        onDismissed: () async {
          final now = DateTime.now();
          DateTime picked = await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: now,
            lastDate: DateTime(now.year + 1),
          );
          if (picked != null) {
            TimeOfDay time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: 7,
                  minute: 30,
                ));
            if (time != null) {
              _date = picked.add(Duration(
                hours: time.hour,
                minutes: time.minute,
              ));
              setState(() {
                dateTextController.text = Strings.fullDateAndTime(_date);
              });
            }
          }
        },
      );

  void _onSubjectChanged(Subject subject) {
    setState(() {
      _subject = subject;
    });
  }

  void _onDescriptionChanged(String description) {
    _description = description;
  }

  Function _validateNotEmpty(String message) => (String value) {
        if (value.length < 1) return message;
        return null;
      };

  void _submit() {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      final event = Event((b) => b
        ..date = _date
        ..subject.replace(_subject)
        ..type = _eventType
        ..description = _description);
      _newEventBloc.createEvent(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    _eventType = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _eventType == EventType.test ? Strings.newTest : Strings.newHomework,
        ),
      ),
      body: SafeArea(
          top: false,
          bottom: false,
          child: BlocBuilder(
            bloc: _newEventBloc,
            builder: (context, NewEventState newEventState) {
              _subject ??= newEventState.subjects?.first;
              return LoadingWrapper(
                isLoading: newEventState.loading,
                child: RoutingWrapper(
                  pop: newEventState.created.value,
                  child: Visibility(
                    visible: newEventState.subjects != null,
                    child: Form(
                        key: _formKey,
                        onChanged: () => _formKey.currentState.validate(),
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          children: <Widget>[
                            TextFormField(
                              onSaved: _onDescriptionChanged,
                              validator: _validateNotEmpty(
                                  Strings.descriptionCantBeEmpty),
                              decoration: InputDecoration(
                                icon: Icon(Icons.short_text),
                                hintText: Strings.eventDescriptionHint,
                                labelText: Strings.description,
                              ),
                            ),
                            FormField(
                              builder: (FormFieldState state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    icon: const Icon(Icons.class_),
                                    labelText: Strings.subject,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: _subject,
                                      isExpanded: true,
                                      onChanged: _onSubjectChanged,
                                      items: newEventState.subjects
                                          .map((Subject subject) =>
                                              DropdownMenuItem(
                                                value: subject,
                                                child: Text(subject.name),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            InkWell(
                              onTap: _selectDate,
                              child: IgnorePointer(
                                child: TextFormField(
                                  validator: _validateNotEmpty(
                                      Strings.dateCantBeEmpty),
                                  controller: dateTextController,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.calendar_today),
                                    labelText: Strings.date,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 45),
                              child: SizedBox(
                                height: 40.0,
                                child: RaisedButton(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    color: Colors.blue,
                                    child: Text(
                                      Strings.send,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: _submit),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              );
            },
          )),
    );
  }

  @override
  void dispose() {
    _newEventBloc.dispose();
    super.dispose();
  }
}
