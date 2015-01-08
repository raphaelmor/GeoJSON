// MultiLineString.swift
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

public final class MultiLineString : GeoJSONEncodable {
	
	/// Public lineStrings
	public var lineStrings: [LineString] { return _lineStrings }

	/// Prefix used for GeoJSON Encoding
	public var prefix: String { return "coordinates" }
	
	/// Private lineStrings
	private var _lineStrings: [LineString] = []
	
	/**
	Designated initializer for creating a MultiLineString from a SwiftyJSON object
	
	:param: json The SwiftyJSON Object.
	:returns: The created MultiLineString object.
	*/
	public init?(json: JSON) {
		if let jsonLineStrings =  json.array {

			for jsonLineString in jsonLineStrings {
				if let lineString = LineString(json: jsonLineString) {
					_lineStrings.append(lineString)
				}
				else {
					return nil
				}
			}
		}
		else {
			return nil
		}
	}
	
	/**
	Designated initializer for creating a MultiLineString from [LineString]
	
	:param: lineStrings The LineString array.
	:returns: The created MultiLineString object.
	*/
	public init?(lineStrings: [LineString]) {
		_lineStrings = lineStrings
	}
	
	/**
	Build a object that can be serialized to JSON
	
	:returns: Representation of the LineString Object
	*/
	public func json() -> AnyObject {
		return _lineStrings.map { $0.json() }
 	}
}

/// Array forwarding methods
public extension MultiLineString {
	
	/// number of lineStrings
	public var count: Int { return lineStrings.count }

	/// subscript to access the Nth LineString
	public subscript(index: Int) -> LineString {
		get { return _lineStrings[index] }
		set(newValue) { _lineStrings[index] = newValue }
	}
}

/// MultiLineString related methods on GeoJSON
public extension GeoJSON {
	
	/// Optional MultiLineString
	public var multiLineString: MultiLineString? {
		get {
			switch type {
			case .MultiLineString:
				return object as? MultiLineString
			default:
				return nil
			}
		}
		set {
			_object = newValue ?? NSNull()
		}
	}
	
	/**
	Convenience initializer for creating a GeoJSON Object from a MultiLineString
	
	:param: multiLineString The MultiLineString object.
	:returns: The created GeoJSON object.
	*/
	convenience public init(multiLineString: MultiLineString) {
		self.init()
		object = multiLineString
	}
}