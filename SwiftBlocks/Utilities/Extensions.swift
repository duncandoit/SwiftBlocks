//
//  Extensions.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

extension UIApplication {
    @objc class func topController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topController(controller: presented)
        }
        
        return controller
    }
    
    @objc func dismissTopController() {
        UIApplication.topController()?.dismiss(animated: true, completion: nil)
    }
}


extension UIView {
    func addShadow(radius: CGFloat, offsetX: CGFloat = 0, offsetY: CGFloat = 0, color: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)) {
        layer.shadowOpacity = 1
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        
        layer.shadowColor = color.cgColor;
    }
    
    func addBorders(width: CGFloat, color: UIColor) {
        addBorders(width: width, color: color.cgColor)
    }
    
    func addBorders(width: CGFloat, color: CGColor) {
        //frame = frame.insetBy(dx: -width, dy: -width)
        layer.borderWidth = width
        layer.borderColor = color
    }
    
    func roundCorners(radius: CGFloat? = nil) {
        if self is UIImageView {
            self.clipsToBounds = true
        }
        
        if let radius = radius {
            layer.cornerRadius = radius
        } else {
            layer.cornerRadius = frame.width > frame.height
                ? frame.height / 2
                : frame.width / 2
        }
    }
    
    func animateShow() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        })
    }
    
    func animateHide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        })
    }
    
    func pulseBackground() {
        guard backgroundColor != nil else { return }
        backgroundColor! -= 0.1
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseInOut, .repeat, .allowUserInteraction], animations: {
            self.backgroundColor! += 0.1
        }, completion: nil)
    }
    
    func morphBackground(with color: UIColor, duration: Double = 1) {
        guard backgroundColor != nil else { return }
        let originalColor = backgroundColor!
        backgroundColor = color
        UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .allowUserInteraction, .autoreverse], animations: {
            self.backgroundColor! = originalColor
        }, completion: nil)
    }
    
    @discardableResult
    func fromNib() -> UIView? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView else {
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }
}


extension UIViewController {
    // Mark: - Alert
    
