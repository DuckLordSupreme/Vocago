# Vocago

Vocago is a desktop vocabulary-learning application built with
Java 21 and Swing.

## Run on Windows (no Java installation needed)

Download the Windows installer from this repository's [Releases page](https://github.com/DuckLordSupreme/Vocago/releases), then
run `Vocago-1.0.1.exe` and follow the setup steps. Launch Vocago from the Start
menu or desktop shortcut.

Alternatively, download `Vocago-1.0.1-windows-x64.zip`, extract the entire ZIP,
and open `Vocago/Vocago.exe`. Keep the `app` and `runtime` folders beside the EXE.
These packages include Java and target 64-bit Windows (x64).

You can move the installer EXE and the ZIP anywhere. Once extracted, keep the
whole `Vocago` folder together; the portable `Vocago.exe` cannot run by itself.
For local testing before publishing a release, find both downloads in `dist/`.

The packaged app saves profiles and statistics in `%USERPROFILE%\.vocago\profiles`.
To move existing JAR data, close Vocago and copy the files from `data/profiles`
into that folder. Uninstalling the app does not remove this user data.

## Run the JAR

Requires Java 21:

```sh
java -jar OOP25-Vocago-all.jar
```
## Features

- Multiple user profiles
- Custom vocabulary collections
- Vocabulary practice
- Progress statistics
- Persistent user data

## Technology

Java 21 · Swing · Gradle · JUnit 5

## Documentation

[Technical Report & User Manual](./Project_Report.pdf)

## Preview

![new_profile](project_demo/new_profile_panel.png)
![statistics](project_demo/profile_dashboard.png)
![learning_panel](project_demo/learning_panel.png)
![all_profiles](project_demo/profiles_panels.png)
![my_vocabulary](project_demo/vocabulary_panel.png)
