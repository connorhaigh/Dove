//
//  FitFlowLayout.swift
//  Dove
//
//  Created by Connor Haigh on 08/03/2017.
//  Copyright © 2017 Connor Haigh. All rights reserved.
//

import UIKit

@IBDesignable public class FitFlowLayout: UICollectionViewFlowLayout {
	override public func prepare() {
		super.prepare()
		
		if let view = self.collectionView {
			view.isScrollEnabled = false
			view.isPagingEnabled = false
			
			let count = CGFloat(view.numberOfItems(inSection: 0))
			let offset = (self.spacing * (count - 1)) / count
			
			self.itemSize = CGSize(width: (view.frame.size.width / count) - offset, height: view.frame.size.height)
		}
		
		self.scrollDirection = .horizontal
		
		self.minimumLineSpacing = self.spacing
		self.minimumInteritemSpacing = 0
	}
	
	@IBInspectable public var spacing: CGFloat = 8
}
