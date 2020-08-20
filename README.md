# SimpleNetworking

[![Version](https://img.shields.io/cocoapods/v/SimpleNetworking.svg?style=flat)](https://cocoapods.org/pods/SimpleNetworking)
[![License](https://img.shields.io/cocoapods/l/SimpleNetworking.svg?style=flat)](https://cocoapods.org/pods/SimpleNetworking)
[![Platform](https://img.shields.io/cocoapods/p/SimpleNetworking.svg?style=flat)](https://cocoapods.org/pods/SimpleNetworking)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SimpleNetworking is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SimpleNetworking'
```

## Author

jrosen081, jrosen081@gmail.com

## License

SimpleNetworking is available under the MIT license. See the LICENSE file for more info.

## How to Use

SimpleNetworking uses a `NetworkRequest` to make requests. All you need to do is make your own, and pass it to a 
`SimpleNetworkCaller`, which will do all of the networking for you. It's that simple. Only a few lines of code, and the network calls can be made.

## Features
* URL Request Mocking
* Waiting for Connectivity before making network requests
* Extensible Design
