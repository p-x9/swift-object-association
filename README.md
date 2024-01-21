# ObjectAssociation

A swift library for associating objects as properties with reference type objects.

It works in the same way as `objc_getAssociatedObject`/`objc_setAssociatedObject`.
However, this library can also be used on Linux platforms and other platforms that do not run the Objective-C runtime.

<!-- # Badges -->

[![Github issues](https://img.shields.io/github/issues/p-x9/swift-object-association)](https://github.com/p-x9/swift-object-association/issues)
[![Github forks](https://img.shields.io/github/forks/p-x9/swift-object-association)](https://github.com/p-x9/swift-object-association/network/members)
[![Github stars](https://img.shields.io/github/stars/p-x9/swift-object-association)](https://github.com/p-x9/swift-object-association/stargazers)
[![Github top language](https://img.shields.io/github/languages/top/p-x9/swift-object-association)](https://github.com/p-x9/swift-object-association/)

## Usage

Basically the same usage as `objc_getAssociatedObject`/`objc_setAssociatedObject`.
But there is no policy setting.

```swift

class ClassItem {
    enum Keys {
        static var value: UInt8 = 0
    }

    var value: String? {
        get {
            getAssociatedObject(
                self,
                &ClassItem.Keys.value
            ) as? String
        }
        set {
            setAssociatedObject(
                self,
                &ClassItem.Keys.value,
                newValue
            )
        }
    }
}
```

### Remove all associated values

```swift
removeAssociatedObjects(self)
```
