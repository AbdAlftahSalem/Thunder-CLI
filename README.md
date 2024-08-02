<img src="assets/images/logo.png" width="300"/>

# Flutter GetX MVC Project

This project is a Flutter application scaffolded with GetX ( BloC working in it ... ) and follows the MVC (
Model-View-Controller) architecture.

## How to Use Thunder CLI

To streamline the process of creating project structures and modules, we've developed a command-line tool called Thunder
CLI. It simplifies the setup of your Flutter project. Below are the available commands and their usage:

## Installation

To install Thunder CLI, run the following command:

```bash
dart pub global activate thunder_cli
```

## Commands

## Usage

To create and initialize a new Flutter project [ Folders and packages ] with Thunder CLI, use the following command:

```shell
thunder --init
```

This command will set up the following components for your project:

- Main File
- Components for Application (e.g., animated widgets, snackbar)
- Themes (Dark and Light)
- Constants (e.g., colors, strings)
- Routes and App Pages
- Local storage
- Remote storage
- Awesome Notification
- FCM
- Dio Base Client
- Translations (e.g., localization service, strings)
- Publish app to GitHub
- Open the folder in VS code
- Setup GitHub action
- Setup flavor

To create a new Feature , use the following command:

```shell
thunder --feature
```

This command will set up the following components for your module:

- Binding
- Controller
- View
- Add view in routes and app pages

To create a new model via url (e.g., https://jsonplaceholder.typicode.com/posts), use the following command:

```shell
thunder --model
```

This command will set up the following components for your model:

- Model
- Named constructor
- FromJson
- ToJson

To show help, use the following command:

```shell
thunder --h
```

## Project Structure

The project structure URL :

```
https://github.com/abdAlftahSalem/flutter_getx_template.git
```

[Thunder CLI on pub.dev](https://pub.dev/packages/thunder_cli)

## Contributing

Feel free to contribute to this project by opening issues, suggesting new features, or submitting pull requests.

## License

This project is licensed under the MIT License.

---
