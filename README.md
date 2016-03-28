[![Build Status](https://travis-ci.org/hoppenichu/HCImage-BPG.svg?branch=master)](https://travis-ci.org/hoppenichu/HCImage-BPG)

# HCImage+BPG

BPG (http://bellard.org/bpg/) decoder for iOS and OS X.

## Features

- Supports OSX
- Supports iOS
- Supports animation
- Supports nullability

## Usage

### iOS
- Objective-C

```objc
NSData *data = ...;
UIImage *image = [UIImage imageWithBPGData:data];
```
  
- Swift

```swift
let data: NSData = ...
let image: UIImage = UIImage(BPGData: data)
```

### Mac

```objc
NSData *data = ...;
NSImage *image = [NSImage imageWithBPGData:data];
```
  
- Swift

```swift
let data: NSData = ...
let image: NSImage = NSImage(BPGData: data)
```

## Installation

### CocoaPods

```
pod 'HCImage+BPG'
```

### Carthage

```
github "hoppenichu/HCImage+BPG"
```

## License

MIT.

### libbpg

https://github.com/thomas-huet/libbpg

libbpg and bpgenc are released under the LGPL license (the FFmpeg part is under the LGPL, the BPG specific part is released under the BSD license).

BPG relies on the HEVC compression technology which may be protected by patents in some countries. Most devices already include or will include hardware HEVC support, so we suggest to use it if patents are an issue.
