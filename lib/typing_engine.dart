class TestResult {
  final double grossSpeed;
  final double netSpeed;
  final double accuracy;
  final int grossWords;
  final int netWords;
  final int totalErrors;
  final int allowedErrors;
  final int penaltyWords;
  final bool isPassed;
  final List<String> feedback;

  TestResult({
    required this.grossSpeed,
    required this.netSpeed,
    required this.accuracy,
    required this.grossWords,
    required this.netWords,
    required this.totalErrors,
    required this.allowedErrors,
    required this.penaltyWords,
    required this.isPassed,
    required this.feedback,
  });
}

class TypingEngine {
  static TestResult calculateResult({
    required String originalText,
    required String typedText,
    required int timeInSeconds,
    required String mode,
  }) {
    double timeInMinutes = timeInSeconds / 60.0;
    if (timeInMinutes <= 0) timeInMinutes = 1.0;

    List<String> originalWords = originalText.trim().split(RegExp(r'\s+'));
    List<String> typedWords = typedText.trim().split(RegExp(r'\s+'));

    int totalErrors = 0;

    if (mode == "BSF") {
      int minLength = typedWords.length < originalWords.length
          ? typedWords.length
          : originalWords.length;

      for (int i = 0; i < minLength; i++) {
        if (typedWords[i] != originalWords[i]) {
          totalErrors++;
        }
      }
      if (originalWords.length > typedWords.length) {
        totalErrors += (originalWords.length - typedWords.length);
      }
    } else {
      int originalIndex = 0;
      for (int i = 0; i < typedWords.length; i++) {
        if (originalIndex < originalWords.length &&
            typedWords[i] == originalWords[originalIndex]) {
          originalIndex++;
        } else {
          totalErrors++;
          originalIndex++;
        }
      }
    }

    int totalStrokes = typedText.length;
    int grossWords = (totalStrokes / 5).floor();
    double grossSpeed = grossWords / timeInMinutes;

    int allowedErrors = (grossWords * 0.05).floor();
    int extraErrors = totalErrors > allowedErrors ? (totalErrors - allowedErrors) : 0;
    int penaltyWords = extraErrors * 10;

    int netWords = grossWords - penaltyWords;
    if (netWords < 0) netWords = 0;

    double netSpeed = netWords / timeInMinutes;
    double accuracy = totalStrokes > 0
        ? ((totalStrokes - (totalErrors * 5)) / totalStrokes) * 100
        : 0.0;
    if (accuracy < 0) accuracy = 0.0;

    bool isPassed = (netSpeed >= 35.0) && (accuracy >= 95.0);

    List<String> feedback = [];
    if (isPassed) {
      feedback.add("Badhiya kaam! Aapne $mode benchmark safalta-purvak clear kar liya hai.");
      feedback.add("Aapki Speed aur Accuracy level test qualify karne ke liye suitable hai.");
    } else {
      if (netSpeed < 35.0) {
        feedback.add("Net speed target (35 WPM) se kam hai. Speed badhane par focus karein.");
      }
      if (totalErrors > allowedErrors) {
        feedback.add("Aapne 5% allowed limit ($allowedErrors mistakes) se zyada galti ($totalErrors mistakes) ki, jisse $penaltyWords words minus huye.");
      }
      feedback.add("Galtiyan kam karne ke liye accuracy aur home-row alignment par dhyan dein.");
    }

    return TestResult(
      grossSpeed: grossSpeed,
      netSpeed: netSpeed,
      accuracy: accuracy,
      grossWords: grossWords,
      netWords: netWords,
      totalErrors: totalErrors,
      allowedErrors: allowedErrors,
      penaltyWords: penaltyWords,
      isPassed: isPassed,
      feedback: feedback,
    );
  }
}
