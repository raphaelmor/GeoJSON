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

public class MultiPoint {
	
	/// Private coordinates
	private var _coordinates: PositionList = []
	
	/// Public coordinates
	public var coordinates: PositionList { return _coordinates }
	
	public init?(json: JSON) {
		let optCoord = json["coordinates"]
		if let coordinates =  optCoord.array {
			if validateCoordinates(coordinates) {
				_coordinates = coordinates.map {
					let doubleArray = $0.array?.map { Double($0.doubleValue) } ?? []
					return doubleArray
				}
				return
			}
		}
		return nil
	}
	
	// MARK: - Internal methods
	func validateCoordinates(coordinates: [JSON]) -> Bool {
		
		let validCoordinates = coordinates.filter {
			let count = $0.array?.count ?? 0
			return count >= 2
		}
		
		if validCoordinates.count != coordinates.count { return false }
		return true
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
}
