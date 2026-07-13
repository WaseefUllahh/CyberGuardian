import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/app_colors.dart';
import '../models/learning_models.dart';
import '../services/learning_service.dart';

class QuizScreen extends StatefulWidget {
  final Course course;
  final Quiz quiz;

  const QuizScreen({super.key, required this.course, required this.quiz});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final LearningService _learningService = LearningService();
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  int? _selectedOptionIndex;
  bool _quizCompleted = false;
  bool _isSaving = false;

  void _submitAnswer(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (index == widget.quiz.questions[_currentQuestionIndex].correctIndex) {
        _score += 100 ~/ widget.quiz.questions.length;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isAnswered = false;
        _selectedOptionIndex = null;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    setState(() {
      _quizCompleted = true;
      _isSaving = true;
    });

    await _learningService.saveQuizScore(
      widget.quiz.id, 
      widget.course.id, 
      _score, 
      widget.quiz.passPercentage, 
      widget.quiz.xpReward
    );

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final textColor = isDark ? Colors.white : AppColors.dark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(_quizCompleted ? 'Quiz Results' : 'Quiz: ${widget.quiz.title}', style: TextStyle(color: textColor, fontSize: 16)),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        automaticallyImplyLeading: false,
        actions: [
          if (!_quizCompleted)
            IconButton(
              icon: Icon(PhosphorIcons.x(), color: textColor),
              onPressed: () => Navigator.pop(context),
            )
        ],
      ),
      body: SafeArea(
        child: _isSaving 
          ? const Center(child: CircularProgressIndicator()) 
          : (_quizCompleted ? _buildResults(isDark, textColor) : _buildQuestion(isDark, textColor)),
      ),
    );
  }

  Widget _buildQuestion(bool isDark, Color textColor) {
    final question = widget.quiz.questions[_currentQuestionIndex];
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
            backgroundColor: isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandGreen),
          ),
          const SizedBox(height: 24),
          Text(
            'Question ${_currentQuestionIndex + 1} of ${widget.quiz.questions.length}',
            style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            question.text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                return _buildOption(index, question.options[index], question.correctIndex, isDark, textColor);
              },
            ),
          ),
          if (_isAnswered)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedOptionIndex == question.correctIndex ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _selectedOptionIndex == question.correctIndex ? Colors.green.withValues(alpha: 0.5) : Colors.red.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _selectedOptionIndex == question.correctIndex ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill) : PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
                        color: _selectedOptionIndex == question.correctIndex ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedOptionIndex == question.correctIndex ? 'Correct!' : 'Incorrect',
                        style: TextStyle(fontWeight: FontWeight.bold, color: _selectedOptionIndex == question.correctIndex ? Colors.green : Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(question.explanation, style: TextStyle(color: textColor, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isAnswered ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _currentQuestionIndex == widget.quiz.questions.length - 1 ? 'Finish Quiz' : 'Next Question',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(int index, String text, int correctIndex, bool isDark, Color textColor) {
    bool isSelected = _selectedOptionIndex == index;
    bool isCorrect = index == correctIndex;
    
    Color borderColor = isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
    Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    
    if (_isAnswered) {
      if (isCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.withValues(alpha: 0.1);
      } else if (isSelected && !isCorrect) {
        borderColor = Colors.red;
        bgColor = Colors.red.withValues(alpha: 0.1);
      }
    } else if (isSelected) {
      borderColor = AppColors.brandGreen;
      bgColor = AppColors.brandGreen.withValues(alpha: 0.1);
    }

    return GestureDetector(
      onTap: () => _submitAnswer(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 15, color: textColor),
              ),
            ),
            if (_isAnswered && (isCorrect || isSelected))
              Icon(
                isCorrect ? PhosphorIcons.checkCircle(PhosphorIconsStyle.fill) : PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
                color: isCorrect ? Colors.green : Colors.red,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(bool isDark, Color textColor) {
    bool passed = _score >= widget.quiz.passPercentage;

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            passed ? PhosphorIcons.trophy(PhosphorIconsStyle.fill) : PhosphorIcons.warningCircle(PhosphorIconsStyle.fill),
            size: 80,
            color: passed ? Colors.amber : Colors.orange,
          ),
          const SizedBox(height: 24),
          Text(
            passed ? 'Quiz Passed!' : 'Quiz Failed',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 12),
          Text(
            'You scored $_score%',
            style: TextStyle(fontSize: 20, color: passed ? AppColors.brandGreen : Colors.red),
          ),
          const SizedBox(height: 12),
          Text(
            passed 
              ? 'Great job! You earned ${widget.quiz.xpReward} XP.' 
              : 'You need ${widget.quiz.passPercentage}% to pass. Review the material and try again.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: passed ? AppColors.brandGreen : Colors.grey[800],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back to Course', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          if (!passed) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentQuestionIndex = 0;
                  _score = 0;
                  _isAnswered = false;
                  _selectedOptionIndex = null;
                  _quizCompleted = false;
                });
              },
              child: Text('Retry Quiz', style: TextStyle(color: AppColors.brandGreen, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ]
        ],
      ),
    );
  }
}
