# only ToDo

A new Flutter project for graduation project.

### installation

`git clone https://github.com/mw205/only-to-do.git`

and don't forget to:

* `flutter clean`
* `flutter pub get`
* `dart run build_runner build -d`

### colors

to use colors :

`ColorName.color;`

to add colors:

1. go to assets/colors/colors.xml
2. add the colors like this:

   `<color name = "<color_name>">#hex_color</color>`
3. and don't forget to execute this command in the CMD

   `fluttergen -c pubspec.yaml`

### Images

* To access the paths of the images: `Assets.images.imagename.path;`
* To use svg images : `Assets.images.imageName.svg()`

  * It is the same like `SvgPicture.asset("<image-path>")`
* To use the raster assets images  : `Assets.images.imageName.image()`

  * it is the same like `Image.Asset("<image path>")`
* To use the images for image providers : `Assets.images.imageName.provider()`

## Important Notes:

- when dealing with text styles, please ensure that is already instantiated in `lib/core/constants/app_text_styles.dart`, and if it doesn't exist then add it.
- Don't forget to make comments for clarification
  - Each comment should have the date of the update and the reason for it.
- Add localizations to `core/localization/app_localization.dart`

## Lib folder architucture

```
C:.
│   main.dart
│
├───core
│   ├───constants
│   │       app_strings.dart
│   │
│   ├───routes
│   │       app_router.dart
│   │
│   └───styles
│           app_text_styles.dart
│
├───features
│   ├───home
│   │   ├───data
│   │   └───presentation
│   │       └───views
│   │               home_view.dart
│   │
│   └───splash
│       └───presentation
│           └───views
│               │   splash_view.dart
│               │
│               └───widget
│                       splash_view_body.dart
│
└───gen
        assets.gen.dart
        colors.gen.dart
        fonts.gen.dart
```
