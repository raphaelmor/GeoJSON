// LineString.swift
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

public final class LineString {
	
	/// Private coordinates
	private var _points: [Point] = []
	
	/// Public coordinates
	public var points: [Point] { return _points }
	
	/// LinearRing
	public var isLinearRing : Bool { return (self.count >= 4) && (self.points.first == self.points.last) }
	
	
	public init?(json: JSON) {
		if let jsonPoints =  json.array {
			if jsonPoints.count < 2 { return nil }
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
}

/// Array forwarding methods
public extension LineString {
	
	public var count : Int { return points.count }
	
	public subscript(index: Int) -> Point {
		get { return _points[index] }
		set(newValue) { _points[index] = newValue }
	}
}

public extension GeoJSON {
	
	/// Optional LineString
	public var lineString: LineString? {
		get {
			switch type {
			case .LineString:
				return object as? LineString
			default:
				return nil
			}
		}
		set {
			_object = newValue ?? NSNull()
		}
	}
}