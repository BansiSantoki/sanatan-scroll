import '../models/sacred_text_model.dart';

class MockSacredTexts {
  MockSacredTexts._();

  static const List<SacredTextModel> all = [
    SacredTextModel(
      id: 'bhagavad_gita',
      title: 'Bhagavad Gita',
      subtitle: 'The Song of the Divine',
      description:
          'The Bhagavad Gita is a 700-verse Hindu scripture that is part of the epic Mahabharata. It is a conversation between Lord Krishna and Arjuna on the battlefield, covering dharma, devotion, knowledge and selfless action.',
      category: 'Bhagavad Gita',
      chapters: 18,
      verses: 700,
      pages: 350,
      gradientIndex: 0,
      isFeatured: true,
      iconEmoji: '🪷',
      keyTeachings: ['Dharma', 'Karma', 'Bhakti', 'Selfless Action'],
    ),
    SacredTextModel(
      id: 'ramayana',
      title: 'Ramayana',
      subtitle: 'The Epic of Duty',
      description:
          'The Ramayana is an ancient Sanskrit epic that narrates the life of Lord Rama, his unwavering commitment to dharma, his exile, the battle against Ravana, and his return to Ayodhya. It is a timeless guide to righteous living, ideal leadership, loyalty, love and devotion.',
      category: 'Dharma',
      chapters: 7,
      verses: 24000,
      pages: 500,
      gradientIndex: 1,
      iconEmoji: '🏹',
      keyTeachings: ['Dharma', 'Devotion', 'Relationships', 'Duty & Sacrifice', 'Righteous Leadership'],
    ),
    SacredTextModel(
      id: 'mahabharata',
      title: 'Mahabharata',
      subtitle: 'The Greatest Epic',
      description:
          'The Mahabharata is one of the world\'s longest epic poems, narrating the story of the Bharata dynasty. It is a timeless treasure trove of wisdom on dharma, politics, morality, spirituality, and the human condition.',
      category: 'Dharma',
      chapters: 18,
      verses: 100000,
      pages: 1200,
      gradientIndex: 2,
      iconEmoji: '⚔️',
      keyTeachings: ['Dharma', 'Karma', 'Bhakti', 'Life Lessons'],
    ),
    SacredTextModel(
      id: 'upanishads',
      title: 'Upanishads',
      subtitle: 'Wisdom of the Self',
      description:
          'The Upanishads are a collection of ancient Hindu scriptures that explore the nature of reality, the self (Atman), and the ultimate truth (Brahman). They are the philosophical foundation of Hinduism, offering timeless insights into consciousness, wisdom, and liberation.',
      category: 'Upanishads',
      chapters: 108,
      verses: 0,
      pages: 500,
      gradientIndex: 3,
      iconEmoji: '🕉️',
      keyTeachings: ['Wisdom of the Self', 'Consciousness', 'Brahman', 'Liberation (Moksha)'],
    ),
    SacredTextModel(
      id: 'vedas',
      title: 'Vedas',
      subtitle: 'Ancient Sacred Knowledge',
      description:
          'The Vedas are a large body of religious texts originating in ancient India. They are the oldest scriptures of Hinduism and form the foundation of Sanatan Dharma.',
      category: 'Dharma',
      chapters: 4,
      verses: 20000,
      pages: 800,
      gradientIndex: 4,
      iconEmoji: '📜',
      keyTeachings: ['Ritual', 'Cosmos', 'Sacred Sound', 'Truth'],
    ),
    SacredTextModel(
      id: 'puranas',
      title: 'Puranas',
      subtitle: 'Ancient Lore & Legends',
      description:
          'The Puranas are a vast genre of Indian literature about a wide range of topics, particularly legends and traditional lore about deities, cosmology, and philosophy.',
      category: 'Bhakti',
      chapters: 18,
      verses: 400000,
      pages: 2000,
      gradientIndex: 5,
      iconEmoji: '🌺',
      keyTeachings: ['Devotion', 'Cosmology', 'Legends', 'Dharma'],
    ),
    SacredTextModel(
      id: 'yoga_sutras',
      title: 'Yoga Sutras',
      subtitle: 'Path of Inner Discipline',
      description:
          'The Yoga Sutras of Patanjali is a collection of Sanskrit sutras on the theory and practice of yoga. It is one of the foundational texts of classical yoga philosophy.',
      category: 'Meditation',
      chapters: 4,
      verses: 196,
      pages: 150,
      gradientIndex: 6,
      iconEmoji: '🧘',
      keyTeachings: ['Ashtanga Yoga', 'Meditation', 'Discipline', 'Samadhi'],
    ),
    SacredTextModel(
      id: 'arthashastra',
      title: 'Arthashastra',
      subtitle: 'Science of Governance',
      description:
          'The Arthashastra is an ancient Indian Sanskrit treatise on statecraft, economic policy, and military strategy, attributed to Chanakya.',
      category: 'Dharma',
      chapters: 15,
      verses: 6000,
      pages: 300,
      gradientIndex: 7,
      iconEmoji: '👑',
      keyTeachings: ['Governance', 'Ethics', 'Strategy', 'Economics'],
    ),
    SacredTextModel(
      id: 'karma_yoga',
      title: 'Karma Yoga',
      subtitle: 'Path of Selfless Action',
      description:
          'Karma Yoga is the path of selfless action and service. It teaches performing duties without attachment to results, as described in the Bhagavad Gita.',
      category: 'Karma',
      chapters: 3,
      verses: 43,
      pages: 80,
      gradientIndex: 0,
      iconEmoji: '⚡',
      keyTeachings: ['Selfless Action', 'Duty', 'Detachment', 'Service'],
    ),
    SacredTextModel(
      id: 'meditation',
      title: 'Meditation',
      subtitle: 'Inner Stillness',
      description:
          'Ancient meditation practices from the Vedic and Yogic traditions for cultivating inner peace, awareness, and spiritual growth.',
      category: 'Meditation',
      chapters: 8,
      verses: 0,
      pages: 120,
      gradientIndex: 6,
      iconEmoji: '🌅',
      keyTeachings: ['Mindfulness', 'Breath', 'Stillness', 'Awareness'],
    ),
    SacredTextModel(
      id: 'bhakti',
      title: 'Bhakti',
      subtitle: 'Path of Devotion',
      description:
          'Bhakti is the path of loving devotion to the Divine. It encompasses prayers, hymns, and surrender as means to spiritual realization.',
      category: 'Bhakti',
      chapters: 12,
      verses: 0,
      pages: 200,
      gradientIndex: 5,
      iconEmoji: '❤️',
      keyTeachings: ['Devotion', 'Surrender', 'Love', 'Prayer'],
    ),
    SacredTextModel(
      id: 'self_realization',
      title: 'Self Realization',
      subtitle: 'Knowing the True Self',
      description:
          'Teachings on Atman — the eternal self — and the journey toward realizing one\'s true nature beyond body and mind.',
      category: 'Upanishads',
      chapters: 6,
      verses: 0,
      pages: 180,
      gradientIndex: 3,
      iconEmoji: '✨',
      keyTeachings: ['Atman', 'Brahman', 'Moksha', 'Consciousness'],
    ),
    SacredTextModel(
      id: 'krishna_teachings',
      title: "Krishna's Teachings",
      subtitle: 'Divine Wisdom',
      description:
          'The timeless teachings of Lord Krishna from the Bhagavad Gita and Srimad Bhagavatam, guiding seekers on the path of dharma and devotion.',
      category: 'Bhagavad Gita',
      chapters: 18,
      verses: 700,
      pages: 350,
      gradientIndex: 0,
      iconEmoji: '🦚',
      keyTeachings: ['Bhakti', 'Jnana', 'Karma', 'Raja Yoga'],
    ),
    SacredTextModel(
      id: 'inner_peace',
      title: 'Inner Peace',
      subtitle: 'Finding Tranquility',
      description:
          'Wisdom from across Sanatan scriptures on cultivating peace of mind, equanimity, and harmony in daily life.',
      category: 'Meditation',
      chapters: 5,
      verses: 0,
      pages: 100,
      gradientIndex: 6,
      iconEmoji: '🕊️',
      keyTeachings: ['Equanimity', 'Peace', 'Balance', 'Contentment'],
    ),
    SacredTextModel(
      id: 'shiva_purana',
      title: 'Shiva Purana',
      subtitle: 'Glory of Lord Shiva',
      description:
          'One of the eighteen major Puranas dedicated to Lord Shiva, containing stories, hymns, and philosophical teachings.',
      category: 'Bhakti',
      chapters: 7,
      verses: 24000,
      pages: 600,
      gradientIndex: 2,
      iconEmoji: '🔱',
      keyTeachings: ['Devotion', 'Destruction & Creation', 'Meditation', 'Grace'],
    ),
    SacredTextModel(
      id: 'vishnu_purana',
      title: 'Vishnu Purana',
      subtitle: 'Glory of Lord Vishnu',
      description:
          'One of the most important Puranas, dedicated to Lord Vishnu and his avatars, especially Krishna and Rama.',
      category: 'Bhakti',
      chapters: 6,
      verses: 23000,
      pages: 550,
      gradientIndex: 4,
      iconEmoji: '🪷',
      keyTeachings: ['Avatars', 'Preservation', 'Devotion', 'Cosmology'],
    ),
  ];

  static SacredTextModel? findById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
