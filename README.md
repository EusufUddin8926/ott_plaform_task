# OTT Platform Task

A Flutter-based OTT VOD application built with **BLoC**, **Clean Architecture**, and modern Flutter best practices.

---

## 📥 APK Download
[Download APK](https://drive.google.com/drive/folders/1i_F1vu-0dcIT0N0gkqGVm1Glti9E0NeH?usp=sharing)

---

## Features
- **Dynamic Home Screen**: Banners, Batman category, and Latest Movies sections.
- **Movie Listing**: Paginated movie list with smooth scrolling.
- **Movie Details**: Full details view including plot, cast, and ratings.
- **Video Playback**: Plays trailers or full movies using `video_player` & `chewie`.
- **Offline Caching**: Images cached with `cached_network_image`.
- **State Management**: Robust BLoC pattern with `equatable` for state comparison.
- **Navigation**: Implemented with `go_router`.
- **Testing**: Unit tests for BLoCs and repositories using `bloc_test` and `mocktail`.

---

## Architecture
- **BLoC (Business Logic Component)** for predictable state management.
- **Clean Architecture**:
  - **Domain** – Business logic & entities.
  - **Data** – Repositories, data sources, and models.
  - **Presentation** – UI & BLoCs.
- **Dependency Injection** with `get_it` & `equatable`.
- **Unidirectional Data Flow** – Events → BLoC → States → UI.

---

## Technology & Libraries Used
- **Flutter 3.24.5** / **Dart 3.5.4**
- `flutter_bloc`
- `equatable`
- `dio`
- `fpdart`
- `get_it`
- `go_router`
- `connectivity_plus`
- `cached_network_image`
- `carousel_slider`
- `video_player`
- **Testing**: `bloc_test`, `mocktail`, `flutter_test`

---

## Setup & Running

### 1️⃣ Clone the repository
```bash
git clone https://github.com/yourusername/ott_platform_task.git
cd ott_platform_task
