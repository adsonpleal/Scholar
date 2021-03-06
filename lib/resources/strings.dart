import 'package:app_tcc/models/event.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

String get appName => Intl.message(
      'Scholar',
      name: "appName",
    );

String get email => Intl.message(
      'Email',
      name: "email",
    );

String get password => Intl.message(
      'Senha',
      name: "password",
    );

String get login => Intl.message(
      'Entrar',
      name: "login",
    );

String get createAccount => Intl.message(
      'Criar conta',
      name: "createAccount",
    );

String get resetPassword => Intl.message(
      'Resetar senha',
      name: "resetPassword",
    );

String get createAnAccount => Intl.message(
      'Criar uma conta',
      name: "createAnAccount",
    );

String get unknownError => Intl.message(
      'Erro inesperado, tente novamente mais tarde.',
      name: "unknownError",
    );

String get errorUserDisabled => Intl.message(
      'Usuário desativado.',
      name: "errorUserDisabled",
    );

String get errorTooManyRequests => Intl.message(
      'Muitas requisições, tente novamente em instantes.',
      name: "errorTooManyRequests",
    );

String get errorOperationNotAllowed => Intl.message(
      'Operação não permitida.',
      name: "errorOperationNotAllowed",
    );

String get errorWrongCredential => Intl.message(
      'Credencial errada ou expirada.',
      name: "errorWrongCredential",
    );

String get errorEmailAlreadyInUse => Intl.message(
      'O email digitado já está em uso.',
      name: "errorEmailAlreadyInUse",
    );

String get errorWeakPassword => Intl.message(
      'A senha deve conter pelo menos 6 caracteres.',
      name: "errorWeakPassword",
    );

String get errorInvalidEmail => Intl.message(
      'Email inválido, verifique o email digitado.',
      name: "errorInvalidEmail",
    );

String get errorWrongPassword => Intl.message(
      'Senha inválida ou inexistente.',
      name: "errorWrongPassword",
    );

String get errorUserNotFound => Intl.message(
      'Usuário não encontrado.',
      name: "errorUserNotFound",
    );

String get haveAnAccount => Intl.message(
      'Possui uma conta? Entrar',
      name: "haveAnAccount",
    );

String get backToLogin => Intl.message(
      'Voltar para tela de login',
      name: "backToLogin",
    );

String get forgotPassword => Intl.message(
      'Esqueceu sua senha?',
      name: "forgotPassword",
    );

String get emailSent => Intl.message(
      'Email enviado',
      name: "emailSent",
    );

String get emailSentResetPassword => Intl.message(
      'Um email foi enviado com instruções para a redefinição da sua senha',
      name: "emailSentResetPassword",
    );

String get ok => Intl.message(
      'ok',
      name: "ok",
    );

String get home => Intl.message(
      'Home',
      name: "home",
    );

String get agenda => Intl.message(
      'Agenda',
      name: "agenda",
    );

String get profile => Intl.message(
      'Perfil',
      name: "profile",
    );

String get emailCantBeEmpty => Intl.message(
      'Email não pode ficar em branco',
      name: "emailCantBeEmpty",
    );

String get passwordCantBeEmpty => Intl.message(
      'Senha não pode ficar em branco',
      name: "passwordCantBeEmpty",
    );

String get exit => Intl.message(
      'Sair',
      name: "exit",
    );

String get config => Intl.message(
      'Configurações',
      name: "config",
    );

String get contact => Intl.message(
      'Contato',
      name: "contact",
    );

String get connectUfsc => Intl.message(
      'Conectar UFSC',
      name: "connectUfsc",
    );

String get refreshUfsc => Intl.message(
      'Atualizar dados da UFSC',
      name: "refreshUfsc",
    );

String get refreshData => Intl.message(
      'Atualizar dados?',
      name: "refreshData",
    );

String get refreshDataContent => Intl.message(
      'Ao atualizar, seus controles de faltas serão zerados. Essa funcionalidade é para ser utilizada no início de cada semestre.',
      name: "refreshDataContent",
    );

String get foundABug => Intl.message(
      'Encontrou um problema ou tem uma sugestão? ',
      name: "foundABug",
    );

String get notifications => Intl.message(
      'Notificações',
      name: "notifications",
    );

String get generalChannel => Intl.message(
      'Geral',
      name: "generalChannel",
    );

String get generalChannelDescription => Intl.message(
      'Canal geral',
      name: "generalChannelDescription",
    );

String get classNotification => Intl.message(
      'Próxima aula em 10 minutos',
      name: "classNotification",
    );

String get removeAbsence => Intl.message(
      'Remover uma falta',
      name: "removeAbsence",
    );

String get addAbsence => Intl.message(
      'Adicionar uma falta',
      name: "addAbsence",
    );

String get test => Intl.message(
      'Prova',
      name: "test",
    );

