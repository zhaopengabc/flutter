import 'package:h_pad/models/common/period.dart';

class TimedTask {
  static const String MIN_DATETIME = '1990-01-01 00:00:00';
  static const String MAX_DATETIME = '4016-06-06 23:59:59';
  static const String INIT_DATETIME = '2019-05-17 18:13:15';
  static const String DATE_FORMAT = 'HH:mm:s';
  static periodToDate(period, date) {
    PeriodModel periodData = PeriodModel.fromJson({'day_of_week': '', 'day_of_month': '', 'month_of_year': ''});
    switch (period) {
      case 0:
        periodData.day_of_week = '';
        periodData.day_of_month = '';
        periodData.month_of_year = '';
        break;
      case 1:
        periodData.day_of_week = '';
        periodData.day_of_month = '';
        periodData.month_of_year = '';
        break;
      case 2:
        periodData.day_of_week = date;
        periodData.day_of_month = '';
        periodData.month_of_year = '';
        break;
      case 3:
        periodData.day_of_week = '';
        periodData.day_of_month = date;
        periodData.month_of_year = '';
        break;
      case 4:
        periodData.day_of_week = '';
        periodData.day_of_month = '';
        periodData.month_of_year = date;
        break;
      default:
        break;
    }
    return periodData;
  }

  static const Period = {
    '0': '不重复',
    '1': '每天',
    '2': '每周',
    '3': '每月',
    '4': '每年',
  };
  static const Week = {
    '1': '日',
    '2': '一',
    '3': '二',
    '4': '三',
    '5': '四',
    '6': '五',
    '7': '六',
  };
  static const Month = {
    '1': '1月',
    '2': '2月',
    '3': '3月',
    '4': '4月',
    '5': '5月',
    '6': '6月',
    '7': '7月',
    '8': '8月',
    '9': '9月',
    '10': '10月',
    '11': '11月',
    '12': '12月',
  };

  //根据周期和日期生成列表的重复方式
  static String executionDate(period, day_of_week, day_of_month, month_of_year) {
    var executionDate = '';
    var dateArray = [];
    switch (period.toString()) {
      case '0':
        executionDate = Period[period];
        break;
      case '1':
        executionDate = Period[period];
        break;
      case '2':
        dateArray = day_of_week;
        day_of_week.sort((a, b) => (int.parse(a) > int.parse(b) ? 1 : -1));
        if (day_of_week.length == 7) {
          executionDate = '每天';

//          if(day_of_week.any((element)=>(element=="1")) && day_of_week.any((element)=>(element=="7"))){
//            executionDate = '周日,工作日,周六';
//          }else if(day_of_week.any((element)=>(element=="1"))){
//            executionDate = '周日,工作日';
//          }else if(day_of_week.any((element)=>(element=="7"))){
//            executionDate = '工作日,周六';
//          }
        } else {
          dateArray.forEach((item) {
            executionDate += Week[item] + ',';
          });
          executionDate = executionDate.substring(0, executionDate.length - 1);
        }
        break;
      case '3':
        dateArray = day_of_month;
        dateArray.forEach((item) {
          executionDate += item + ',';
        });
        executionDate = executionDate.substring(0, executionDate.length - 1);
        break;
      case '4':
        dateArray = month_of_year;
        dateArray.forEach((item) {
          executionDate += Month[item] + ',';
        });
        executionDate = executionDate.substring(0, executionDate.length - 1);
        break;
      default:
        break;
    }
    return executionDate;
  }
}
