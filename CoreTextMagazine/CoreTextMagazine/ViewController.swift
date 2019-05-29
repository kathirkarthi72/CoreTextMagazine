//
//  ViewController.swift
//  CoreTextMagazine
//
//  Created by Premkumar  on 29/05/19.
//  Copyright © 2019 Kathiresan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     
        guard let file = Bundle.main.path(forResource: "zombies", ofType:"txt") else { return }
        
        do {
          let content = try String(contentsOfFile: file, encoding:  .utf8)
            let parser = MarkupParser()
            parser.parserMarkup(content)
            
            (view as? CTView)?.importAttrString(parser.attrString)
        } catch _ {
        }
        
        
        
    }


}