String get homework => Intl.message(
      'Trabalho',
      name: "homework",
    );

String get addEvent => Intl.message(
      'Adicionar evento',
      name: "addEvent",
    );

String get showDinner => Intl.message(
      'Mostrar Jantar',
      name: "showDinner",
    );

String get acceptNotification => Intl.message(
      'ADICIONAR',
      name: "acceptNotification",
    );

String get rejectNotification => Intl.message(
      'IGNORAR',
      name: "rejectNotification",
    );

String get information => Intl.message(
      'Informações',
      name: "information",
    );

String get infoAlertContent => Intl.message(
      "Controle de faltas:\n - Cada falta é um período, caso você tenha duas aulas no mesmo dia adicione duas faltas.",
      name: "infoAlertContent",
    );

String get absenceControl => Intl.message(
      'Controle de faltas',
      name: "absenceControl",
    );

String get menu => Intl.message(
      'Cardápio RU',
      name: "menu",
    );

String get newTest => Intl.message(
      'Nova Prova',
      name: "newTest",
    );

String get noSchedule => Intl.message(
      'Sem horários',
      name: "noSchedule",
    );

String get newHomework => Intl.message(
      'Novo Trabalho',
      name: "newHomework",
    );

String get schedules => Intl.message(
      'Grade de horários',
      name: "schedules",
    );

String get eventDescriptionHint => Intl.message(
      'Digite a descrição do evento',
      name: "eventDescriptionHint",
    );

String get removeEvent => Intl.message(
      'Remover evento',
      name: "removeEvent",
    );

String get description => Intl.message(
      'Descrição',
      name: "description",
    );

String get subject => Intl.message(
      'Matéria',
      name: "subject",
    );

String get date => Intl.message(
      'Data',
      name: "date",
    );

String get send => Intl.message(
      "Enviar",
      name: "send",
    );

String get removeEventQuestion => Intl.message(
      "Remover evento?",
      name: "removeEventQuestion",
    );

String get removeEventDescription => Intl.message(
      "O evento será removido permanentemente.",
      name: "removeEventDescription",
    );

String get cancel => Intl.message(
      "CANCELAR",
      name: "cancel",
    );

String get confirm => Intl.message(
      "CONFIRMAR",
      name: "confirm",
    );

String get files => Intl.message(
      "Arquivos",
      name: "files",
    );

String get curricularControl => Intl.message(
      "Controle curricular",
      name: "curricularControl",
    );

String get courseCurriculum => Intl.message(
      "Currículo do curso",
      name: "courseCurriculum",
    );

String get registrationCertificate => Intl.message(
      "Atestado de matrícula",
      name: "registrationCertificate",
    );

String get descriptionCantBeEmpty => Intl.message(
      "Descrição não pode ser vazia",
      name: "descriptionCantBeEmpty",
    );

String get dateCantBeEmpty => Intl.message(
      "Data não pode ser vazia",
      name: "dateCantBeEmpty",
    );

String absences(int absenceCount, int maxAbsence) => Intl.message(
      "Faltas $absenceCount/$maxAbsence",
      name: "absences",
      args: [absenceCount, maxAbsence],
    );

String eventTitle(String subjectName, EventType eventType) => Intl.message(
      "${eventType == EventType.test ? 'Prova' : 'Entrega de trabalho'} da disciplina $subjectName",
      name: "eventTitle",
      args: [subjectName, eventType],
    );

String eventType(EventType eventType) => Intl.message(
      "${eventType == EventType.test ? 'Prova' : 'Entrega de trabalho'}",
      name: "eventType",
      args: [eventType],
    );

String newEvent(EventType eventType) => Intl.message(
      "${eventType == EventType.test ? 'Nova Prova' : 'Novo trabalho'}",
      name: "newEvent",
      args: [eventType],
    );

String eventStart(Event event) => Intl.message(
      "${DateFormat.Hm().format(event.date)}",
      name: "eventStartEnd",
      args: [event],
    );

String notificationSubtitle(Event event) => Intl.message(
      "${event.subject.code} ${DateFormat.MMMd().format(event.date)} ${eventStart(event)}",
      name: "notificationSubtitle",
      args: [event],
    );

String fullDateAndTime(DateTime date) => Intl.message(
      DateFormat('dd/MM/yyy HH:mm').format(date),
      name: "fullDateAndTime",
      args: [date],
    );

String hourMinute(Time time) => Intl.message(
      '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
      name: "hourMinute",
      args: [time],
    );

String weekDay(Day day) => Intl.message(
      [
        'Domingo',
        'Segunda-feira',
        'Terça-feira',
        'Quarta-feira',
        'Quinta-feira',
        'Sexta-feira',
        'Sábado',
      ][day.value - 1],
      name: "weekDay",
      args: [day],
    );
