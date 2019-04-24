import 'package:app_tcc/models/event.dart';
import 'package:intl/intl.dart';

class Strings {
  static String get appName => Intl.message(
        'Scholar',
        name: "appName",
      );
  static String get email => Intl.message(
        'Email',
        name: "email",
      );
  static String get password => Intl.message(
        'Senha',
        name: "password",
      );
  static String get login => Intl.message(
        'Entrar',
        name: "login",
      );
  static String get createAccount => Intl.message(
        'Criar conta',
        name: "createAccount",
      );
  static String get resetPassword => Intl.message(
        'Resetar senha',
        name: "resetPassword",
      );
  static String get createAnAccount => Intl.message(
        'Criar uma conta',
        name: "createAnAccount",
      );
  static String get unknownError => Intl.message(
        'Erro inesperado, tente novamente mais tarde.',
        name: "unknownError",
      );
  static String get errorUserDisabled => Intl.message(
        'Usuário desativado.',
        name: "errorUserDisabled",
      );
  static String get errorTooManyRequests => Intl.message(
        'Muitas requisições, tente novamente em instantes.',
        name: "errorTooManyRequests",
      );
  static String get errorOperationNotAllowed => Intl.message(
        'Operação não permitida.',
        name: "errorOperationNotAllowed",
      );
  static String get errorInvalidEmail => Intl.message(
        'Email inválido, verifique o email digitado.',
        name: "errorInvalidEmail",
      );
  static String get errorWrongPassword => Intl.message(
        'Senha inválida ou inexistente.',
        name: "errorWrongPassword",
      );
  static String get errorUserNotFound => Intl.message(
        'Usuário não encontrado.',
        name: "errorUserNotFound",
      );
  static String get haveAnAccount => Intl.message(
        'Possui uma conta? Entrar',
        name: "haveAnAccount",
      );
  static String get backToLogin => Intl.message(
        'Voltar para tela de login',
        name: "backToLogin",
      );
  static String get forgotPassword => Intl.message(
        'Esqueceu sua senha?',
        name: "forgotPassword",
      );
  static String get emailSent => Intl.message(
        'Email enviado',
        name: "emailSent",
      );
  static String get emailSentResetPassword => Intl.message(
        'Um email foi enviado com instruções para a redefinição da sua senha',
        name: "emailSentResetPassword",
      );
  static String get ok => Intl.message(
        'ok',
        name: "ok",
      );
  static String get home => Intl.message(
        'Home',
        name: "home",
      );
  static String get agenda => Intl.message(
        'Agenda',
        name: "agenda",
      );
  static String get profile => Intl.message(
        'Perfil',
        name: "profile",
      );
  static String get emailCantBeEmpty => Intl.message(
        'Email não pode ficar em branco',
        name: "emailCantBeEmpty",
      );
  static String get passwordCantBeEmpty => Intl.message(
        'Senha não pode ficar em branco',
        name: "passwordCantBeEmpty",
      );
  static String get exit => Intl.message(
        'Sair',
        name: "exit",
      );
  static String get config => Intl.message(
        'Configurações',
        name: "config",
      );
  static String get connectUfsc => Intl.message(
        'Conectar UFSC',
        name: "connectUfsc",
      );
  static String get notifications => Intl.message(
        'Notificações',
        name: "notifications",
      );
  static String get generalChannel => Intl.message(
        'Geral',
        name: "generalChannel",
      );
  static String get generalChannelDescription => Intl.message(
        'Canal geral',
        name: "generalChannelDescription",
      );
  static String get classNotification => Intl.message(
        'Próxima aula em 10 minutos',
        name: "classNotification",
      );
  static get removeAbsence => Intl.message(
        'Remover uma falta',
        name: "removeAbsence",
      );
  static get addAbsence => Intl.message(
        'Adicionar uma falta',
        name: "addAbsence",
      );
  static get test => Intl.message(
        'Prova',
        name: "test",
      );
  static get homework => Intl.message(
        'Trabalho',
        name: "homework",
      );
  static get addEvent => Intl.message(
        'Adicionar evento',
        name: "addEvent",
      );

  static get acceptNotification => Intl.message(
        'ADICIONAR',
        name: "acceptNotification",
      );
  static get rejectNotification => Intl.message(
        'IGNORAR',
        name: "rejectNotification",
      );
  static get informations => Intl.message(
        'Informações',
        name: "informations",
      );
  static get infoAlertContent => Intl.message(
        "Controle de faltas:\n - Cada falta é um período, caso você tenha duas aulas no mesmo dia adicione duas faltas.",
        name: "infoAlertContent",
      );

  static get absenceControl => Intl.message(
        'Controle de faltas',
        name: "absenceControl",
      );
  static String absences(int absenceCount, int maxAbsence) => Intl.message(
        "Faltas $absenceCount/$maxAbsence",
        name: "absences",
        args: [absenceCount, maxAbsence],
      );
  static String eventTitle(String eventCode, EventType eventType) =>
      Intl.message(
        "${eventType == EventType.test ? 'Prova' : 'Entrega de trabalho'} na matéria $eventCode",
        name: "eventTitle",
        args: [eventCode, eventType],
      );
  static String newEvent(EventType eventType) => Intl.message(
        "${eventType == EventType.test ? 'Nova Prova' : 'Novo trabalho'}",
        name: "newEvent",
        args: [eventType],
      );
  static String eventStartEnd(Event event) => Intl.message(
        "${DateFormat.Hm().format(event.date)} - ${DateFormat.Hm().format(event.endTime)}",
        name: "eventStartEnd",
        args: [event],
      );
  static String notificationSubtitle(Event event) => Intl.message(
        "${event.eventCode} ${DateFormat.MMMd().format(event.date)} ${eventStartEnd(event)}",
        name: "notificationSubtitle",
        args: [event],
      );
}
