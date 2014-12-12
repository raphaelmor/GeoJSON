// Position.swift
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

public struct Position {
	
	public var coordinates = [Double]()
	
	public var latitude: Double { return coordinates[1] }
	public var longitude: Double { return coordinates[0] }
	public var altitude: Double { return coordinates[2] }
	
	public var count : Int { return coordinates.count }
	
	public init?(doubleArray: [Double]) {
		if doubleArray.count < 2 { return nil }
		coordinates = doubleArray
	}
	
	public init?(jsonArray: JSON) {
		if let jsonCoordinates =  jsonArray.array {
			if jsonCoordinates.count < 2 { return nil }
			
			coordinates = jsonCoordinates.map {
				Double($0.doubleValue)
			}
		}
		else {
			return nil
		}
	}
	
	public subscript(index: Int) -> Double {
		get {
			return coordinates[index]
		}
		set(newValue) {
			coordinates[index] = newValue
		}
	}
	

}


extension Position: ArrayLiteralConvertible {
	public init(arrayLiteral elements: Double...) {
		for element in elements {
			coordinates.append(element)
		}
	}
}

