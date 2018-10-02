//
//  SequenceExtensions.swift
//  Dove
//
//  Created by Connor Haigh on 18/09/2018.
//  Copyright © 2018 Connor Haigh. All rights reserved.
//

import Foundation

public extension Sequence {
	public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
		var count = 0
		
		for element in self where try predicate(element) {
			count += 1
		}
		
		return count
	}
	
	public func project<T, V>(_ transform: (Element) throws -> (key: T, value: V)) rethrows -> [T: V] {
		return [T: V](uniqueKeysWithValues: try self.map(transform))
	}
	
	public func group<T>(by predicate: (Element) throws -> T) rethrows -> [T: [Element]] {
		return try [T: [Element]](grouping: self, by: predicate)
	}
}

public extension RangeReplaceableCollection {
	public mutating func first(where predicate: (Element) throws -> Bool, appending create: () throws -> (Element)) rethrows -> Element? {
		guard let element = try self.first(where: predicate) else {
			let element = try create()
			
			self.append(element)
			
			return element
		}
		
		return element
	}
}

public extension RangeReplaceableCollection where Element: Equatable {
	public mutating func remove(element: Element) {
		guard let index = self.index(of: element) else {
			return
		}
		
		self.remove(at: index)
	}
	
	public func contains(array: [Element]) -> Bool {
		return self.contains(where: { array.contains($0) })
	}
}
