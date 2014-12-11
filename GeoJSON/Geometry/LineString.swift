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

public final class LineString : MultiPoint {
		
	// MARK: - Internal methods
	override func validateCoordinates(coordinates: [JSON]) -> Bool {
		
		let validCoordinates = coordinates.filter {
			let count = $0.array?.count ?? 0
			return count >= 2
		}
		
		if validCoordinates.count != coordinates.count || coordinates.count < 2 {
			return false
		}
		
		return true
	}
}

public extension GeoJSON {
	
	/// Optional Point
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