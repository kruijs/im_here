extension DurationExtensions on Duration {

  String formatDuration() {
    return this != null 
      ? this.toString().split('.').first.padLeft(8, "0")
      : '';
  }

}