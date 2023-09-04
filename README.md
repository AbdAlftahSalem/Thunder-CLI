# Flutter GetX MVC Project

This project is a Flutter application scaffolded with GetX and follows the MVC (Model-View-Controller) architecture.

## Project Structure

The project structure is organized as follows:

```
app/
├── components/
│   ├── api_error_widget.dart
│   ├── custom_snackbar.dart
│   └── animated_widget.dart
├── data/
│   ├── local/
│   │   ├── my_shared_pref.dart
│   │   └── hive.dart
├── modules/
│   ├── binding/
│   │   └── home_binding.dart
│   ├── controller/
│   │   └── home_controller.dart
│   └── view/
│    └── home_view.dart
utils/
    ├── constants.dart
    ├── awesome_notifications_helper.dart
    └── fcm_helper.dart

config/
└── translations/
    ├── localization_service.dart
    ├── strings.dart
    ├── ar_ar_translation.dart
    └── en_us_translation.dart
```

### Key Directories

- **`app/`**: The main application directory.
    - **`components/`**: Contains custom UI components like `api_error_widget.dart`, `custom_snackbar.dart`,
      and `animated_widget.dart`.
    - **`data/`**: Handles data operations, including local data storage.
        - **`local/`**: Manages local data with `my_shared_pref.dart` and `hive.dart`.
    - **`modules/`**: Follows the MVC pattern for organizing code.
        - **`binding/`**: Contains GetX bindings. For example, `home_binding.dart`.
        - **`controller/`**: Contains controller logic, such as `home_controller.dart`.
        - **`view/`**: Contains view classes, like `home_view.dart`.
- **`utils/`**: Houses utility functions and constants used throughout the project.
- **`config/translations/`**: Contains localization-related files.
    - **`localization_service.dart`**: Manages localization.
    - **`strings.dart`**: Stores translation keys.
    - **`ar_ar_translation.dart`**: Arabic translations.
    - **`en_us_translation.dart`**: English translations.

## Setup and Running

1. **Clone the Repository**:

   ```shell
   https://github.com/AbdAlftahSalem/Thunder-Creator.git
   ```
