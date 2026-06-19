// Simple index for local story assets (English and Tagalog)
class StoryIndexItem {
  final String slug;
  final String title;
  final String language; // 'en' or 'tl'
  final int pageCount; // currently 1 per story
  final String synopsisPath;
  final String page1Path;
  final String? coverAsset; // optional

  /// Interest topics this story belongs to. Values must match the onboarding
  /// topic labels in `onboarding_flow.dart` so Home's interest rows work
  /// offline (e.g. 'Nature & Animals', 'Fantasy', 'Fun & Adventure').
  final List<String> topics;

  const StoryIndexItem({
    required this.slug,
    required this.title,
    required this.language,
    required this.pageCount,
    required this.synopsisPath,
    required this.page1Path,
    this.coverAsset,
    this.topics = const [],
  });
}

class StoriesIndex {
  static const List<StoryIndexItem> items = [
    // Monkey and Turtle (English + Tagalog)
    StoryIndexItem(
      slug: 'the-monkey-and-the-turtle',
      title: 'The Monkey and the Turtle',
      language: 'en',
      pageCount: 1,
      synopsisPath: 'assets/stories/the-monkey-and-the-turtle/en/synopsis.txt',
      page1Path: 'assets/stories/the-monkey-and-the-turtle/en/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Monkey_and_the_Turtle.png',
      topics: ['Nature & Animals', 'Fun & Adventure', 'P.E. & Health'],
    ),
    StoryIndexItem(
      slug: 'the-monkey-and-the-turtle',
      title: 'Ang Unggoy at ang Pagong',
      language: 'tl',
      pageCount: 1,
      synopsisPath: 'assets/stories/the-monkey-and-the-turtle/tl/synopsis.txt',
      page1Path: 'assets/stories/the-monkey-and-the-turtle/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Monkey_and_the_Turtle.png',
      topics: ['Nature & Animals', 'Fun & Adventure', 'P.E. & Health'],
    ),

    // Alamat ng Saging / Legend of the Banana (Tagalog + English)
    StoryIndexItem(
      slug: 'alamat-ng-saging',
      title: 'Alamat ng Saging (Legend of the Banana)',
      language: 'tl',
      pageCount: 1,
      synopsisPath: 'assets/stories/alamat-ng-saging/tl/synopsis.txt',
      page1Path: 'assets/stories/alamat-ng-saging/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/Alamat_ng_Saging.jpg',
      topics: ['Nature & Animals', 'Fantasy', 'Family & Friends'],
    ),
    StoryIndexItem(
      slug: 'alamat-ng-saging',
      title: 'Legend of the Banana',
      language: 'en',
      pageCount: 1,
      synopsisPath: 'assets/stories/alamat-ng-saging/en/synopsis.txt',
      page1Path: 'assets/stories/alamat-ng-saging/en/pages/001.txt',
      coverAsset: 'assets/images/covers/Alamat_ng_Saging.jpg',
      topics: ['Nature & Animals', 'Fantasy', 'Family & Friends'],
    ),

    // Alamat ng Sampaguita / Legend of the Sampaguita (Tagalog + English)
    StoryIndexItem(
      slug: 'alamat-ng-sampaguita',
      title: 'Alamat ng Sampaguita (Legend of the Sampaguita)',
      language: 'tl',
      pageCount: 1,
      synopsisPath: 'assets/stories/alamat-ng-sampaguita/tl/synopsis.txt',
      page1Path: 'assets/stories/alamat-ng-sampaguita/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/Alamat_ng_Sampaguita.jpg',
      topics: ['Nature & Animals', 'Fantasy', 'Arts'],
    ),
    StoryIndexItem(
      slug: 'alamat-ng-sampaguita',
      title: 'Legend of the Sampaguita',
      language: 'en',
      pageCount: 1,
      synopsisPath: 'assets/stories/alamat-ng-sampaguita/en/synopsis.txt',
      page1Path: 'assets/stories/alamat-ng-sampaguita/en/pages/001.txt',
      coverAsset: 'assets/images/covers/Alamat_ng_Sampaguita.jpg',
      topics: ['Nature & Animals', 'Fantasy', 'Arts'],
    ),

    // The Legend of the Bitter Gourd / Alamat ng Ampalaya (English + Tagalog)
    StoryIndexItem(
      slug: 'the-legend-of-the-bitter-gourd',
      title: 'The Legend of the Bitter Gourd',
      language: 'en',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/The_Legend_of_the_Bitter_Gourd/en/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/The_Legend_of_the_Bitter_Gourd/en/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Legend_of_the_Bitter_Gourd.jpg',
      topics: ['Nature & Animals', 'Fantasy'],
    ),
    StoryIndexItem(
      slug: 'the-legend-of-the-bitter-gourd',
      title: 'Ang Alamat ng Ampalaya',
      language: 'tl',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/The_Legend_of_the_Bitter_Gourd/tl/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/The_Legend_of_the_Bitter_Gourd/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Legend_of_the_Bitter_Gourd.jpg',
      topics: ['Nature & Animals', 'Fantasy'],
    ),

    // The Legend of the Rainbow (English + Tagalog)
    StoryIndexItem(
      slug: 'the-legend-of-the-rainbow',
      title: 'The Legend of the Rainbow',
      language: 'en',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/The_Legend_of_the_Rainbow/en/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/The_Legend_of_the_Rainbow/en/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Legend_of_the_Rainbow.jpeg',
      topics: ['Fantasy', 'Arts', 'Nature & Animals'],
    ),
    StoryIndexItem(
      slug: 'the-legend-of-the-rainbow',
      title: 'Ang Alamat ng Bahaghari',
      language: 'tl',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/The_Legend_of_the_Rainbow/tl/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/The_Legend_of_the_Rainbow/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Legend_of_the_Rainbow.jpeg',
      topics: ['Fantasy', 'Arts', 'Nature & Animals'],
    ),

    // The Lion and the Mouse (English + Tagalog)
    StoryIndexItem(
      slug: 'the-lion-and-the-mouse',
      title: 'The Lion and the Mouse',
      language: 'en',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/The_Lion_and_the_Mouse/en/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/The_Lion_and_the_Mouse/en/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Lion_and_the_Mouse.webp',
      topics: ['Nature & Animals', 'Family & Friends', 'Fun & Adventure'],
    ),
    StoryIndexItem(
      slug: 'the-lion-and-the-mouse',
      title: 'Ang Leon at ang Daga',
      language: 'tl',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/The_Lion_and_the_Mouse/tl/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/The_Lion_and_the_Mouse/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Lion_and_the_Mouse.webp',
      topics: ['Nature & Animals', 'Family & Friends', 'Fun & Adventure'],
    ),

    // The Ant and the Grasshopper (English + Tagalog)
    StoryIndexItem(
      slug: 'the-ant-and-the-grasshopper',
      title: 'The Ant and the Grasshopper',
      language: 'en',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/The_Ant_and_the_Grasshopper/en/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/The_Ant_and_the_Grasshopper/en/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Ant_and_the_Grasshopper.jpg',
      topics: ['Nature & Animals', 'P.E. & Health', 'Family & Friends'],
    ),
    StoryIndexItem(
      slug: 'the-ant-and-the-grasshopper',
      title: 'Ang Langgam at ang Tipaklong',
      language: 'tl',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/The_Ant_and_the_Grasshopper/tl/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/The_Ant_and_the_Grasshopper/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Ant_and_the_Grasshopper.jpg',
      topics: ['Nature & Animals', 'P.E. & Health', 'Family & Friends'],
    ),

    // Why the Ocean Is Salty (English + Tagalog)
    StoryIndexItem(
      slug: 'why-the-ocean-is-salty',
      title: 'Why the Ocean Is Salty',
      language: 'en',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/Why_the_Ocean_Is_Salty/en/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/Why_the_Ocean_Is_Salty/en/pages/001.txt',
      coverAsset: 'assets/images/covers/Why_the_Sea_Is_Salty.jpg',
      topics: ['Nature & Animals', 'Fantasy', 'Fun & Adventure'],
    ),
    StoryIndexItem(
      slug: 'why-the-ocean-is-salty',
      title: 'Kung Bakit Maalat ang Dagat',
      language: 'tl',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/Why_the_Ocean_Is_Salty/tl/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/Why_the_Ocean_Is_Salty/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/Why_the_Sea_Is_Salty.jpg',
      topics: ['Nature & Animals', 'Fantasy', 'Fun & Adventure'],
    ),

    // Why the Sky Is High (English + Tagalog)
    StoryIndexItem(
      slug: 'why-the-sky-is-high',
      title: 'Why the Sky Is High',
      language: 'en',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/Why_the_Sky_Is_High/en/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/Why_the_Sky_Is_High/en/pages/001.txt',
      coverAsset: 'assets/images/covers/Why_the_Sky_Is_High.jpg',
      topics: ['Fantasy', 'Nature & Animals', 'Fun & Adventure'],
    ),
    StoryIndexItem(
      slug: 'why-the-sky-is-high',
      title: 'Bakit Mataas ang Langit',
      language: 'tl',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/Why_the_Sky_Is_High/tl/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/Why_the_Sky_Is_High/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/Why_the_Sky_Is_High.jpg',
      topics: ['Fantasy', 'Nature & Animals', 'Fun & Adventure'],
    ),

    // The Carabao and the Shell (English + Tagalog)
    StoryIndexItem(
      slug: 'the-carabao-and-the-shell',
      title: 'The Carabao and the Shell',
      language: 'en',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/The_Carabao_and_the_Shell/en/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/The_Carabao_and_the_Shell/en/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Carabao_and_the_Shell.jpg',
      topics: ['Nature & Animals', 'Fun & Adventure', 'P.E. & Health'],
    ),
    StoryIndexItem(
      slug: 'the-carabao-and-the-shell',
      title: 'Ang Kalabaw at ang Suso',
      language: 'tl',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/The_Carabao_and_the_Shell/tl/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/The_Carabao_and_the_Shell/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Carabao_and_the_Shell.jpg',
      topics: ['Nature & Animals', 'Fun & Adventure', 'P.E. & Health'],
    ),

    // Stories of Juan Tamad (English + Tagalog)
    StoryIndexItem(
      slug: 'stories-of-juan-tamad',
      title: 'Stories of Juan Tamad',
      language: 'en',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/Stories_of_Juan_Tamad/en/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/Stories_of_Juan_Tamad/en/pages/001.txt',
      coverAsset: 'assets/images/covers/Stories_of_Juan_Tamad.jpeg',
      topics: ['Fun & Adventure', 'Family & Friends', 'Arts'],
    ),
    StoryIndexItem(
      slug: 'stories-of-juan-tamad',
      title: 'Mga Kuwento ni Juan Tamad',
      language: 'tl',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/Stories_of_Juan_Tamad/tl/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/Stories_of_Juan_Tamad/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/Stories_of_Juan_Tamad.jpeg',
      topics: ['Fun & Adventure', 'Family & Friends', 'Arts'],
    ),

    // Legend of the Pineapple (English + Tagalog)
    StoryIndexItem(
      slug: 'legend-of-the-pineapple',
      title: 'Legend of the Pineapple',
      language: 'en',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/Legend_of_the_PineApple/en/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/Legend_of_the_PineApple/en/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Legend_of_the_Pineapple.jpg',
      topics: ['Nature & Animals', 'Fantasy', 'Family & Friends'],
    ),
    StoryIndexItem(
      slug: 'legend-of-the-pineapple',
      title: 'Alamat ng Pinya',
      language: 'tl',
      pageCount: 1,
      synopsisPath:
          'assets/stories/_normalized_stories/Legend_of_the_PineApple/tl/synopsis.txt',
      page1Path:
          'assets/stories/_normalized_stories/Legend_of_the_PineApple/tl/pages/001.txt',
      coverAsset: 'assets/images/covers/The_Legend_of_the_Pineapple.jpg',
      topics: ['Nature & Animals', 'Fantasy', 'Family & Friends'],
    ),
  ];
}
