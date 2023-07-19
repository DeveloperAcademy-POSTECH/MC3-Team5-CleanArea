//
//  UIScreen+.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    static let camViewHeight: CGFloat = UIScreen.main.bounds.size.width * 4.0 / 3.0
    static let videoViewHeight: CGFloat = UIScreen.main.bounds.size.width * 16.0 / 9.0
//    static let statusBar = UIApplication.shared.statu

    static func getWidth(_ width: CGFloat) -> CGFloat {
        screenWidth / 390 * width
    }
    static func getHeight(_ height: CGFloat) -> CGFloat {
        screenHeight / 844 * height
    }
    static func getWidth8(_ width: CGFloat) -> CGFloat {
        screenWidth / 375 * width
    }
    static func getHeight8(_ height: CGFloat) -> CGFloat {
        screenHeight / 667 * height
    }
}

