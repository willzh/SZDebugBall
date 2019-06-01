# SZDebugBall

[![CI Status](https://img.shields.io/travis/willzh/SZDebugBall.svg?style=flat)](https://travis-ci.org/willzh/SZDebugBall)
[![Version](https://img.shields.io/cocoapods/v/SZDebugBall.svg?style=flat)](https://cocoapods.org/pods/SZDebugBall)
[![License](https://img.shields.io/cocoapods/l/SZDebugBall.svg?style=flat)](https://cocoapods.org/pods/SZDebugBall)
[![Platform](https://img.shields.io/cocoapods/p/SZDebugBall.svg?style=flat)](https://cocoapods.org/pods/SZDebugBall)

## Feature
1. 环境切换
[x] 手动切换环境
[x] 代码切换环境
[x] 新增环境
[x] 删除环境

## Example
``` 
#import <SZDebugBall/SZEnvironmentManager.h>
```
``` 
[SZEnvironmentManager configEnvs:@[@"开发", @"测试", @"生产"] address:@[@"http://www.api.com/develop", @"http://www.api.com/test", @"http://www.api.com/product"]];

[SZEnvironmentManager configCurrentAddress:@"http://www.api.com/develop"];

NSLog(@"BASE_URL:%@", [SZEnvironmentManager currentAddress]);

/// 环境切换成功后的通知。环境切换成功后，会自动退出 App 一次。
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(environmentChanged:) name:SZEnvironmentChangedNotification object:nil];

```


## Screenshot
<p align="left">
<img src="https://github.com/willzh/SZDebugBall/blob/master/screenshots/screenshot.png" alt="screenshot"  width="310" height="300">
</p>


## Installation

SZDebugBall is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SZDebugBall'
```

## License

SZDebugBall is available under the MIT license. See the LICENSE file for more info.
