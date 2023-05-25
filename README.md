# KeyChaining

[![Swift 5.4](https://img.shields.io/badge/Swift-5.5-orange.svg?style=flat)](ttps://developer.apple.com/swift/)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Platforms OS X | iOS](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20iOS%20-lightgray.svg?style=flat)](https://developer.apple.com/swift/)

## Overview

KeyChaining is a framework for Swift. It provides easy-to-use CRUD API for Keychain.

## Getting started

You need to add library to `Package.swift` file:

 - add package to dependencies:
```swift
.package(url: "https://github.com/ViktorChernykh/key-chaining.git", from: "1.0.0")
```
- and add product to your target:
```swift
.target(name: "App", dependencies: [
    . . .
    .product(name: "KeyChaining", package: "key-chaining")
])
```

## Use case:
