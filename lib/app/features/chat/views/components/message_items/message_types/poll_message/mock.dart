// SPDX-License-Identifier: ice License 1.0

class Poll {
  Poll({required this.question, required this.options});
  final String question;
  final List<PollItem> options;
}

class PollItem {
  PollItem({
    required this.id,
    required this.option,
    required this.votes,
  });
  final String id;
  final String option;
  final int votes;
}

final mockPoll = Poll(
  question: 'What is your favorite color? 🌈. Also feel free to add your own options!',
  options: [
    PollItem(id: '1', option: 'Red', votes: 10),
    PollItem(id: '2', option: 'Blue', votes: 5),
    PollItem(id: '3', option: 'Green', votes: 3),
    PollItem(id: '4', option: 'Yellow', votes: 2),
  ],
);
