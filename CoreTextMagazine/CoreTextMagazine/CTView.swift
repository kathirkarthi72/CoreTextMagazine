//
//  CTView.swift
//  CoreTextMagazine
//
//  Created by Premkumar  on 29/05/19.
//  Copyright © 2019 Kathiresan. All rights reserved.
//

import UIKit

class CTView: UIScrollView {
    
    // MARK: - Properties
    var attrString: NSAttributedString!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let path = CGMutablePath()
        path.addRect(bounds)
        
        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        
        CTFrameDraw(frame, context)
    }
    
    // MARK: - Internal
    func importAttrString(_ attrString: NSAttributedString) {
        self.attrString = attrString
    }
    
}
