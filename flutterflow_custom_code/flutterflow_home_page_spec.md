# FlutterFlow Production Visual Builder Guide — Home Page (`/home`)

**Target FlutterFlow Project**: `sanatan-scroll-gxh7pn`  
**Page Name**: `Home`  
**Page Route**: `/home`  
**Backend**: Firebase Project `sanatan-scroll-19b25`

---

## 1. Visual Node Hierarchy & Widget Specs

```
Scaffold (Background: #FAF7F2)
└── SafeArea
    └── SingleChildScrollView (Physics: BouncingScrollPhysics, Padding: 20px Horizontal)
        └── Column (CrossAxisAlignment: Start)
            ├── HomeHeader Component
            ├── DailyWisdomCard Component (Backend Query: daily_readings)
            ├── ContinueJourneyCard Component (Backend Query: users/{uid}/reading_progress)
            └── ExploreScripturesSection Component (Backend Query: books)
```

---

## 2. Detailed Component & Query Configurations

### A. Component 1: `HomeHeader`
- **Greeting Text Widget**:
  - **Text**: `Namaste, ${currentUserDisplayName != null ? currentUserDisplayName.split(' ')[0] : 'Seeker'}`
  - **Font**: `Cormorant Garamond`, SemiBold (600), Size 32px, Color `#1B1B1B`.
- **Streak Pill Button**:
  - **Backend Query**: Single Document from `users/{uid}/streak/current`.
  - **Text Value**: `${streakDoc?.currentStreak ?? 1} ${streakDoc?.currentStreak == 1 ? 'Day' : 'Days'}`
  - **Icon**: `local_fire_department_rounded` (Color `#E46D24`, Size 18px).
  - **Container Styling**: Fill Color `#F7BE78`, Border Radius 20px, Padding (H:14px, V:8px).
  - **OnTap Action**: `Navigate To` → `StreakPage` (`/streak`).

---

### B. Component 2: `DailyWisdomCard` ("Today's Scroll")
- **Backend Query**: Collection Query on `daily_readings` (Limit: 1, Order By: `date desc`).
- **Container Styling**:
  - **Gradient**: Linear Gradient (Top-Left `#6B1F2A` → Bottom-Right `#8B2730`).
  - **Border Radius**: 24px.
  - **Box Shadow**: Color `#6B1F2A` (Opacity 25%), Blur 16px, Y-Offset 8px.
  - **Padding**: 22px all sides.
- **Child Widgets**:
  1. **Tag Row**:
     - Container fill `#FFFFFF` (15% opacity), border radius 12px.
     - Text: `"TODAY'S SCROLL"`, Font: Inter Bold (700), Size 11px, Letter Spacing 1.2px, Color `#FFFFFF`.
  2. **Quote Text**:
     - Text: `“${dailyReadingDoc.quote}”`
     - Font: `Cormorant Garamond`, SemiBold (600), Italic, Size 22px, Color `#FFFFFF`, Line Height 1.35.
  3. **Source Row**:
     - Text: `${dailyReadingDoc.source} — ${dailyReadingDoc.verse}`
     - Font: Inter Medium (500), Size 13px, Color `#FFFFFF` (80% opacity).
  4. **"Read Scroll" Button**:
     - Style: Button Fill `#E8B36B`, Text Color `#4A1018`, Radius 16px.
     - **OnTap Action**: `Navigate To` → `DailyReadingPage` (`/daily-reading`), passing `dailyReadingRef = dailyReadingDoc.reference`.

---

### C. Component 3: `ContinueJourneyCard`
- **Backend Query**: Document Query on `users/{uid}/reading_progress/{selectedBookId}`.
- **Conditional Visibility**:
  - **IF Document Exists**: Show Resume Card with book title and chapter position.
  - **ELSE (Empty State)**: Show "Begin your journey" prompt routing to `/explore`.
- **Card Styling**: Fill Color `#FFFFFF`, Border Radius 20px, Border `#E9E4DE` (1px).
- **Child Widgets**:
  - Icon Avatar: `auto_stories_rounded` (Color `#6B1F2A`).
  - Title: `"Continue Your Journey"`, Font: Cormorant Garamond Bold (700), Size 19px.
  - Subtitle: `${readingProgressDoc.bookId} — Chapter ${readingProgressDoc.chapterNumber}`.
  - **"Resume" Button**: Fill Color `#6B1F2A`, Text Color `#FFFFFF`, Radius 16px.
  - **OnTap Action**: `Navigate To` → `SacredTextReaderPage` (`/sacred-text-reading`), passing `textId = readingProgressDoc.bookId` and `chapterNumber = readingProgressDoc.chapterNumber`.

---

### D. Component 4: `ExploreScripturesSection`
- **Section Label**: `"EXPLORE SCRIPTURES"`, Font: Inter Bold (700), Size 12px, Letter Spacing 1.4px, Color `#827777`.
- **Backend Query**: Collection Query on `books` (Order By: `sequenceAsc`).
- **ListView / Grid Component (`ScriptureCard`)**:
  - **Container Styling**: Fill Color `#4A1018` (Gita), `#2C1810` (Ramayana), `#1A2E1A` (Upanishads), `#3D1F00` (Mahabharata), Border Radius 20px.
  - **Title Text**: `${bookDoc.title}`, Font: Cormorant Garamond Bold (700), Size 24px, Color `#FFFFFF`.
  - **Subtitle Text**: `${bookDoc.subtitle}`, Font: Inter Regular (400), Size 13px, Color `#FFFFFF` (80% opacity).
  - **Arrow Icon**: `arrow_forward_ios_rounded`, Color `#FFFFFF`, Size 18px.
  - **OnTap Action**: `Navigate To` → `SacredTextDetailPage` (`/sacred-text-detail`), passing Page Parameter `bookId = bookDoc.id`.

---

## 3. Placeholder Elimination Audit Checklist

- [x] `[streakCount]` replaced with dynamic Firestore `users/{uid}/streak/current` query.
- [x] `[weeklyScrollCount]` replaced with dynamic weekly streak completion array.
- [x] `"Loading your scroll..."` replaced with real-time `daily_readings` query.
- [x] `"New cards coming soon."` removed and replaced with dynamic `books` list.
- [x] All hardcoded mock strings replaced with dynamic bindings.

---

## 4. Verification Checklist

1. **FlutterFlow Visual Builder**: Page `Home` node tree matches Scaffold -> SafeArea -> SingleChildScrollView -> Column.
2. **Backend Queries**:
   - `users/{uid}/streak/current` (Single Document Query)
   - `daily_readings` (Single Document Query)
   - `users/{uid}/reading_progress` (Document Query)
   - `books` (Collection Query)
3. **Actions & Parameters**:
   - `/streak`
   - `/daily-reading`
   - `/sacred-text-reading` (Parameters: `textId`, `chapterNumber`)
   - `/sacred-text-detail` (Parameter: `bookId`)
