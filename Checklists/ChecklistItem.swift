//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Travis Cunningham on 4/13/16.
//  Copyright © 2016 Travis Cunningham. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
    
}