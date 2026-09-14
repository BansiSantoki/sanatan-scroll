# SANATAN SCROLL — PRODUCTION ADMIN PANEL SETUP & USAGE MANUAL

## 1. Overview & Architecture

The **Sanatan Scroll Admin Panel** is a production-ready Flutter Web application constructed in `admin_panel/`. It communicates directly with the live Firebase project (`sanatan-scroll-19b25`) and Cloud Firestore database used by the Sanatan Scroll mobile applications.

### Key Highlights
- **Direct Cloud Firestore Integration**: Any changes (creating books, editing shlokas, scheduling daily readings, unpublishing drafts) immediately update Firestore and sync to mobile clients in real-time.
- **Secure Role Authorization**: Firebase Security Rules block any unauthorized user. Admin status is checked via Firebase Custom Claims (`admin == true`) and Firestore User Document (`users/{uid}.role == "admin"`).
- **Responsive CMS Interface**: Optimized for Desktop/Laptop browser management with tablet and mobile web support.

---

## 2. Firebase Admin Account Setup

To designate an account as an Administrator:

### Option A: Via Firebase Console (Firestore Role)
1. Go to [Firebase Console](https://console.firebase.google.com/) -> Project `sanatan-scroll-19b25`.
2. Navigate to **Authentication** -> **Users** and create or locate the Admin email account (e.g., `admin@sanatanscroll.com`).
3. Copy the user's `UID`.
4. Navigate to **Firestore Database** -> `users` collection -> `{UID}` document.
5. Add/Update the field:
   - Field: `role`
   - Type: `string`
   - Value: `admin`

### Option B: Via Firebase Admin SDK (Custom Claims)
If using Firebase Admin SDK (Node.js/Python script):
```javascript
const admin = require('firebase-admin');
admin.initializeApp();

async function setAdminClaim(uid) {
  await admin.auth().setCustomUserClaims(uid, { admin: true });
  console.log(`Custom claim admin: true set for ${uid}`);
}

setAdminClaim('TARGET_ADMIN_USER_UID');
```

---

## 3. Firebase Security & Storage Rules Deployment

Deploy the included Security Rules to secure your production database and storage bucket:

### Deploying Firestore Rules
From project root (`d:\sanatan-scroll-main`), run:
```bash
firebase deploy --only firestore:rules
```
Or paste the contents of [`firestore.rules`](file:///d:/sanatan-scroll-main/firestore.rules) into the Firebase Console Rules editor.

### Deploying Storage Rules
```bash
firebase deploy --only storage
```
Or paste the contents of [`storage.rules`](file:///d:/sanatan-scroll-main/storage.rules) into Firebase Console Storage Rules.

---

## 4. Running the Admin Panel Locally

To start the Admin Panel on your local machine:

```bash
cd admin_panel
flutter run -d chrome --web-port=8080
```

Access the Admin Panel in Chrome at `http://localhost:8080`.

---

## 5. Production Deployment to Firebase Hosting

To deploy the production Web app bundle to Firebase Hosting:

1. Build the production web bundle:
   ```bash
   cd admin_panel
   flutter build web --release
   ```
2. Deploy to Firebase Hosting from the main repository directory:
   ```bash
   cd ..
   firebase deploy --only hosting
   ```
3. Your Admin Panel will be live at:
   - `https://sanatan-scroll-19b25.web.app`
   - `https://sanatan-scroll-19b25.firebaseapp.com`

---

## 6. Client CMS Usage Guide

### 1. Login & Dashboard
- Log in with your admin credentials.
- The Dashboard displays live counters (Total Users, Sacred Books, Chapters, Verses, Today's Reading) and recent audit logs.

### 2. Sacred Books Management
- Click **Sacred Books** in the sidebar.
- Click **Add Sacred Book** to add a new scripture text (title, English/Gujarati/Hindi translations, cover URL, order).
- Toggle **Published / Draft** status to control visibility on the mobile app.

### 3. Chapter & Verse Content Editor
- Select a book to view its chapters.
- Click **Edit Verses** to open the Verse Content Editor.
- Edit Sanskrit Shlokas, Transliteration, English & Gujarati translations, Meanings, Quotes, Reflections, and Audio URLs per language.

### 4. Daily Readings Scheduling
- Click **Daily Readings** in the sidebar.
- Click **Schedule Daily Reading** and select the target date (YYYY-MM-DD), scripture reference (Book -> Chapter -> Verse), and custom message.

### 5. Media Manager
- Click **Media Storage** to upload book covers or audio recitations directly to Firebase Storage.
- Click **Copy URL** to use the uploaded asset reference in book or verse forms.

### 6. User Management & Analytics
- Search registered mobile app seekers.
- View user reading progress, streak stats, completed chapters, and saved items count without exposing private secrets.
- View real-time activity logs under **Analytics**.
