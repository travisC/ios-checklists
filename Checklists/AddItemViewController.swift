//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Travis Cunningham on 4/23/16.
//  Copyright © 2016 Travis Cunningham. All rights reserved.
//

import Foundation
import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    
    //Automatically Show Keyboard
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    
    //Cancel Action
    @IBAction func cancel() {
        
        //Clear View
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Done Action
    @IBAction func done() {
        
        //Test value in the textfield
        //print("Contents of the text field: \(textField.text!)")
        
        
        //Clear View
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Prevent the cell from being selected
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) ->NSIndexPath? {
        return nil
    }
    
    //TextField Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    
    
}