    /// Shows a system standard alert with the only action being "OK"
    /// - Parameter message: The message to be displayed in the alert
    @objc func showAlert(message:String?) {
        let alert = UIAlertController(title: .none, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:"OK action"),
                                                              style: .default,
                                                              handler: .none)
        alert.addAction(okAction)
        present(alert, animated: true, completion: .none);
    }
    
    @objc func showAlert(title:String?, message:String?, andActions actions:[UIAlertAction]?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actions = actions {
            actions.forEach { (action) in
                alert.addAction(action)
            }
        } else {
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment:"OK action"),
                                         style: .default,
                                         handler: .none)
            alert.addAction(okAction)
        }

        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: .none)
    }
    
    @objc func showActionSheet(title:String?, message:String?, andActions actions:[UIAlertAction], andAnchorView anchorView:UIView?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { (action) in
            alert.addAction(action)
        }
        
        if let popoverController = alert.popoverPresentationController,
            let anchorView = anchorView {
            popoverController.sourceView = anchorView
            popoverController.sourceRect = CGRect(x: anchorView.bounds.maxX, y: anchorView.bounds.midY, width: 0, height: 0)
            //popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: .none)
    }
    
    func viewFrom<T:UIView>(nibName: String) -> T? {
        return UINib(nibName: nibName, bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as? T
    }
}


extension UITableView {
    @objc func hasRow(at indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections
            ? indexPath.row < numberOfRows(inSection: indexPath.section)
            : false
    }
    
    /// Only returns nil if the provided IndexPath is nil or if the table is empty
    @objc func validIndexPath(fromCandidate indexPath: IndexPath?) -> IndexPath? {
        guard let indexPath = indexPath else { return nil }
        return hasRow(at: indexPath)
            ? indexPath
            : IndexPath(row: numberOfRows(inSection: numberOfSections - 1), section: numberOfSections - 1)
    }
}


extension UIColor {
    ///Returns a lighter color
    static func +(color: UIColor, modification: Double) -> UIColor {
        let ciColor = CIColor(color: color)
        return UIColor(red: ciColor.red + CGFloat(modification),
                       green: ciColor.green + CGFloat(modification),
                       blue: ciColor.blue + CGFloat(modification),
                       alpha: ciColor.alpha)
    }
    
    ///Returns a darker color
    static func -(color: UIColor, modification: Double) -> UIColor {
        return color + -modification
    }
    
    ///The color on the left side of the equals sign will be made lighter
    static func +=(color: inout UIColor, modification: Double) {
        color = color + modification
    }
    
    ///The color on the left side of the equals sign will be made darker
    static func -=(color: inout UIColor, modification: Double) {
        color = color - modification
    }
    
    ///Returns true if the left side of the comparison is lighter
    static func >(left: UIColor, right: UIColor) -> Bool {
        guard let lComponents = left.cgColor.components else { return false }
        guard let rComponents = right.cgColor.components else { return false }
        
        var lTotal: CGFloat = 0
        var rTotal: CGFloat = 0
        
        for i in 0 ..< lComponents.count {
            if i != lComponents.count - 1 {
                lTotal += lComponents[i]
            }
        }
        
        for i in 0 ..< rComponents.count {
            if i != rComponents.count - 1 {
                rTotal += rComponents[i]
            }
        }
        
        return lTotal > rTotal
    }
    
    ///Returns true if the left side of the comparison is darker
    static func <(left: UIColor, right: UIColor) -> Bool {
        return !(left > right)
    }
    
    
    ///Returns true if the both sides of the comparison are the same color
    static func ==(left: UIColor, right: UIColor) -> Bool {
        guard let lComponents = left.cgColor.components else { return false }
        guard let rComponents = right.cgColor.components else { return false }
        
        var lTotal: CGFloat = 0
        var rTotal: CGFloat = 0
        
        for i in 0 ..< lComponents.count {
            if i != lComponents.count - 1 {
                lTotal += lComponents[i]
            }
        }
        
        for i in 0 ..< rComponents.count {
            if i != rComponents.count - 1 {
                rTotal += rComponents[i]
            }
        }
        
        return lTotal == rTotal
    }
    
    func opacity(_ amount: CGFloat) -> UIColor {
        let ciColor = CIColor(color: self)
        return UIColor(red: ciColor.red,
                       green: ciColor.green,
                       blue: ciColor.blue,
                       alpha: amount)
    }
    
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        self.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    func complementary() -> UIColor {
        let ciColor = CIColor(color: self)
        
        // Get the current values' differences from white
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        
        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: ciColor.alpha)
    }
    
    func saturated(by modifier: CGFloat) -> UIColor {
        let ciColor = CIColor(color: self)
        var newRed: CGFloat = ciColor.red
        var newBlue: CGFloat = ciColor.blue
        var newGreen: CGFloat = ciColor.green
        
        if newRed > newBlue && newRed > newGreen {
            newBlue -= modifier
            newGreen -= modifier
        } else if newBlue > newGreen && newBlue > newRed {
            newRed -= modifier
            newGreen -= modifier
        } else {
            newRed -= modifier
            newBlue -= modifier
        }
        
        newRed = newRed < 0 ? 0 : newRed
        newBlue = newBlue < 0 ? 0 : newBlue
        newGreen = newGreen < 0 ? 0 : newGreen
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: ciColor.alpha)
        
//        if ciColor.red > ciColor.blue && ciColor.red > ciColor.green {
//            return UIColor(red: ciColor.red, green: ciColor.green - modifier, blue: ciColor.blue - modifier, alpha: ciColor.alpha)
//        } else if ciColor.blue > ciColor.green && ciColor.blue > ciColor.red {
//            return UIColor(red: ciColor.red - modifier, green: ciColor.green - modifier, blue: ciColor.blue, alpha: ciColor.alpha)
//        } else {
//            return UIColor(red: ciColor.red - modifier, green: ciColor.green + modifier, blue: ciColor.blue - modifier, alpha: ciColor.alpha)
//        }
    }
    
    convenience init?(hex: String?) {
        guard let hex = hex else { return nil }
        var hexNormalized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        hexNormalized = hexNormalized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        let length = hexNormalized.count

        // Create Scanner
        Scanner(string: hexNormalized).scanHexInt64(&rgb)

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    var hexValue: String? {
        // Extract Components
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        // Helpers
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        // Create Hex String
        let hex = String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))

        return hex
    }
}


extension Array {
    func toJSONString() -> String {
        if self.isEmpty {
            return "[ ]";
        } else {
            var jsonString = "";
            
            for i in 0 ..< self.count {
                if i == 0 {
                    jsonString += "[ ";
                }
                
                jsonString += "\(self[i])";
                
                if i + 1 != self.count {
                    jsonString += ", ";
                } else {
                    jsonString += " ]";
                }
            }
            
            return jsonString;
        }
    }
}


extension Data {
    static func merge(pdfs: [Data]) -> Data {
        if pdfs.count == 1 {
            return pdfs.first!
        }
        
        let out = NSMutableData()
        UIGraphicsBeginPDFContextToData(out, .zero, nil)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return out as Data
        }
        
        for pdf in pdfs {
            guard let dataProvider = CGDataProvider(data: pdf as CFData), let document = CGPDFDocument(dataProvider) else { continue }
            
            for pageNumber in 1...document.numberOfPages {
                guard let page = document.page(at: pageNumber) else { continue }
                var mediaBox = page.getBoxRect(.mediaBox)
                context.beginPage(mediaBox: &mediaBox)
                context.drawPDFPage(page)
                context.endPage()
            }
        }
        
        context.closePDF()
        UIGraphicsEndPDFContext()
        
        return out as Data
    }
    
    var jsonString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}


extension UIDevice {
    @objc static var isPad:Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    @objc static var isPhone:Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}


extension CGRect {
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
}


extension NSObject {
    var className: String {
        return NSStringFromClass(type(of: self))
    }
}

extension Bool {
    var inverse: Bool { self ? false : true }
}
