//
//  NSMutableAttributedString+Link.swift
//  Bitvo-new
//
//  Created by DongMing on 2019-10-07.
//  Copyright © 2019 vogappdevelopers. All rights reserved.
//

import UIKit



extension NSMutableAttributedString {

    /// Set clickable hyperlink to NSMutableAttributedString
    /// - parameters:
    ///   - textToFind: The word you want to add hyperlink to
    ///   - linkURL: The website url (HTTPS), phone number, email
    /// - returns: return `nil` if cannot find the `textToFind` in the string, otherwise, return the range of found text
    public func setAsLink(textToFind:String, linkURL:String?=nil, color: UIColor?=nil, font: UIFont?=nil) -> NSRange? {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            if let linkURL = linkURL {
                self.addAttribute(.link, value: linkURL, range: foundRange)
            }
            
            if let color = color {
                self.addAttribute(.foregroundColor, value: color, range: foundRange)
            }
            
            if let font = font {
                self.addAttribute(.font, value: font, range: foundRange)
            }
            return foundRange
        }
        return nil
    }
}
