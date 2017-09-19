//
//  PrimitiveExtensions.swift
//  Dove
//
//  Created by Connor Haigh on 10/08/2016.
//  Copyright © 2016 Connor Haigh. All rights reserved.
//

import Foundation

public extension String {
	public enum ConversionCase {
		case camel
		case pascal
		case title
		case snake
		case kebab
	}
	
	public static func pluralise(amount: Int, _ singular: String, _ plural: String? = nil) -> String {
		guard amount != 1 else {
			return singular
		}
		
		if let plural = plural {
			return plural
		}
		
		let suffix = singular.hasSuffix("s") || singular.hasSuffix("S") ? singular.substring(from: singular.index(before: singular.endIndex)) : "s"
		let result = "\(singular)\(suffix)"
		
		return result
	}
	
	public static func replace(transforms: [String: Any]) -> String {
		var result = String(describing: self)
		
		for (source, replacement) in transforms {
			result = result.replacingOccurrences(of: source, with: String(describing: replacement))
		}
		
		return result
	}
	
	public static func generate(length: Int) -> String {
		var result = String()
		
		for _ in 1...length {
			let offset = Int(arc4random_uniform(UInt32(letters.characters.count)))
			let index = letters.characters.index(letters.characters.startIndex, offsetBy: offset)
			
			result.append(letters.characters[index])
		}
		
		return result
	}
	
	public func convert(case: ConversionCase) -> String {
		switch `case` {
		case .camel:
			return String(self.characters.prefix(1)).lowercased() + String(self.characters.dropFirst())
		case .pascal:
			return String(self.characters.prefix(1)).uppercased() + String(self.characters.dropFirst())
		case .title:
			return self.replacingOccurrences(of: regex, with: "$1 $2", options: .regularExpression, range: self.startIndex..<self.endIndex).capitalized
		case .snake:
			return self.replacingOccurrences(of: regex, with: "$1_$2", options: .regularExpression, range: self.startIndex..<self.endIndex).lowercased()
		case .kebab:
			return self.replacingOccurrences(of: regex, with: "$1-$2", options: .regularExpression, range: self.startIndex..<self.endIndex).lowercased()
		}
	}
	
	public func truncate(length: Int) -> String {
		if self.characters.count > length {
			return self.substring(to: self.characters.index(self.startIndex, offsetBy: length)) + "..."
		}
		
		return self
	}
}

public extension Int {
	public static func align(number: Int, steps: Int) -> Int {
		return Int(round(Double(number) / Double(steps))) * steps
	}
	
	public static func random(maximum: Int) -> Int {
		return Int(arc4random_uniform(UInt32(maximum)))
	}
	
	public var ordinal: String {
		let ones = self % 10
		let tens = (self / 10) % 10
		
		if tens != 1 {
			switch ones {
			case 1:
				return "\(self)st"
			case 2:
				return "\(self)nd"
			case 3:
				return "\(self)rd"
			default:
				break
			}
		}
		
		return "\(self)th"
	}
	
	public var displayValue: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.groupingSeparator = ","
		
		return formatter.string(from: NSNumber(value: self)) ?? String(self)
	}
}

public extension Double {
	public var displayValue: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.groupingSeparator = ","
		formatter.maximumFractionDigits = 3
		
		return formatter.string(from: NSNumber(value: self)) ?? String(self)
	}
}

public extension FloatingPoint {
	public static var random: Self {
		return Self(arc4random()) / Self(UInt32.max)
	}
	
	public var radians: Self {
		return self * .pi / 180
	}
	
	public var degrees: Self {
		return self * 180 / .pi
	}
}

public func inspect(_ value: Any) -> String {
	switch value {
	case let value as [AnyHashable: Any]:
		return "{\(value.map({ "\($0): \(inspect($1))" }).joined(separator: ", "))}"
	case let value as [Any]:
		return "[\(value.map({ inspect($0) }).joined(separator: ", "))]"
	case let value as String:
		return "\"\(value)\""
	case let value as Bool:
		return value ? "true" : "false"
	default:
		return String(describing: value)
	}
}

private let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
private let regex = "([a-z])([A-Z])"
