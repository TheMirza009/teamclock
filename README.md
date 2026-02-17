
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

https://github.com/user-attachments/assets/08bb3c65-1cd1-4da2-9067-0760901a1b3d

https://github.com/user-attachments/assets/98fd76cb-b4fa-4d4c-93f2-bb1d34eced96

https://github.com/user-attachments/assets/ef2d42ee-9787-4d16-8912-6423a420a302

---

*Developed with 🔥 for the global remote community.*

---
