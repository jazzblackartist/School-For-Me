//
//  NSObject+Extensions.swift
//  ColourLoveSwift
//
//  Created by Alexis Creuzot on 03/12/2015.
//  Copyright © 2015 alexiscreuzot. All rights reserved.
//

import Foundation

extension NSObject {
    
    @objc class func className() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
}
