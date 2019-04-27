import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/routes.dart' as Routes;
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

class NewEventPage extends StatefulWidget {
  @override
  _NewEventPageState createState() => _NewEventPageState();
}

// TODO: fetch real data for subjects
final List<Subject> _subjects = [
  Subject((b) => b
    ..name = "test1"
    ..code = "11111"
    ..classGroup = ""
    ..weeklyClassCount = 1
    ..absenceCount = 1
    ..times = ListBuilder()),
  Subject((b) => b
    ..name = "test2"
    ..code = "22222"
    ..classGroup = ""
    ..weeklyClassCount = 0
    ..absenceCount = 0
    ..times = ListBuilder()),
  Subject((b) => b
    ..name = "test3"
    ..code = "33333"
    ..classGroup = ""
    ..weeklyClassCount = 1
    ..absenceCount = 2
    ..times = ListBuilder()),
  Subject((b) => b
    ..name = "test4"
    ..code = "4444"
    ..classGroup = ""
    ..weeklyClassCount = 2
    ..absenceCount = 1
    ..times = ListBuilder()),
];

class _NewEventPageState extends State<NewEventPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TODO: fetch real data for subjects
  Subject _subject = _subjects[0];
  String _description = '';
  DateTime _date;
  EventType _eventType;
  final dateTextController = TextEditingController();

  Future _selectDate() async {
    final now = DateTime.now();
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year),
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
  }

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
        ..subjectCode = _subject.code
        ..type = _eventType
        ..description = _description);
      // TODO: save event
      print(event);
      Routes.pop(context);
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
          child: Form(
              key: _formKey,
              onChanged: () => _formKey.currentState.validate(),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  TextFormField(
                    onSaved: _onDescriptionChanged,
                    validator: _validateNotEmpty(Strings.descriptionCantBeEmpty),
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
                            isDense: true,
                            onChanged: _onSubjectChanged,
                            items: _subjects
                                .map((Subject subject) => DropdownMenuItem(
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
                        validator: _validateNotEmpty(Strings.dateCantBeEmpty),
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
              ))),
    );
  }
}
