//
//  UIImage+Extension.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/05.
//

import UIKit

extension UIImage {
    func resizeToRatio(width: CGFloat) -> UIImage? {
        let ratio  = self.size.height / self.size.width
        let newSize: CGSize = CGSize(width: width, height: width * ratio)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    func resizeToRatio(height: CGFloat) -> UIImage? {
        let ratio  = self.size.width / self.size.height
        let newSize: CGSize = CGSize(width: height * ratio, height: height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}


// MARK: - 언어분기

extension UIImage {
    convenience init?(namedByLanguage: String) {
        switch Config.shared.language {
        case .en:
            self.init(named: namedByLanguage + "_en")
        default:
            self.init(named: namedByLanguage)
        }
    }
}
