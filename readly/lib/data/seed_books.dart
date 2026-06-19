import '../core/models.dart';

/// Static catalog data used to seed the Firestore `books` collection on
/// first run. See [BookRepository.seedIfEmpty].
final List<Book> seedBooks = [
  Book(
    id: '1',
    title: 'The Three-Body Problem',
    author: 'Liu Cixin',
    description:
        "Set against the backdrop of China's Cultural Revolution, a secret military project sends signals into space to make contact with aliens. A hard sci-fi masterpiece about humanity's first contact with an alien civilization and its terrifying implications.",
    coverUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400',
    rating: 4.6,
    pages: 400,
    year: 2008,
    origin: 'China',
    genres: ['Eastern', 'Sci-Fi'],
    tags: ['#hard-sci-fi', '#alien', '#physics', '#epic'],
  ),
  Book(
    id: '2',
    title: 'The Great Gatsby',
    author: 'F. Scott Fitzgerald',
    description:
        'A classic tale of wealth, love, and the American Dream set in the roaring Jazz Age of 1920s New York.',
    coverUrl:
        'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400',
    rating: 4.2,
    pages: 180,
    year: 1925,
    origin: 'USA',
    genres: ['Western', 'Classic'],
    tags: ['#classic', '#american-dream', '#romance'],
  ),
  Book(
    id: '3',
    title: 'Pachinko',
    author: 'Min Jin Lee',
    description:
        'An epic historical saga that follows a Korean family across four generations, from a small fishing village in early 20th-century Korea to the bustling pachinko parlors of Japan. A story of sacrifice, perseverance, and identity that spans eight decades.',
    coverUrl:
        'https://images.unsplash.com/photo-1529148482759-b35b25c5f217?w=400',
    rating: 4.5,
    pages: 496,
    year: 2017,
    origin: 'Korea',
    genres: ['Eastern', 'Historical'],
    tags: ['#family', '#identity', '#sacrifice', '#saga'],
  ),
  Book(
    id: '4',
    title: 'Convenience Store Woman',
    author: 'Sayaka Murata',
    description:
        'Keiko Furukura has worked at the same convenience store for eighteen years. She is perfectly suited to the job, but society considers her strange for not wanting more from life.',
    coverUrl:
        'https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=400',
    rating: 3.9,
    pages: 163,
    year: 2016,
    origin: 'Japan',
    genres: ['Eastern', 'Literary Fiction'],
    tags: ['#japan', '#society', '#identity'],
  ),
  Book(
    id: '5',
    title: '1984',
    author: 'George Orwell',
    description:
        'In the totalitarian superstate of Oceania, Winston Smith secretly rebels against the Party and its omnipresent surveillance and thought control.',
    coverUrl:
        'https://images.unsplash.com/photo-1495640388908-05fa85288e61?w=400',
    rating: 4.7,
    pages: 328,
    year: 1949,
    origin: 'UK',
    genres: ['Western', 'Dystopian'],
    tags: ['#dystopia', '#politics', '#surveillance'],
  ),
  Book(
    id: '6',
    title: 'Pride and Prejudice',
    author: 'Jane Austen',
    description:
        'The witty Elizabeth Bennet navigates issues of manners, upbringing, morality, and marriage in early 19th-century England.',
    coverUrl:
        'https://images.unsplash.com/photo-1474932430478-367dbb6832c1?w=400',
    rating: 4.3,
    pages: 432,
    year: 1813,
    origin: 'UK',
    genres: ['Western', 'Classic', 'Romance'],
    tags: ['#romance', '#classic', '#england'],
  ),
  Book(
    id: '7',
    title: 'Norwegian Wood',
    author: 'Haruki Murakami',
    description:
        'A nostalgic story of loss and sexuality set in late 1960s Tokyo during a time of student unrest and personal grief.',
    coverUrl:
        'https://images.unsplash.com/photo-1509021436665-8f07dbf5bf1d?w=400',
    rating: 4.4,
    pages: 296,
    year: 1987,
    origin: 'Japan',
    genres: ['Eastern', 'Literary Fiction'],
    tags: ['#japan', '#love', '#nostalgia'],
  ),
  Book(
    id: '8',
    title: 'Bumi Manusia',
    author: 'Pramoedya Ananta Toer',
    description:
        'Set in colonial Dutch East Indies, this novel follows Minke, a native Javanese student who falls in love with Annelies, the daughter of a Dutch concubine.',
    coverUrl:
        'https://images.unsplash.com/photo-1491841550275-ad7854e35ca6?w=400',
    rating: 4.8,
    pages: 370,
    year: 1980,
    origin: 'Indonesia',
    genres: ['Eastern', 'Historical'],
    tags: ['#indonesia', '#colonial', '#love', '#resistance'],
  ),
  Book(
    id: '9',
    title: 'The Alchemist',
    author: 'Paulo Coelho',
    description:
        'A shepherd travels from Spain to Egypt in search of a treasure and discovers the deeper meaning of following a personal legend.',
    coverUrl:
        'https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=400',
    rating: 4.1,
    pages: 208,
    year: 1988,
    origin: 'Brazil',
    genres: ['Western', 'Fable'],
    tags: ['#journey', '#destiny', '#philosophy'],
  ),
  Book(
    id: '10',
    title: 'To Kill a Mockingbird',
    author: 'Harper Lee',
    description:
        'A coming-of-age story set in the American South that explores racial injustice, morality, and empathy through a child’s perspective.',
    coverUrl:
        'https://images.unsplash.com/photo-1509266272358-7701da638078?w=400',
    rating: 4.8,
    pages: 281,
    year: 1960,
    origin: 'USA',
    genres: ['Western', 'Classic'],
    tags: ['#classic', '#justice', '#coming-of-age'],
  ),
  Book(
    id: '11',
    title: 'The Silent Patient',
    author: 'Alex Michaelides',
    description:
        'A psychotherapist becomes obsessed with unlocking the silence of a famous painter who shot her husband and then never spoke again.',
    coverUrl:
        'https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=400',
    rating: 4.0,
    pages: 336,
    year: 2019,
    origin: 'UK',
    genres: ['Western', 'Thriller'],
    tags: ['#thriller', '#mystery', '#psychological'],
  ),
  Book(
    id: '12',
    title: 'The Name of the Wind',
    author: 'Patrick Rothfuss',
    description:
        'The first book in a fantasy saga following the legendary Kvothe as he recounts the truth behind his life and his magic.',
    coverUrl:
        'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400',
    rating: 4.7,
    pages: 662,
    year: 2007,
    origin: 'USA',
    genres: ['Western', 'Fantasy'],
    tags: ['#fantasy', '#magic', '#legend'],
  ),
  Book(
    id: '13',
    title: 'Dune',
    author: 'Frank Herbert',
    description:
        'A sweeping science fiction epic about politics, ecology, and prophecy on the desert planet Arrakis.',
    coverUrl:
        'https://images.unsplash.com/photo-1541963463532-d68292c34b19?w=400',
    rating: 4.7,
    pages: 688,
    year: 1965,
    origin: 'USA',
    genres: ['Western', 'Sci-Fi'],
    tags: ['#sci-fi', '#desert', '#epic'],
  ),
  Book(
    id: '14',
    title: 'The Hobbit',
    author: 'J.R.R. Tolkien',
    description:
        'Bilbo Baggins is swept into an unforgettable adventure with dwarves, dragons, and a ring of power.',
    coverUrl:
        'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400',
    rating: 4.8,
    pages: 310,
    year: 1937,
    origin: 'UK',
    genres: ['Western', 'Fantasy'],
    tags: ['#fantasy', '#adventure', '#classic'],
  ),
  Book(
    id: '15',
    title: 'Atomic Habits',
    author: 'James Clear',
    description:
        'A practical guide to building good habits, breaking bad ones, and making tiny changes that compound.',
    coverUrl:
        'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=400',
    rating: 4.6,
    pages: 320,
    year: 2018,
    origin: 'USA',
    genres: ['Nonfiction', 'Self-Help'],
    tags: ['#habits', '#productivity', '#growth'],
  ),
  Book(
    id: '16',
    title: 'The Secret History',
    author: 'Donna Tartt',
    description:
        'A dark academic novel following a tight-knit group of students whose obsession with beauty turns deadly.',
    coverUrl:
        'https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=400',
    rating: 4.3,
    pages: 559,
    year: 1992,
    origin: 'USA',
    genres: ['Western', 'Literary Fiction'],
    tags: ['#dark-academia', '#mystery', '#literary'],
  ),
  Book(
    id: '17',
    title: 'Sapiens',
    author: 'Yuval Noah Harari',
    description:
        'A sweeping history of humankind that explores how Homo sapiens became the dominant species on Earth.',
    // Use a stable placeholder so the app doesn't show HTTP errors.
    coverUrl: 'https://picsum.photos/id/1025/400/600',
    rating: 4.5,
    pages: 498,
    year: 2011,
    origin: 'Israel',
    genres: ['Nonfiction', 'History'],
    tags: ['#history', '#civilization', '#anthropology'],
  ),
  Book(
    id: '18',
    title: 'The Book Thief',
    author: 'Markus Zusak',
    description:
        'A girl growing up in Nazi Germany finds comfort in stolen books and the power of words.',
    // Use a stable placeholder so the app doesn't show HTTP errors.
    coverUrl: 'https://picsum.photos/id/1005/400/600',
    rating: 4.7,
    pages: 552,
    year: 2005,
    origin: 'Australia',
    genres: ['Western', 'Historical'],
    tags: ['#war', '#books', '#historical'],
  ),
  Book(
    id: '19',
    title: 'Educated',
    author: 'Tara Westover',
    description:
        'A memoir of growing up in a restrictive family and pursuing education as a path to independence.',
    coverUrl:
        'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400',
    rating: 4.6,
    pages: 352,
    year: 2018,
    origin: 'USA',
    genres: ['Nonfiction', 'Memoir'],
    tags: ['#memoir', '#education', '#growth'],
  ),
  Book(
    id: '20',
    title: 'The Midnight Library',
    author: 'Matt Haig',
    description:
        'Between life and death, a woman enters a library of alternate lives and chooses what story to live next.',
    coverUrl:
        'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=400',
    rating: 4.2,
    pages: 304,
    year: 2020,
    origin: 'UK',
    genres: ['Western', 'Fiction'],
    tags: ['#hope', '#choices', '#library'],
  ),
];
