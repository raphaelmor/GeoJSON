// FeatureCollection.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Raphaël Mor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

public final class FeatureCollection {
    
    /// Private var to store features
    private var _features: [GeoJSON] = []
    
    /// Public features
    public var features: [GeoJSON] { return _features }
    
    
    public init?(json: JSON) {
        if let jsonFeatures =  json.array {
            _features = jsonFeatures.map { jsonObject in
                return GeoJSON(json: jsonObject)
                } ?? []
            
            let validFeatures = _features.filter { geoJSON in
                return geoJSON.type == .Feature
            }
            
            if validFeatures.count != _features.count {
                return nil
            }
        } else {
            return nil
        }
    }
}

/// Array forwarding methods
public extension FeatureCollection {
    
    public var count : Int { return features.count }
    
    public subscript(index: Int) -> GeoJSON {
        get { return features[index] }
        set(newValue) { _features[index] = newValue }
    }
}

public extension GeoJSON {
    
    /// Optional Polygon
    public var featureCollection: FeatureCollection? {
        get {
            switch type {
            case .FeatureCollection:
                return object as? FeatureCollection
            default:
                return nil
            }
        }
        set {
            _object = newValue ?? NSNull()
        }
    }
}
