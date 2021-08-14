extension DurationExtensions on Duration? {

  String? formatDuration() {
    return this != null 
      ? this.toString().split('.').first.padLeft(8, "0")
      : null;
  }

  String? getLabel() {
    
    var age = this ?? Duration(days: 1);    

    var ago = "vor längerer Zeit";

    if (age.inSeconds < 3) {
      ago = "soeben";
    } else if (age.inSeconds < 30) {
      ago = "vor ein paar Sekunden";
    } else if (age.inMinutes < 2) {
      ago = "vor etwa einer Minute";
    } else if (age.inMinutes < 6) {
      ago = "vor ein paar Minuten";
    } else if (age.inMinutes < 8) {
      ago = "vor einigen Minuten";
    } else if (age.inMinutes < 12) {
      ago = "vor ungefähr 10 Minuten";
    } else if (age.inMinutes < 17) {
      ago = "vor ungefähr einer Viertelstunde";
    } else if (age.inMinutes < 30) {
      ago = "vor mehr als einer Viertelstunde";
    } else if (age.inMinutes < 60) {
      ago = "vor über einer halben Stunde";
    } else if (age.inMinutes < 60) {
      ago = "vor über einer Stunde";
    }

    return ago;
  }

}