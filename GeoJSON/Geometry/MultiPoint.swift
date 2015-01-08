// MultiPoint.swift
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

public final class MultiPoint : GeoJSONEncodable {
	
	/// Public points
	public var points: [Point] { return _points }
	
	/// Prefix used for GeoJSON Encoding
	public var prefix: String { return "coordinates" }
	
	/// Private points
	private var _points: [Point] = []
	
	/**
	Designated initializer for creating a MultiPoint from a SwiftyJSON object
	
	:param: json The SwiftyJSON Object.
	:returns: The created MultiPoint object.
	*/
	public init?(json: JSON) {
		if let jsonPoints =  json.array {
			for jsonPoint in jsonPoints {
				if let point = Point(json: jsonPoint) {
					_points.append(point)
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
	Designated initializer for creating a MultiPoint from [Point]
	
	:param: points The Point array.
	:returns: The created MultiPoint object.
	*/
	public init?(points: [Point]) {
		_points = points
	}

	/**
	Build a object that can be serialized to JSON
	
	:returns: Representation of the MultiPoint Object
	*/
	public func json() -> AnyObject {
		return points.map { $0.json() }
	}
}

/// Array forwarding methods
public extension MultiPoint {
	
	/// number of points
	public var count: Int { return points.count }
	
	/// subscript to access the Nth Point
	public subscript(index: Int) -> Point {
		get { return _points[index] }
		set(newValue) { _points[index] = newValue }
	}
}

/// MultiPoint related methods on GeoJSON
public extension GeoJSON {
	
	/// Optional MultiPoint
	public var multiPoint: MultiPoint? {
		get {
			switch type {
			case .MultiPoint:
				return object as? MultiPoint
			default:
				return nil
			}
		}
		set {
			_object = newValue ?? NSNull()
		}
	}
	
	/**
	Convenience initializer for creating a GeoJSON Object from a MultiPoint
	
	:param: multiPoint The MultiPoint object.
	:returns: The created GeoJSON object.
	*/
	convenience public init(multiPoint: MultiPoint) {
		self.init()
		object = multiPoint
	}
}
