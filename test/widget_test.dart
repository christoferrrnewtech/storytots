// Smoke tests for StoryTots offline data helpers.

import 'package:flutter_test/flutter_test.dart';
import 'package:storytots/data/local/password_hash.dart';
import 'package:storytots/data/stories_index.dart';

void main() {
  test('password hashing verifies correct password and rejects wrong one', () {
    final salt = PasswordHash.generateSalt();
    final hash = PasswordHash.hash('s3cret!', salt);
    expect(PasswordHash.verify('s3cret!', salt, hash), isTrue);
    expect(PasswordHash.verify('wrong', salt, hash), isFalse);
  });

  test('every story in the index has at least one interest topic', () {
    expect(StoriesIndex.items, isNotEmpty);
    for (final item in StoriesIndex.items) {
      expect(item.topics, isNotEmpty, reason: 'topics missing for ${item.slug}');
    }
  });
}
