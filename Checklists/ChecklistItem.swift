//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Travis Cunningham on 4/13/16.
//  Copyright © 2016 Travis Cunningham. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    required init?(coder aDecoder: NSCoder) {
        
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        
        super.init()
    }
    
    override init() {
        super.init()
    }

    
    
    func toggleChecked(){
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
}
