import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'AIzaSyB9pgTLsu1Kk1pQ5C0En2dYacRNE75HvaY'; // Replace with your actual API key
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<String> sendMessage(String message) async {
    try {
      // Professional veterinary prompt
      final systemPrompt = """
You are VetBot, a professional AI veterinary assistant. You provide helpful, accurate, and compassionate guidance about pet health and care. 

Guidelines:
- Always be professional, caring, and informative
- Provide practical advice for common pet health issues
- Always recommend consulting a real veterinarian for serious concerns
- Include preventive care tips when relevant
- Be specific about symptoms that require immediate veterinary attention
- Use emojis sparingly and appropriately
- Keep responses concise but comprehensive

Remember: You are an assistant, not a replacement for professional veterinary care.

User question: $message
""";

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': systemPrompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            }
          ]
        }),
      );

      print('Gemini API Response Status: ${response.statusCode}');
      print('Gemini API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final content = data['candidates'][0]['content']['parts'][0]['text'];
          return content ?? _getFallbackResponse(message);
        }
      }

      return _getFallbackResponse(message);
    } catch (e) {
      print('Error calling Gemini API: $e');
      return _getFallbackResponse(message);
    }
  }

  static String _getFallbackResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('emergency') || lowerMessage.contains('urgent')) {
      return "��� For any emergency situation, please contact your nearest veterinary emergency clinic immediately or call your regular vet's emergency line.\n\nCommon pet emergencies include:\n• Difficulty breathing\n• Severe bleeding\n• Loss of consciousness\n• Suspected poisoning\n• Severe vomiting or diarrhea\n\nTime is critical in emergencies - don't wait!";
    }

    if (lowerMessage.contains('vaccine') || lowerMessage.contains('vaccination')) {
      return "💉 Vaccinations are crucial for your pet's health!\n\nCore vaccines for dogs: DHPP, Rabies\nCore vaccines for cats: FVRCP, Rabies\n\nPuppies/kittens need a series starting at 6-8 weeks. Adult pets need annual boosters.\n\nConsult your vet for a personalized vaccination schedule based on your pet's lifestyle and risk factors.";
    }

    if (lowerMessage.contains('food') || lowerMessage.contains('diet') || lowerMessage.contains('nutrition')) {
      return "🍽️ Proper nutrition is essential for your pet's health!\n\nKey tips:\n• Choose age-appropriate, high-quality pet food\n• Maintain consistent feeding schedule\n• Avoid human foods toxic to pets (chocolate, grapes, onions)\n• Monitor weight and adjust portions\n• Fresh water should always be available\n\nConsult your vet for specific dietary recommendations based on your pet's needs.";
    }

    return "Thank you for your question about pet health. While I'd love to help, I'm currently having trouble processing your request.\n\nFor the best care for your furry friend, I recommend:\n• Consulting with your veterinarian\n• Calling a pet health hotline\n• Visiting a local animal clinic\n\nYour pet's health and safety are the top priority! 🐾";
  }
}
