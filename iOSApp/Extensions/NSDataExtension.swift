//
//  NSDataExtension.swift
//  iOSApp
//
//  Created by kushal  on 05/05/17.
//  Copyright © 2017 kushal. All rights reserved.
//

import Foundation

extension NSData {
    
    func dataByRemovingSpecialCharacters()-> NSData? {
        var string  = String(data: self as Data, encoding: String.Encoding.utf8)!
        string = string.replacingOccurrences(of: "})", with: "}")
        string = string.replacingOccurrences(of: "'", with: "")
        string = string.replacingOccurrences(of: "\\\"", with: "")
        string = string.replacingOccurrences(of: "\\", with: "")
        
        return string.data(using: String.Encoding.utf8) as NSData?
    }
}
