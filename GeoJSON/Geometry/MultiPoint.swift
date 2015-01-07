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
	
	/// Public coordinates
	public var points: [Point] { return _points }
	
	public var prefix : String { return "coordinates" }
	
	/// Private coordinates
	private var _points: [Point] = []
	
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
	
	public init?(points: [Point]) {
		_points = points
	}

	/**
	Build a object that can be serialized to JSON
	
	:returns: Representation of the Point Object
	*/
	public func json() -> AnyObject {
		return points.map { $0.json() }
	}
}

/// Array forwarding methods
public extension MultiPoint {
	
	public var count : Int { return points.count }
	
	public subscript(index: Int) -> Point {
		get { return _points[index] }
		set(newValue) { _points[index] = newValue }
	}
}

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
	
	convenience public init(multiPoint: MultiPoint) {
		self.init()
		object = multiPoint
	}
}
