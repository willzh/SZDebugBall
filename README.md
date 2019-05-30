# SZDebugBall

[![CI Status](https://img.shields.io/travis/willzh/SZDebugBall.svg?style=flat)](https://travis-ci.org/willzh/SZDebugBall)
[![Version](https://img.shields.io/cocoapods/v/SZDebugBall.svg?style=flat)](https://cocoapods.org/pods/SZDebugBall)
[![License](https://img.shields.io/cocoapods/l/SZDebugBall.svg?style=flat)](https://cocoapods.org/pods/SZDebugBall)
[![Platform](https://img.shields.io/cocoapods/p/SZDebugBall.svg?style=flat)](https://cocoapods.org/pods/SZDebugBall)

## Example
``` 
#import <SZDebugBall/SZEnvironmentManager.h>
```
``` 
[SZEnvironmentManager configEnvs:@[@"开发", @"测试", @"生产"] address:@[@"http://www.api.com/develop", @"http://www.api.com/test", @"http://www.api.com/product"]];

[SZEnvironmentManager configCurrentAddress:@"http://www.api.com/develop"];

NSLog(@"BASE_URL:%@", [SZEnvironmentManager currentAddress]);
```

## Requirements

## Installation

SZDebugBall is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SZDebugBall'
```

## Author

willzh

## License

SZDebugBall is available under the MIT license. See the LICENSE file for more info.
