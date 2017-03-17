# FRStretchImageView

![language](https://img.shields.io/badge/Language-%20Swift%20-orange.svg)
![CI Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
[![Version](https://img.shields.io/cocoapods/v/FRStretchImageView.svg?style=flat)](http://cocoapods.org/pods/FRStretchImageView)
[![License](https://img.shields.io/cocoapods/l/FRStretchImageView.svg?style=flat)](http://cocoapods.org/pods/FRStretchImageView)
[![Platform](https://img.shields.io/cocoapods/p/FRStretchImageView.svg?style=flat)](http://cocoapods.org/pods/FRStretchImageView)

An easy way to add pull-to-stretch `UIImageView`/`UIView` on top of your `UIScrollView`. This is a similar behavior of Twitter Profile's Header.

<img src="http://felipe.ricieri.me/pods/frstretchimageview_demo.gif" alt="Demo GIF">

## Installation

FRStretchImageView is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```swift
pod "FRStretchImageView"
```

And then run:

`$ pod install`

#### Manual Installation

To manually install `FRStretchImageView`, simply add `FRStretchImageView` files to your project.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Getting start

First of all, you will need to create & set up the `UIScrollView` that will be observed in storyboard. For more information about it, check this Natasha The Robot's tutorial: https://www.natashatherobot.com/ios-autolayout-scrollview/

When you are all set, place your `UIImageView`/`UIView` on top of it and pin the `NSLayoutConstraint`'s you'll need. You don't need to reference them for `FRStretchImageView`, it will do it for you. But in order to make it work properly, there are only 2 conditions:

1) You need to pin a Top `NSLayoutConstraint` from your `UIImageView`/`UIView` (firstItem) to its superview (it may be the "Content View" `UIView` of your `UIScrollView`);

2) You need to pin a Height `NSLayoutConstraint` in your `UIImageView`/`UIView`.

... and subclass it as `FRStretchImageView` (or `FRStretchView`).

## Usage

Now you're ready to add the stretching behavior to your `UIImageView`/`UIView`! You just need to write a single line to make it work:

```swift
myStretchableImage.stretchHeightWhenPulledBy(scrollView: myScroll)
```

Complete example:

```swift
import FRStretchImageView

class MyViewController : UIViewController {
  @IBOutlet weak var myScroll : UIScrollView!
  @IBOutlet weak var myStretchableImage : FRStretchImageView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.myStretchableImage.stretchHeightWhenPulledBy(scrollView: self.myScroll)
  }
}
```

You can also add this behavior to an entire `UIView`:

```swift
import FRStretchImageView

class MyViewController : UIViewController {
  @IBOutlet weak var myScroll : UIScrollView!
  @IBOutlet weak var myStretchableView : FRStretchView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.myStretchableView.stretchHeightWhenPulledBy(scrollView: self.myScroll)
  }
}
```

If your `NSLayoutConstraint` doesn't fill the `FRStretchImageView` rules, you can now set them manually by adding to your code (from v1.2.0):

```swift
self.myStretchableImage.topConstraint = myTopConstraint
self.myStretchableImage.heightConstraint = myHeightConstraint
```

Note: do this after setting your stretchable scroll, otherwise the initial values will be overrided.

## Debug

If you want to receive reports in your log about when the `FRStretchImageView` is allocated/deallocated or you want to listen your `UIScrollView` contentOffset updates, turn the debug mode on:

```swift
myStretchableImage.debug = true // (or myStretchableView.debug = true)
```

## Troubleshooting

`FRStretchImageView` can work around your `IBOutlet`s to add its behavior automatically, but it will only wrap the `IBOutlet`s themselves & its superviews. So if you are using multiples `UIView`s between the `UIScrollView` and `UIImageView`/`UIView` observed, you should set the `clipToBounds = false` on them.

## License

MIT License

Copyright (c) 2017 Felipe Ricieri

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
