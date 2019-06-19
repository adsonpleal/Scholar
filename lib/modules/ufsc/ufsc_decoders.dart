import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/models/subject_time.dart';

List<Subject> decodeSubjects(Map<String, dynamic> json) {
  final subjectsJson = json['disciplinas'];
  final timesJson = json['horarios'];
  final professorsJson = json['professores'];
  final subjects = subjectsJson.map((subjectJson) {
    final filteredTimesJson = timesJson.where(
      (ts) => ts['codigoDisciplina'] == subjectJson['codigoDisciplina'],
    );
    final filteredProfessorsJson = professorsJson.firstWhere(
      (p) => p['codigoDisciplina'] == subjectJson['codigoDisciplina'],
    )['professores'];
    final times = filteredTimesJson.map((ts) => SubjectTime(
          (b) => b
            ..startTime = "${ts['horario']}"
            ..center = ts['localizacaoCentro']
            ..weekDay = "${ts['diaSemana']}"
            ..room = ts['localizacaoEspacoFisico'],
        ));
    final professors = filteredProfessorsJson.map((p) => p['nomeProfessor']);
    final classGroup = (filteredTimesJson.first ?? {})['codigoTurma']?.trim();
    return Subject((b) => b
      ..absenceCount = 0
      ..name = subjectJson['nome']
      ..times.replace(times)
      ..code = subjectJson['codigoDisciplina']
      ..weeklyClassCount = subjectJson['numeroAulas']
      ..classGroup = classGroup
      ..professors.replace(professors));
  });
  return subjects.cast<Subject>().toList();
}
