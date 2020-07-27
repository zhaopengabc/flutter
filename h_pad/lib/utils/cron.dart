import 'package:h_pad/models/common/period.dart';

class Cron {
  /**
   * 追加前导 0
   *
   * @param $value
   * @return string
   */
  static appendZero(String value) {
    if (value.length == 0) return '';
    if (value.length < 2) return '0' + value;
    if (value.length >= 2) return value;
  }

  /**
   * 生成cron表达式
   * @param date
   * @param period
   * @returns {string}
   */
  static createCron(repeatType, date, time) {
    var cron;
    var times = time.split(':');
    switch (repeatType) {
      case 0: //2 不重复 [秒 分 时 日 月  ？ 年]
        var dates = date.split('-');
        // console.log('dates' + dates);
        cron = times[2].toInt() +
            ' ' +
            times[1].toInt() +
            ' ' +
            times[0].toInt() +
            ' ' +
            dates[2].toInt() +
            ' ' +
            dates[1].toInt() +
            ' ' +
            '?' +
            ' ' +
            dates[0];
        break;
      case 1: //3 每日 [秒 分 时 * *  ？ *]
        cron = times[2].toInt() +
            ' ' +
            times[1].toInt() +
            ' ' +
            times[0].toInt() +
            ' ' +
            '*' +
            ' ' +
            '*' +
            ' ' +
            '?' +
            ' ' +
            '*';
        break;
      case 2: //4 每周[秒 分 时 ？ *  1,2,3 *]
        cron = times[2].toInt() +
            ' ' +
            times[1].toInt() +
            ' ' +
            times[0].toInt() +
            ' ' +
            '?' +
            ' ' +
            '*' +
            ' ' +
            date +
            ' ' +
            '*';
        break;
      case 3: // 5 每月 [秒 分 时 1,2  * ？ *]
        date = date.join(',');
        cron = times[2].toInt() +
            ' ' +
            times[1].toInt() +
            ' ' +
            times[0].toInt() +
            ' ' +
            date +
            ' ' +
            '*' +
            ' ' +
            '?' +
            ' ' +
            '*';
        break;
      case 4: // 5 每年 [秒 分 时 * 1,2 ？]
        date = date.join(',');
        cron = times[2].toInt() +
            ' ' +
            times[1].toInt() +
            ' ' +
            times[0].toInt() +
            ' ' +
            '*' +
            ' ' +
            date +
            ' ' +
            '?' +
            ' ' +
            '*';
        break;
    }
    // console.log('cron' + cron);
    return cron;
  }

  /**
   * 生成cron表达式
   * @param date
   * @param period
   * @returns {string}
   */
  static createCronNoYear(repeatType, date, time) {
    var cron;
    var times = time.split(':');
    switch (repeatType) {
      case 0: //2 不重复 [秒 分 时 日 月  ？ 年]
        var dates = date.split('-');
        cron = times[2].toInt() +
            ' ' +
            times[1].toInt() +
            ' ' +
            times[0].toInt() +
            ' ' +
            dates[2] +
            ' ' +
            dates[1] +
            ' ' +
            '?' +
            ' ' +
            dates[0];
        break;

      case 1: //3 每日 [秒 分 时 ? * *]
        cron = times[2].toInt() + ' ' + times[1].toInt() + ' ' + times[0].toInt() + ' ' + '*' + ' ' + '*' + ' ' + '?';
        break;

      case 2: //4 每周[秒 分 时 ？ *  1,2,3 *]
        cron = times[2].toInt() + ' ' + times[1].toInt() + ' ' + times[0].toInt() + ' ' + '?' + ' ' + '*' + ' ' + date;
        break;
      case 3: // 5 每月 [秒 分 时 1,2  * ?]
        date = date.day_of_week.join(',');
        cron = times[2].toInt() + ' ' + times[1].toInt() + ' ' + times[0].toInt() + ' ' + date + ' ' + '*' + ' ' + '?';
        break;
    }
    return cron;
  }

  /**
   * 反解析cron表达式
   * @param date
   * @param period
   * @returns {string}
   */
  static parsingCron(crontab) {
    var data;
    //基本格式如下: [秒 分 时 日 月 周 年]
    var list = crontab.split(' ');
    var second = list[0];
    var minute = list[1];
    var hour = list[2];
    var day_of_month = list[3];
    var month = list[4];
    var day_of_week = list[5];
    var year = list.length > 6 ? list[6] : '';
    year != '' ? year = year : year = '*';
    PeriodModel period = PeriodModel.fromJson({'period': 0, 'date': '', 'time': ''});
    if ((day_of_month == '*' && month == '*' && day_of_week == '?' && year == '*') ||
        (day_of_month == '?' && month == '*' && day_of_week == '*')) {
      //每天 [秒 分 时 * *  ？ *]
      period.period = 1;
      period.date = '';
    } else if (month == '*' && day_of_week == '?' && year == '*') {
      //每月 [秒 分 时 1,2  * ？ *]
      period.period = 3;
      period.date = day_of_month;
    } else if (day_of_month == '?' && month == '*' && year == '*') {
      //每周 [秒 分 时 ？ *  1,2,3 *]
      period.period = 2;
      period.date = day_of_week;
    } else if (day_of_month == '*' && day_of_week == '?' && year == '*') {
      //每年 [秒 分 时 * 1,2,3 ? *]
      period.period = 4;
      period.date = month;
    } else {
      //不重复 [秒 分 时 日 月  ？ 年]
      period.period = 0;
      period.date = year + '-' + appendZero(month) + '-' + appendZero(day_of_month);
    }
    period.time = appendZero(hour) + ':' + appendZero(minute) + ":" + appendZero(second);
    return period;
  }
}
