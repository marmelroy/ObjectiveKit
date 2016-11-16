![ObjectiveKit - Swift friendly ObjC-Runtime functions ](https://cloud.githubusercontent.com/assets/889949/20305900/0e2db7c8-ab38-11e6-8aea-3556c34bfd21.png)

# ObjectiveKit
ObjectiveKit provides a Swift friendly API for a set of powerful Objective C runtime functions.

## Usage

To use ObjectiveKit:

Import ObjectiveKit at the top of your Swift file:
```swift
import ObjectiveKit
```

The next step is to create an ObjectiveClass object typed for the class you want to modify or introspect:
```swift
let viewClass = ObjectiveClass<UIView>()
```

If using ObjectiveKit on a custom Swift class, make sure that it inherits at some point from NSObject and that it is exposed to the Objective C runtime using the @objc flag.

### Introspection

You can learn more about classes at runtime with these handy introspection methods:
```swift
let mapViewClass = ObjectiveClass<MKMapView>()
let ivars = mapViewClass.ivars // An array of ivars.
let selectors = mapViewClass.selectors // An array of selectors.
let properties = mapViewClass.properties // An array of properties.
let protocols = mapViewClass.protocols // An array of protocols.
```

### Modifying classes at runtime

Add a pre-existing selector from another class to your ObjectiveClass:
```swift
let viewClass = ObjectiveClass<UIView>()
viewClass.addSelector(#selector(testSelector), from: self.classForCoder)
let view = UIView()
view.perform(#selector(testSelector))
```

Add a custom method by providing the implementation with a closure:
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
pod 'ObjectiveKit', '~> 0.2'
```

### Setting up with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate ObjectiveKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "marmelroy/ObjectiveKit"
```

### Inspiration
- [https://github.com/mikeash/MAObjCRuntime](https://github.com/mikeash/MAObjCRuntime)
