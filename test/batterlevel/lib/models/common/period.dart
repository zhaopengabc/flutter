class PeriodModel {
  int period;
  String date;
  String time;
  String day_of_week;
  String day_of_month;
  String month_of_year;

  PeriodModel.fromJson(Map<String, dynamic> json)
      : period = json['period'],
        date = json['date'],
        time = json['time'],
        day_of_week = json['day_of_week'],
        day_of_month = json['day_of_month'],
        month_of_year = json['month_of_year'];

  Map<String, dynamic> toJson() => {'period': period, 'date': date, 'time': time};
}
