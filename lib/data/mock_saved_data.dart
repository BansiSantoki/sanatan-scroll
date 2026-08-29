import '../models/saved_item_model.dart';

class MockSavedData {
  MockSavedData._();

  static const List<SavedItemModel> initial = [
    SavedItemModel(
      id: 's1',
      type: SavedItemType.verse,
      title: 'On Selfless Action',
      content:
          'You have the right to perform your duty, but not to the fruits of your actions.',
      source: 'Bhagavad Gita — Ch. 2, V. 47',
    ),
    SavedItemModel(
      id: 's2',
      type: SavedItemType.verse,
      title: 'On Equanimity',
      content:
          'Perform action, O Arjuna, being steadfast in yoga, abandoning attachment and balanced in success and failure.',
      source: 'Bhagavad Gita — Ch. 2, V. 48',
    ),
    SavedItemModel(
      id: 's3',
      type: SavedItemType.reading,
      title: 'Morning Wisdom',
      content:
          'As the sun rises, let this wisdom illuminate your path. True freedom lies in acting without attachment.',
      source: 'Daily Flow',
    ),
    SavedItemModel(
      id: 's4',
      type: SavedItemType.reflection,
      title: 'Letting Go',
      content:
          'Today I choose to release worry about outcomes and trust in the process of my spiritual journey.',
      source: 'Personal Reflection',
    ),
    SavedItemModel(
      id: 's5',
      type: SavedItemType.verse,
      title: 'On the Eternal Self',
      content:
          'The soul is neither born, nor does it ever die. It is unborn, eternal, ever-existing, and primeval.',
      source: 'Bhagavad Gita — Ch. 2, V. 20',
    ),
    SavedItemModel(
      id: 's6',
      type: SavedItemType.reading,
      title: 'Dharma in Daily Life',
      content:
          'Dharma is not merely ritual — it is the righteous path we walk each day through our choices.',
      source: 'Daily Flow',
    ),
  ];
}
