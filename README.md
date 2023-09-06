# Flutter GetX MVC Project

This project is a Flutter application scaffolded with GetX and follows the MVC (Model-View-Controller) architecture.

## How to Use Thunder CLI

To streamline the process of creating project structures and modules, we've developed a command-line tool called Thunder
CLI. It simplifies the setup of your Flutter project. Below are the available commands and their usage:

## Installation

To install Thunder CLI, run the following command:

```bash
pub global activate thunder_cli
```

## Commands

### Create a new project

To create a new project and using thunder cli, run the following command:

```bash
flutter create --org com.example --project-name my_project_name .
```

## Usage

To initialize a new Flutter project [ Folders and packages ] with Thunder CLI, use the following command:

```shell
thunder_cli --i
```

This command will set up the following components for your project:

- Local storage
- Remote storage
- Awesome Notification
- FCM
- Dio Base Client
- Themes (Dark and Light)
- Main File
- Routes and App Pages
- Components for Application (e.g., animated widgets, snackbar)
- Constants (e.g., colors, strings)
- Translations (e.g., localization service, strings)

To create a new module, use the following command:

```shell
thunder_cli --m
```

This command will set up the following components for your module:

- Binding
- Controller
- View
- Add view in routes and app pages

To create a new model via url (e.g., https://jsonplaceholder.typicode.com/posts), use the following command:

```shell
thunder_cli --mo
```

This command will set up the following components for your model:

- Model
- FromJson
- ToJson

To create module with model, use the following command:

```shell
thunder_cli --mm
```

This command will set up the following components for your module:

- Binding
- Controller
- View
- Add view in routes and app pages
- Model
- FromJson
- ToJson

This command will set up the folders only for your project:

    ```shell
    thunder_cli --f
    ```

To show help, use the following command:

```shell
thunder_cli --h
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
│   │   ├── models
│   │   └── remote
│   │       ├── api_call_status
│   │       ├── api_exceptions
│   │       ├── base_client
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

[Thunder CLI on pub.dev](https://pub.dev/packages/thunder_cli)

## Contributing

Feel free to contribute to this project by opening issues, suggesting new features, or submitting pull requests.

## License

This project is licensed under the MIT License.

---
