class RoadmapItem {
  final String emoji;
  final String name;
  final double cost;

  const RoadmapItem({
    required this.emoji,
    required this.name,
    required this.cost,
  });
}

const List<RoadmapItem> savingsRoadmap = [
  RoadmapItem(emoji: '☕', name: 'Cutting chai', cost: 15),
  RoadmapItem(emoji: '🍿', name: 'Movie popcorn', cost: 250),
  RoadmapItem(emoji: '🎬', name: 'Movie ticket', cost: 300),
  RoadmapItem(emoji: '👟', name: 'New sneakers', cost: 1500),
  RoadmapItem(emoji: '🎧', name: 'Wireless earbuds', cost: 2500),
  RoadmapItem(emoji: '📱', name: 'Phone upgrade fund', cost: 15000),
  RoadmapItem(emoji: '✈️', name: 'Weekend getaway', cost: 25000),
];
