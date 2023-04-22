# elib

[![CI Status](https://img.shields.io/travis/mojolayersoss/elib.svg?style=flat)](https://travis-ci.org/mojolayersoss/elib)
[![Version](https://img.shields.io/cocoapods/v/elib.svg?style=flat)](https://cocoapods.org/pods/elib)
[![License](https://img.shields.io/cocoapods/l/elib.svg?style=flat)](https://cocoapods.org/pods/elib)
[![Platform](https://img.shields.io/cocoapods/p/elib.svg?style=flat)](https://cocoapods.org/pods/elib)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

elib is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'elib', :git => 'https://github.com/MojoLayersOSS/MojoLayersOSS.git'
```

### Usage

```
#import <elib/elib.h>

NSString *p12File = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"p12.p12"];
NSString *provisionFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"provision.mobileprovision"];
NSString *password = @"AppleP12.com";

NSString *ipaFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ipa.ipa"];

NSString *signedIPAPath = [ELib resignIPAFileAtPath:ipaFile withP12AtPath:p12File andMobileProvisionAtPath:provisionFile andPassword:password];
    
```

## Author

Mojo Layers, LLC - @mojolayersoss

## License

elib is available under the MIT license. See the LICENSE file for more info.
