import 'dart:ffi';

class Timeservice {

     List<int> parseTime(String timeString) {

    final List<String> timeParts = timeString.split('-');
    // final double startTime = double.parse(timeParts[0]);

     final List<String> startTime = timeParts[0].split(":");

     final int startHour = int.parse(startTime[0]);
     final int startMinutes = int.parse(startTime[1]);


    return [startHour,startMinutes];
    
  }



}