//
//  Font+.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/16.
//

import SwiftUI

extension Font {

    static func custom17semibold() -> Font {
        return Font.system(size: 17 * setFontSize(), weight: .semibold)
    }

    static func custom12bold() -> Font {
        return Font.system(size: 12 * setFontSize(), weight: .bold)
    }
    
    static func custom14regular() -> Font {
        return Font.system(size: 14 * setFontSize(), weight: .regular)
    }
    
    static func custom14semibold() -> Font {
        return Font.system(size: 14 * setFontSize(), weight: .semibold)
    }

    static func custom20semibold() -> Font {
        return Font.system(size: 20 * setFontSize(), weight: .semibold)
    }

    static func custom16bold() -> Font {
        return Font.system(size: 16 * setFontSize(), weight: .bold)
    }

    static func custom17bold() -> Font {
        return Font.system(size: 17 * setFontSize(), weight: .bold)
    }
    
    static func custom18regular() -> Font {
        return Font.system(size: 18 * setFontSize(), weight: .regular)
    }
    
    static func custom18bold() -> Font {
        return Font.system(size: 18 * setFontSize(), weight: .bold)
    }

    static func custom18semibold() -> Font {
        return Font.system(size: 18 * setFontSize(), weight: .semibold)
    }

    static func custom20bold() -> Font {
        return Font.system(size: 20 * setFontSize(), weight: .bold)
    }

    static func custom24bold() -> Font {
        return Font.system(size: 24 * setFontSize(), weight: .bold)
    }
    static func custom40heavy() -> Font {
        return Font.system(size: 40 * setFontSize(), weight: .heavy)
    }

    static func custom40bold() -> Font {
        return Font.system(size: 40 * setFontSize(), weight: .bold)
    }

    static func custom48bold() -> Font {
        return Font.system(size: 48 * setFontSize(), weight: .bold)
    }

    static func custom60bold() -> Font {
        return Font.system(size: 60 * setFontSize(), weight: .bold)
    }

    static func custom24black() -> Font {
        return Font.system(size: 24 * setFontSize(), weight: .black)
    }

    static func customTitle4() -> Font {
        return Font.system(size: 18 * setFontSize(), weight: .regular)
    }

    // swiftlint:disable:next cyclomatic_complexity
    static func setFontSize() -> Double {
        let height = UIScreen.screenHeight
        var size = 1.0
        
        switch height {
        case 480.0: // Iphone 3,4S => 3.5 inch
            size = 0.85
        case 568.0: // iphone 5, SE => 4 inch
            size = 0.9
        case 667.0: // iphone 6, 6s, 7, 8 => 4.7 inch
            size = 0.9
        case 736.0: // iphone 6s+ 6+, 7+, 8+ => 5.5 inch
            size = 0.95
        case 812.0: // iphone X, XS => 5.8 inch, 13 mini, 12, mini
            size = 0.98
        case 844.0: // iphone 14, iphone 13 pro, iphone 13, 12 pro, 12
            size = 1
        case 852.0: // iphone 14 pro
            size = 1
        case 926.0: // iphone 14 plus, iphone 13 pro max, 12 pro max
            size = 1.05
        case 896.0: // iphone XR => 6.1 inch  // iphone XS MAX => 6.5 inch, 11 pro max, 11
            size = 1.05
        case 932.0: // iPhone14 Pro Max
            size = 1.08
        default:
            size = 1
        }
        return size
    }
}
