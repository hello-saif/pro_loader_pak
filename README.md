# Pro Loader

A lightweight Flutter loader package with 50 built-in animated loader styles,
overlay loading, and loading button support.

## Features

* 55 loader types through `ProLoaderType`
* Pure Flutter implementation
* Custom color, size, stroke width, and duration
* Global overlay loader
* Loading button widget

## Installation

```yaml
dependencies:
  pro_loader: ^0.0.4
```

## Usage

```dart
import 'package:pro_loader/pro_loader.dart';
```

Basic loader:

```dart
const ProLoader(
  type: ProLoaderType.wave,
  size: 48,
  color: Colors.blue,
)
```

Overlay loader:

```dart
ProLoaderOverlay.show(
  context,
  type: ProLoaderType.dualRing,
);

ProLoaderOverlay.hide();
```

Loading button:

```dart
ProLoadingButton(
  isLoading: isSubmitting,
  onPressed: submit,
  child: const Text('Submit'),
)
```

## Author

<table>
<tr>
<td width="90">

<!-- <img
  src="https://raw.githubusercontent.com/hello-saif/pro_loader_pak/main/assets/image/author.jpeg"
  width="80"
  style="border-radius:50%;"
  class="rounded-full object-cover"
/> -->
<img
  src="https://raw.githubusercontent.com/hello-saif/pro_loader_pak/main/assets/image/author.jpeg"
  style="
    width: 80px !important;
    height: 104px !important;
    border-radius: 50% !important;
    object-fit: cover !important;
    object-position: center !important;
  "
/>
<td>

### Saifuddin Nobab

Flutter Developer

🌐 GitHub: https://github.com/hello-saif

💼 LinkedIn: https://linkedin.com/in/saifuddin-nobab

📧 Email: mdsaifuddinnobab5@email.com

</td>
</tr>
</table>

## Loader Types

`circleSpin`, `dualRing`, `threeBounce`, `wave`, `pulse`, `fadingCircle`,
`rotatingDots`, `chasingDots`, `cubeGrid`, `foldingCube`, `hourGlass`,
`typingDots`, `linearDots`, `bars`, `equalizer`, `ripple`, `orbit`, `planet`,
`radar`, `wifi`, `heartBeat`, `infinity`, `spinnerLines`, `rotatingSquare`,
`flippingSquare`, `scalingCircle`, `elasticCircle`, `doubleBounce`,
`tripleRing`, `progressRing`, `liquidFill`, `shimmerLine`, `shimmerCard`,
`skeletonList`, `skeletonProfile`, `skeletonGrid`, `buttonLoader`,
`fullscreenLoader`, `dialogLoader`, `overlayLoader`, `uploadLoader`,
`downloadLoader`, `percentageLoader`, `stepLoader`, `routeLoader`,
`pageLoader`, `imageLoader`, `searchLoader`, `paymentLoader`,
`successTransitionLoader`.
