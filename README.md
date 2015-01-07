<p align="center" >
  <img src="https://raw.githubusercontent.com/raphaelmor/GeoJSON/assets/GeoJSON.png" title="GeoJSON logo" float=left>
</p>
[![Build Status](https://travis-ci.org/raphaelmor/GeoJSON.svg?branch=master)](https://travis-ci.org/raphaelmor/GeoJSON)
[![Release](https://img.shields.io/github/release/raphaelmor/GeoJSON.svg)]()
[![Licence](http://img.shields.io/badge/Licence-MIT-lightgrey.svg)](https://github.com/raphaelmor/GeoJSON/blob/master/LICENCE)

GeoJSON Parser in swift

## Features

- Decode a `GeoJSON` string to `Swift` classes
- Support for `Point`, `MultiPoint`, `LineString`, `MultiLineString`, `Polygon`, `MultiPolygon`, `GeometryCollection`, `Feature` and `FeatureCollection`
- Encode a `Point`
- Continuous integration with [Travis CI](http://travis-ci.org)

### Planned for 1.0.0 Release
- Encode `Swift` classes to a `GeoJSON` string
- Support for custom CRSs and BoundingBoxes
- 100% Unit Test Coverage
- Complete Documentation
- Example project

### Planned when support is available :

- Distribute as a [CocoaPod](http://cocoapods.org)
- Code Coverage with [Coveralls](https://coveralls.io)

## Requirements

- Xcode 6.0.1
- iOS 7.0+ / Mac OS X 10.9+

---
## Integration

CocoaPods is not fully supported for Swift yet. To use this library in your project you can integrate it manually :

### Manual

- Drag GeoJSON.swift inside your project tree.
- For Workspaces you may include the whole GeoJSON.xcodeproj

## Usage

## Notes 

This codes tries to adhere to the [GitHub Swift Style Guide](https://github.com/github/swift-style-guide)

## Creator

- [Raphael Mor](http://github.com/raphaelmor) ([@raphaelmor](https://twitter.com/raphaelmor))

## License

GeoJSON is released under an MIT license. See LICENSE for more information.
