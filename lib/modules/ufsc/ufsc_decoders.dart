import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/models/subject_time.dart';

List<Subject> decodeSubjects(Map<String, dynamic> json) {
  final subjectsJson =
      json.containsKey('disciplinas') ? json['disciplinas'] : null;
  final timesJson = json.containsKey('horarios') ? json['horarios'] : null;
  final professorsJson = json.containsKey('professores') ? json['professores'] : null;
  final subjects = subjectsJson?.map((subjectJson) {
    final filteredTimesJson = timesJson?.where(
      (ts) => ts['codigoDisciplina'] == subjectJson['codigoDisciplina'],
    );
    final filteredProfessorsJsonObject = professorsJson?.firstWhere(
            (p) =>
                p.containsKey('codigoDisciplina') &&
                subjectJson.containsKey('codigoDisciplina') &&
                p['codigoDisciplina'] == subjectJson['codigoDisciplina'],
            orElse: () => null) ??
        {};
    final filteredProfessorsJson =
        filteredProfessorsJsonObject['professores'] ?? [];
    final times = filteredTimesJson
        ?.map((ts) => SubjectTime(
              (b) => b
                ..startTime = "${ts['horario']}"
                ..center = ts['localizacaoCentro']
                ..weekDay = "${ts['diaSemana']}"
                ..room = ts['localizacaoEspacoFisico'],
            ))
        ?.toList();
    final professors = filteredProfessorsJson
        .map((p) => p.containsKey('nomeProfessor') ? p['nomeProfessor'] : "");
    final filteredTimesJsonSize = filteredTimesJson?.length ?? 0;
    final classGroup =
        (filteredTimesJsonSize > 0 ? filteredTimesJson.first : {})['codigoTurma']
            ?.trim();
    return Subject((b) => b
      ..absenceCount = 0
      ..name = subjectJson['nome'] ?? ""
      ..times.replace(times ?? [])
      ..code = subjectJson['codigoDisciplina'] ?? ""
      ..weeklyClassCount = subjectJson['numeroAulas'] ?? 0
      ..classGroup = classGroup ?? ""
      ..professors.replace(professors ?? []));
  });
  return subjects?.cast<Subject>()?.toList() ?? [];
}
