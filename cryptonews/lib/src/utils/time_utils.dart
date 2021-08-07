class TimeUtils {
  TimeUtils._();

  static TimeUtils _instance = TimeUtils._();
  factory TimeUtils() => _instance;

  static String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return 'قبل ${diff.inDays} يوم';
    } else if (diff.inHours >= 1) {
      if (diff.inHours == 1)
        return 'قبل ساعة';
      else if (diff.inHours == 2)
        return 'قبل ساعتين';
      else
        return 'قبل ${diff.inHours} ساعات';
    } else if (diff.inMinutes >= 1) {
      return 'قبل ${diff.inMinutes} دقيقة';
    } else if (diff.inSeconds >= 1) {
      return 'قبل ${diff.inSeconds} ثانية';
    } else {
      return 'just now';
    }
  }
}
