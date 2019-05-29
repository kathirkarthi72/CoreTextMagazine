//
//  MarkupParser.swift
//  CoreTextMagazine
//
//  Created by Premkumar  on 29/05/19.
//  Copyright © 2019 Kathiresan. All rights reserved.
//

import UIKit

class MarkupParser: NSObject {
    
    var color: UIColor = .black
    var fontName: String = "Arial"
    var attrString : NSMutableAttributedString!
    var images : [String: Any]!
    
    override init() {
        super.init()
    }
    
    // MARK: Internal
    func parserMarkup(_ markup: String) {
        
       attrString = NSMutableAttributedString(string: "")
        
        do {
            let regularExpression = try NSRegularExpression(pattern: "(.*?)(<[^>]+>|\\Z)", options: [.caseInsensitive, .dotMatchesLineSeparators])
            
            let chunks = regularExpression.matches(in: markup, options: .init(rawValue: 0), range: NSRange(location: 0, length: markup.count))
            
            
            let defaultFont: UIFont = .systemFont(ofSize: UIScreen.main.bounds.size.height / 40)
            
            for chunk in chunks {
                guard let markupRange = markup.range(from: chunk.range) else { continue }
                
                let parts = markup[markupRange].components(separatedBy: "<")
                
                let font = UIFont(name: fontName, size: UIScreen.main.bounds.size.height / 40) ?? defaultFont
                
                let attr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
                
                let text = NSMutableAttributedString(string: parts[0], attributes: attr)
                
                attrString.append(text)
                
                // Font
                if parts.count <= 1 { continue }
                
                let tag = parts[1]
                
                if tag.hasPrefix("font") {
                    // Color
                    let colorRexg = try NSRegularExpression(pattern: "(?<=color=\")\\w+", options: .init(rawValue: 0))
                    
                    colorRexg.enumerateMatches(in: tag, options: .init(rawValue: 0), range: NSRange(location: 0, length: tag.count)) { (match, _, _) in
                        
                        if let match = match, let range = tag.range(from: match.range) {
                            let colorSel = NSSelectorFromString(tag[range]+"Color")
                            color = UIColor.perform(colorSel)?.takeRetainedValue() as? UIColor ?? .black
                        }
                    }
                    
                    // Font name
                    let faceRegex = try NSRegularExpression(pattern: "(?<=face=\")[^\"]+", options: .init(rawValue: 0))
                    
                    faceRegex.enumerateMatches(in: tag , options: .init(rawValue: 0), range: NSRange(location: 0, length: tag.count)) { (match, _, _) in
                        
                        if let match = match, let range = tag.range(from: match.range) {
                            fontName = String(tag[range])
                        }
                    }
                    
                }
                
                
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

extension String {
    
    func range(from range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) else {
                return nil
        }
        
        return from ..< to
    }
}
