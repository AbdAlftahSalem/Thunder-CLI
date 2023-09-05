# Flutter GetX MVC Project

This project is a Flutter application scaffolded with GetX and follows the MVC (Model-View-Controller) architecture.

## How to Use Thunder CLI

To streamline the process of creating project structures and modules, we've developed a command-line tool called Thunder
CLI. It simplifies the setup of your Flutter project. Below are the available commands and their usage:

### Create a Full Project Structure

Use the following command to create a full project structure:

```bash
thunder_cli --i
```

### Create a Module

Use the following command to create a module:

```bash
thunder_cli --m
```

## Project Structure

The project structure is organized as follows:

```
lib
│
├── app
│   ├── components
│   │   ├── animated_widget
│   │   ├── api_error_widget
│   │   └── custom_snackbar
│   │
│   ├── data
│   │   ├── local
│   │   │   ├── hive
│   │   │   └── my_shared_pref
│   │   └── remote
│   │       ├── api_call_status
│   │       ├── api_exceptions
│   │       └── base_client
│   │
│   ├── modules
│   │   ├── login
│   │   │   ├── binding
│   │   │   │   └── login_binding
│   │   │   ├── controller
│   │   │   │   └── login_controller
│   │   │   └── view
│   │   │       └── login_view
│   │   └── ...
│   │
│   ├── ...
│   │
│   └── main
│
├── config
│   ├── theme
│   │   ├── dark_theme_colors
│   │   ├── light_theme_colors
│   │   ├── my_fonts
│   │   ├── my_style
│   │   └── my_theme
│   │
│   └── translations
│       ├── ar_Ar_translation
│       ├── ar_En_translation
│       ├── localization_service
│       └── strings
│
├── utils
│   ├── awesome_notification_helper
│   ├── constants
│   └── fcm_helper
│
└── main

```

## Directory Descriptions

1. **lib**: This is the root directory of your Flutter project where you'll organize all your source code.

2. **app**: Contains all the code specific to your app. It's where you organize various app-related modules.

    - **components**: Holds reusable components or widgets that are used throughout your app.

    - **data**: Manages data-related code, such as data storage and retrieval.

    - **modules**: Organizes the app's various modules or screens.

3. **config**: Houses configuration-related code.

    - **theme**: Code related to app theming.

    - **translations**: Code for internationalization (i18n) and localization (l10n).

4. **utils**: Utility code and helper classes for your app.

5. **main**: The entry point of your Flutter application.

These directories help you organize your Flutter project into logical sections, making it easier to manage and maintain
your code.

