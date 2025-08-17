# Product Requirements Document (PRD)  
**Project:** Ambigram Generator Mobile App  
**Target Platforms:** Android & iOS  
**Package Name:** `com.cuberix.ambigram`

---

## 1. Purpose
The Ambigram Generator app allows users to create, preview, download, share, and save ambigrams (mirror-symmetric word designs). It provides a creative tool for hobbyists, designers, and casual users.  
The app must be engaging, easy-to-use, stable, monetised (ads + credits system), and configurable remotely (via Firebase Remote Config).

---

## 2. Scope
- Cross-platform mobile app (Flutter, iOS & Android).  
- Clean architecture with **data, domain, presentation** separation.  
- Monetisation via **credits, ads, and optional unlimited credits purchase**.  
- Firebase-driven dynamic configuration (ads, styles, colours, credits, updates).  
- User engagement with notifications and daily reminders.  
- Error handling, analytics, and crash reporting with Firebase Crashlytics.

---

## 3. Features

### 3.1 Core User Journeys
#### Launch & Onboarding
- Splash screen initialises Firebase, Ads, Remote Config, Crashlytics, and Notifications.  
- Forced update modal if build < min version from Remote Config.  
- Optional login (email/password). Guest mode supported.

#### Generate an Ambigram
- Input 1 required word (2–12 letters, alphabet only).  
- Optional 2nd word (same length).  
- Style selection (scrollable chips from Remote Config).  
- Background colour selection (palette from Remote Config).  
- Tap “Generate” → deduct 1 credit.  
- Tap preview → rotate ambigram 180°.  
- Credits persist with SharedPreferences.

#### Download, Share, Save
- “Download Ambigram” opens Preview screen.  
- Rotate preview.  
- Save to gallery (via platform channels).  
- Share via system sheet (includes app store link).  
- Show interstitial ad after every 2 share/save actions.

#### Credits Management
- Credits shown in header.  
- When credits = 0 → show bottom sheet with options:  
  - Watch rewarded ad → +5 credits.  
  - Buy unlimited credits → redirect to store.  
- Credits/unlimited flag stored persistently.

#### Profile
- Displays user profile (guest/default if not logged in).  
- Greets user by name.  
- Logout option if authenticated.

#### Notifications
- Daily local notifications at 3pm & 7pm.  
- Reminders to create ambigrams.  
- Remote configurable in future.

---

### 3.2 Core Features
- **Routing:** go_router (typed routes, guards for auth if enabled).  
- **Theming:** Dark & light modes with custom fonts.  
- **State Management:** Provider (AuthNotifier, Home state, etc.).  
- **Persistence:** SharedPreferences for credits & state.  
- **Remote Config:** Ad units, styles, colours, credits, forced updates.  
- **Ads:** Banner, rewarded, interstitial (Google Mobile Ads).  
- **Analytics:** Firebase Analytics event logging.  
- **Crash Reporting:** Firebase Crashlytics integration.  
- **Notifications:** Daily reminders with flutter_local_notifications.

---

## 4. Non-Functional Requirements
- **Performance:** Async operations, prefetch ads & config.  
- **Reliability:** Graceful offline handling; Crashlytics error capture.  
- **Usability:** Clear UI, haptic/visual feedback, platform guidelines.  
- **Portability:** Flutter app runs on Android & iOS.  
- **Security:** HTTPS only, secure user data, no hardcoded secrets.  
- **Maintainability:** Clean architecture, modular code, documented APIs.  
- **Testability:** Unit tests, widget tests, integration tests for workflows.

---

## 5. Technical Architecture
- **Clean Architecture (DDD):**  
  - **Data Layer:** Remote data sources, repositories.  
  - **Domain Layer:** Entities (User, Profile, HomeModel), Use Cases.  
  - **Presentation Layer:** Screens & widgets (Auth, Home, Preview, Profile, Splash).  
- **Core Services:** Crashlytics, Remote Config, Ads, Notifications, Analytics.  
- **Shared Widgets:** CustomButton, CustomCard, AmbigramTextInput, LoadingIndicator.

---

## 6. Dependencies
- **Routing:** `go_router`  
- **State Management:** `provider`  
- **Firebase:** `firebase_core`, `firebase_crashlytics`, `firebase_remote_config`, `firebase_analytics`  
- **Ads:** `google_mobile_ads`  
- **Network:** `http`, `connectivity_plus`  
- **Persistence:** `shared_preferences`  
- **UI/UX:** `flutter_svg`, `screenshot`, `share_plus`, `path_provider`  
- **Notifications:** `flutter_local_notifications`, `timezone`  

---

## 7. Testing Strategy
- **Unit Tests:** Validators, credit logic, remote config parsing.  
- **Widget Tests:** InputSection, Preview widget, Modals.  
- **Integration Tests:** Full flow (generate → download → save/share).  
- **Crash Simulation:** Verify Crashlytics integration via test crashes.  

---

## 8. Deployment Plan
- **Firebase Setup:** Remote Config defaults, Analytics events, AdMob IDs.  
- **CI/CD:** Automated testing (GitHub Actions / GitLab CI).  
- **Build & Signing:** keystore (Android), provisioning profiles (iOS).  
- **Publishing:** Play Store & App Store (with staged rollout).  
- **Monitoring:** Crashlytics & Analytics dashboards.  

---

## 9. Risks & Mitigations
- **Crash/ANR rejection (Google Play):** Thorough testing, Crashlytics integration.  
- **Network failures:** Show fallback UI, retries, offline-safe credits.  
- **Ad loading errors:** Fallback behaviour, retry logic.  
- **Remote Config index issues:** Validate indices, reset selections gracefully.  

---

## 10. Future Enhancements
- In-app purchase for unlimited credits (native IAP).  
- Style & colour packs as purchasable add-ons.  
- Daily login bonuses.  
- Social sharing leaderboards / gallery.  
- Desktop/Web support.  

---

## 11. Acceptance Criteria
- User can generate, preview, and download ambigrams without crashes.  
- Ads load dynamically via Remote Config.  
- Credits persist and reduce correctly.  
- Forced updates work correctly when build < min version.  
- Notifications trigger daily at correct times.  
- Firebase Analytics logs key user actions.  
- App passes Play Store & App Store review without stability issues.  
