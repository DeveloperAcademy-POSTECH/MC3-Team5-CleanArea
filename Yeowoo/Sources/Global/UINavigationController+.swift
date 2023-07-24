//
//  UINavigationController+.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/24.
//

import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
	override open func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self
	}
	
	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return viewControllers.count > 1
	}
}
