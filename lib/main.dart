import 'package:flutter/material.dart';
import 'typing_engine.dart';

void main() {
  runApp(const BhagbatTypingApp());
}

class BhagbatTypingApp extends StatelessWidget {
  const BhagbatTypingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhagbat Typing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B132B),
        primaryColor: const Color(0xFF00E676),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E676),
          secondary: Color(0xFFFFD700),
          surface: Color(0xFF1A1F36),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMode = "BSF";
  double durationMinutes = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF00E676), Color(0xFFFFD700)],
                ),
              ),
              child: const Text('B', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            ),
            const SizedBox(width: 12),
            const Text(
              'BHAGBAT TYPING',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFFFFD700)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F36),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _StatItem(title: "Avg Speed", value: "42 WPM", color: Color(0xFFFFD700)),
                  _StatItem(title: "Accuracy", value: "96%", color: Color(0xFF00E676)),
                  _StatItem(title: "Tests", value: "24", color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("Test Configuration", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F36),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedMode = "BSF"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedMode == "BSF" ? const Color(0xFF00E676) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "BSF Mode (Normal)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedMode == "BSF" ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedMode = "CRPF"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedMode == "CRPF" ? const Color(0xFF00E676) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "CRPF Mode (Strict)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedMode == "CRPF" ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text("Test Duration: ${durationMinutes.toInt()} Minutes", style: const TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: durationMinutes,
              min: 1,
              max: 30,
              divisions: 29,
              activeColor: const Color(0xFF00E676),
              inactiveColor: Colors.white12,
              onChanged: (val) => setState(() => durationMinutes = val),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TypingScreen(
                      mode: selectedMode,
                      durationMinutes: durationMinutes.toInt(),
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "START TYPING TEST",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _StatItem({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class TypingScreen extends StatefulWidget {
  final String mode;
  final int durationMinutes;
  const TypingScreen({Key? key, required this.mode, required this.durationMinutes}) : super(key: key);

  @override
  State<TypingScreen> createState() => _TypingScreenState();
}

class _TypingScreenState extends State<TypingScreen> {
  final String sampleText =
      "The Border Security Force and Central Reserve Police Force conduct skill tests to measure typing proficiency and accuracy under pressure.";
  final TextEditingController _controller = TextEditingController();

  void _finishTest() {
    TestResult result = TypingEngine.calculateResult(
      originalText: sampleText,
      typedText: _controller.text,
      timeInSeconds: widget.durationMinutes * 60,
      mode: widget.mode,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.mode} Test (${widget.durationMinutes} Min)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1A1F36), borderRadius: BorderRadius.circular(12)),
              child: Text(sampleText, style: const TextStyle(fontSize: 16, height: 1.5)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Start typing here...",
                filled: true,
                fillColor: const Color(0xFF1A1F36),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _finishTest,
              child: const Text("SUBMIT TEST", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final TestResult result;
  const ResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color themeColor = result.isPassed ? const Color(0xFF00E676) : const Color(0xFFFF5252);

    return Scaffold(
      appBar: AppBar(title: const Text("Test Results")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: themeColor, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    result.isPassed ? "PASSED" : "FAILED",
                    style: TextStyle(color: themeColor, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  const SizedBox(height: 8),
                  Text("Net Speed: ${result.netSpeed.toStringAsFixed(1)} WPM", style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1A1F36), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _ResultRow(label: "Gross Speed", value: "${result.grossSpeed.toStringAsFixed(1)} WPM"),
                  _ResultRow(label: "Accuracy", value: "${result.accuracy.toStringAsFixed(1)}%"),
                  _ResultRow(label: "Total Errors", value: "${result.totalErrors}"),
                  _ResultRow(label: "Allowed Errors (5%)", value: "${result.allowedErrors}"),
                  _ResultRow(label: "Penalty Words Cut", value: "-${result.penaltyWords} Words"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1A1F36), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Detailed Feedback", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ...result.feedback.map((msg) => Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text("• $msg", style: const TextStyle(color: Colors.white70)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
