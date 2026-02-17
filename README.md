
---
# TeamClock 🕒

> "A productivity tool built for remote teams to manage time zones, working hours, and availability across distributed members. Built out of a real frustration working across time zones."

**TeamClock** is a sleek productivity suite designed to eliminate the "time zone math" that haunts distributed teams. Instead of juggling multiple clocks, TeamClock provides a visual, interactive way to sync with your global colleagues.
This was designed as a project during my internship.

---

## ✨ Features

* **📱 iOS-Inspired Theme:** A premium, glassmorphic UI designed for a native, high-end user experience.
* **🎚️ 24-Hour Time Slider:** Effortlessly slide through a 24-hour window to see how time changes across all selected zones simultaneously.
* **⏰ International Alarms:** Set alarms tied to specific timezones using robust background services.
* **⏳ Integrated Pomodoro:** A built-in focus timer to help you transition from scheduling to deep work.
* **📊 Timezone Comparison:** Select any timezone to instantly visualize offsets and availability.
* **💾 Persistent Storage:** Powered by **Hive** to ensure settings and preferences are saved locally and load instantly.

---

## 🏗️ Architecture & Tech Stack

The project is built using a **Feature-First MVVM (Model-View-ViewModel)** architecture. This decoupling ensures that business logic remains independent of the UI, making the app scalable and maintainable.

* **Framework:** [Flutter]()
* **State Management:** [Riverpod]() (The **ViewModel** logic)
* **Database:** [Hive]() (Fast local NoSQL storage)
* **Design Pattern:** MVVM

### 📂 Project Structure Map

```text
lib/
├── core/                        # Global resources & Singletons
│   ├── base/                    
│   │   ├── animations/          # Global animation controllers
│   │   ├── controllers/         # Base ViewModels & State logic
│   │   └── dependency_classes/  # Dependency Injection setup
│   ├── theme/                   # iOS-inspired styling & colors
│   └── utilities/               # Static helpers & Extensions
├── root/                        
│   ├── Data/                    # The "Model" Layer
│   │   └── models/              # Hive Objects & Data Entities
│   └── Presentation/            # The "View" & "ViewModel" Layers
│       └── Modules/             
│           ├── Drawer/          # Sidebar navigation
│           ├── Screens/         # Feature-specific Views
│           │   ├── Alarms/      # International alarm UI
│           │   ├── Pomodoro/    # Deep work timer UI
│           │   ├── Settings/    # User preferences UI
│           │   ├── Timezone/    # Timezone comparison & slider UI
│           │   ├── homescreen.dart
│           │   └── ...          
│           └── Widgets/         # Reusable atomic UI components
└── main.dart                    # App entry & Hive initialization

```

---

## 🚀 Getting Started

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/teamclock.git

```


2. **Install dependencies:**
```bash
flutter pub get

```


3. **Run Code Generation:**
*(Required for Hive TypeAdapters and Riverpod Generators)*
```bash
dart run build_runner build --delete-conflicting-outputs

```


4. **Run the app:**
```bash
flutter run

```



## 🛠️ Development Philosophy

This project was **designed and developed from scratch**. Every component, from the custom 24-hour interactive slider to the background-aware alarm system, was crafted to solve the specific friction points of distributed collaboration.

## Screens

<div align="center">
  <video controls autoplay loop muted src="https://github.com/TheMirza009/teamclock/raw/cupertino_ui_updated/teamclock_splash.mp4" title="Splash" width="300"></video>
  <video controls autoplay loop muted src="https://github.com/TheMirza009/teamclock/raw/cupertino_ui_updated/teamclock_screen_showcase.mp4" title="Screens" width="300"></video>
  <video controls autoplay loop muted src="https://github.com/TheMirza009/teamclock/raw/cupertino_ui_updated/teamclock_delete_all.mp4" title="Title" width="300"></video>
</div>
---

*Developed with 🔥 for the global remote community.*

---
