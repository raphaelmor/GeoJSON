// MultiPolygon.swift
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

public final class MultiPolygon {
	
	/// Private polygons
	private var _polygons: [Polygon] = []
	
	/// Public polygons
	public var polygons: [Polygon] { return _polygons }

	public init?(json: JSON) {
		if let jsonPolygons =  json.array {
			
			for jsonPolygon in jsonPolygons {
				if let polygon = Polygon(json: jsonPolygon) {
					_polygons.append(polygon)
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
public extension MultiPolygon {
	
	public var count : Int { return polygons.count }
	
	public subscript(index: Int) -> Polygon {
		get { return _polygons[index] }
		set(newValue) { _polygons[index] = newValue }
	}
}

public extension GeoJSON {
	
	/// Optional MultiPolygon
	public var multiPolygon: MultiPolygon? {
		get {
			switch type {
			case .MultiPolygon:
				return object as? MultiPolygon
			default:
				return nil
			}
		}
		set {
			_object = newValue ?? NSNull()
		}
	}
}