[![Build Status](https://travis-ci.org/chuganzy/HCImage-BPG.svg?branch=master)](https://travis-ci.org/chuganzy/HCImage-BPG)
![CocoaPods](https://img.shields.io/cocoapods/v/HCImage+BPG.svg)
![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)
![Platform](https://img.shields.io/cocoapods/p/HCImage+BPG.svg)

# HCImage+BPG

BPG (http://bellard.org/bpg/) decoder for iOS and macOS.

## Features

- Supports macOS
- Supports iOS
- Supports animation
- Supports nullability

## Usage

### iOS

- Objective-C

```objc
NSData *data = ...;
UIImage *image = [UIImage imageWithBPGData:data error:NULL];
```

- Swift

```swift
let data: NSData = ...
let image: UIImage? = try? UIImage(BPGData: data)
```

### macOS

- Objective-C

```objc
NSData *data = ...;
NSImage *image = [NSImage imageWithBPGData:data error:NULL];
```

- Swift

```swift
let data: NSData = ...
let image: NSImage? = try? NSImage(BPGData: data)
```

## Installation

### CocoaPods

```
pod 'HCImage+BPG'
```

### Carthage

```
github "chuganzy/HCImage-BPG"
```

## License

MIT.

### libbpg

https://github.com/thomas-huet/libbpg

libbpg and bpgenc are released under the LGPL license (the FFmpeg part is under the LGPL, the BPG specific part is released under the BSD license).

BPG relies on the HEVC compression technology which may be protected by patents in some countries. Most devices already include or will include hardware HEVC support, so we suggest to use it if patents are an issue.
