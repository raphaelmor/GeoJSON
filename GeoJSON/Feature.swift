// Feature.swift
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

public final class Feature : GeoJSONEncodable {
	
	/// Public geometry
	public var geometry: GeoJSON? { return _geometry }
	
	/// Public identifier
	public var identifier: String? { return _identifier }
	
	/// Public properties
	public var properties: JSON { return _properties }
	
	/// Prefix used for GeoJSON Encoding
	public var prefix: String { return "" }
	
    /// Private geometry
	private var _geometry: GeoJSON? = nil

    /// Private properties
    private var _properties: JSON

	/// Private identifier
	public var _identifier: String?
	
	/**
	Designated initializer for creating a Feature from a SwiftyJSON object
	
	:param: json The SwiftyJSON Object.
	:returns: The created Feature object.
	*/
	public init?(json: JSON) {
        
        _properties = json["properties"]
        if _properties.error != nil { return nil }
        
        let jsonGeometry = json["geometry"]
        if jsonGeometry.error != nil { return nil }
        
        if let _ = jsonGeometry.null {
            _geometry = nil
        } else {
            _geometry = GeoJSON(json: jsonGeometry)
            if _geometry?.error != nil { return nil }
            if _geometry?.isGeometry() == false { return nil }
        }
        
        let jsonIdentifier = json["id"]
        _identifier = jsonIdentifier.string
    }
	
	/**
	Designated initializer for creating a Feature from a objects
	
	:param: coordinates The coordinate array.
	:returns: The created Point object.
	*/
	public init?(geometry: GeoJSON? = nil, properties: JSON? = nil, identifier: String? = nil) {
		
		if let _ = properties {
			_properties = properties!
			if properties!.error != nil { return nil }
		} else {
			_properties = JSON.nullJSON
		}
		
		_geometry = geometry
		if _geometry?.error != nil { return nil }
		if _geometry?.isGeometry() == false { return nil }
		
		_identifier = identifier
	}

	/**
	Returns an object that can be serialized to JSON
	
	:returns: Representation of the Feature Object
	*/
	public func json() -> AnyObject {
	
		var geometryJSON : AnyObject = self.geometry?.json() ?? NSNull()
		
		var resultDict = [
			"type" : "Feature",
			"properties" : self.properties.object,
			"geometry" : geometryJSON,
		]
		
		if let id = _identifier {
			resultDict["id"] = identifier
		}
		
		return resultDict
	}
}

public extension GeoJSON {
    
    /// Optional Feature
    public var feature: Feature? {
        get {
            switch type {
            case .Feature:
                return object as? Feature
            default:
                return nil
            }
        }
        set {
            _object = newValue ?? NSNull()
        }
    }
	
	/**
	Convenience initializer for creating a GeoJSON Object from a Feature
	
	:param: feature The Feature object.
	:returns: The created GeoJSON object.
	*/
	convenience public init(feature: Feature) {
		self.init()
		object = feature
	}
}