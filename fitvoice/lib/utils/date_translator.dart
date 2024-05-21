class DateTranslator {
  String translateWeekDay(String weekDay) {
    switch (weekDay) {
      case 'Monday':
        return 'Lunes';
      case 'Tuesday':
        return 'Martes';
      case 'Wednesday':
        return 'Miércoles';
      case 'Thursday':
        return 'Jueves';
      case 'Friday':
        return 'Viernes';
      case 'Saturday':
        return 'Sábado';
      case 'Sunday':
        return 'Domingo';
      default:
        return 'Error';
    }
  }

  String translateMonth(String month) {
    switch (month) {
      case 'January':
        return 'Enero';
      case 'February':
        return 'Febrero';
      case 'March':
        return 'Marzo';
      case 'April':
        return 'Abril';
      case 'May':
        return 'Mayo';
      case 'June':
        return 'Junio';
      case 'July':
        return 'Julio';
      case 'August':
        return 'Agosto';
      case 'September':
        return 'Septiembre';
      case 'October':
        return 'Octubre';
      case 'November':
        return 'Noviembre';
      case 'December':
        return 'Diciembre';
      default:
        return 'Error';
    }
  }

  List<String> getDate(DateTime date) {
    return [
      translateWeekDay(date.weekday.toString()),
      date.day.toString(),
      translateMonth(date.month.toString()),
      date.year.toString(),
      date.hour.toString(),
    ];
  }
}
