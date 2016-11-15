![ObjectiveKit - Swift friendly ObjC-Runtime functions ](https://cloud.githubusercontent.com/assets/889949/20280667/af0f6410-aaad-11e6-8723-9e0817e1d656.png)


[![Build Status](https://travis-ci.org/marmelroy/ObjectiveKit.svg?branch=master)](https://travis-ci.org/marmelroy/ObjectiveKit)
[![Version](http://img.shields.io/cocoapods/v/ObjectiveKit.svg)](http://cocoapods.org/?q=ObjectiveKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# ObjectiveKit
ObjectiveKit provides a Swift friendly API for a set of powerful Objective C runtime functions.

## Usage

To use ObjectiveKit:

Import ObjectiveKit at the top of your Swift file.

```swift
import ObjectiveKit
```

To access the functionality of ObjectiveKit you will need to create an ObjectiveClass object typed for the class you want to modify or introspect:

```swift
let viewClass = ObjectiveClass<UIView>()
```

If using for a custom Swift class, make sure that it inherits at some point from NSObject and that it is exposed to the Objective C runtime using the @objc flag.

### Introspection

You can learn more about classes at runtime with these handy introspection methods:
```swift
let mapViewClass = ObjectiveClass<MKMapView>()
let ivars = mapViewClass.ivars() // Returns an array of ivars.
let selectors = mapViewClass.selectors() // Returns an array of selectors.
let properties = mapViewClass.properties() // Returns an array of properties.
let protocols = mapViewClass.protocols() // Returns an array of protocols.
```

### Modifying classes at runtime

Add a pre-existing function from another class to your Objective class:
```swift
let viewClass = ObjectiveClass<UIView>()
viewClass.addSelector(#selector(testSelector), from: self.classForCoder)
let view = UIView()
view.perform(#selector(testSelector))
```

Add a method by providing a custom implementation with a closure:
```swift
let viewClass = ObjectiveClass<UIView>()
viewClass.addMethod(closureName, implementation: {
    print("hello world")
})
let view = UIView()
view.performMethod(closureName)
```

ObjectiveKit also supports exchanging selectors in the same class:
```swift
let viewClass = ObjectiveClass<UIView>()
viewClass.exchangeSelector(#selector(UIView.layoutSubviews), with: #selector(UIView.xxx_layoutSubviews))
```

### Creating classes at runtime

Lastly, you can also create a custom ObjC class at runtime:
```swift
let runtimeClass = RuntimeClass(superclass: UIView.self)
runtimeClass.addIvar(ivarName, type: .Float)
let runtimeObject = runtimeClass.allocate()
runtimeObject.setValue(4.0, forKey: ivarName)
```

## Setting up

### Setting up with [CocoaPods](http://cocoapods.org/?q=ObjectiveKit)
```ruby
source 'https://github.com/CocoaPods/Specs.git'
pod 'ObjectiveKit', '~> 0.1'
```

### Setting up with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Interpolate into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "marmelroy/ObjectiveKit"
```

### Inspiration
- [https://github.com/mikeash/MAObjCRuntime](https://github.com/mikeash/MAObjCRuntime)
