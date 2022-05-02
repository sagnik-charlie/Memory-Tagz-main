class Question {
  final int id, answer;
  final String question;
  final List<String> options;

  Question(
      {required this.id,
      required this.question,
      required this.answer,
      required this.options});
}

const List sample_data = [
  {
    "id": 1,
    "question": "Where is the Blue Coffee Mug gifted by your Aunt ?",
    "options": [
      'With your Stationery',
      'Inside your cupboard',
      'With your Sunglasses',
      'Mother knows'
    ],
    "answer_index": 2,
  },
  {
    "id": 2,
    "question": "Last known location of your umbrella",
    "options": [
      'Under the dining table',
      'Beside your study table',
      'Inside your almirah',
      'Dont know'
    ],
    "answer_index": 0,
  },
  {
    "id": 3,
    "question": "What is the colour of your hair-dryer ?",
    "options": ['Blue-White', 'Green-White', 'Violet', 'Pink'],
    "answer_index": 0,
  },
  {
    "id": 4,
    "question": "How many gold rings you have in total?",
    "options": ['2', '1', '0', '3'],
    "answer_index": 1,
  },
];
