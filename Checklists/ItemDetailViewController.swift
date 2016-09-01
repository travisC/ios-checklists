//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Travis Cunningham on 4/23/16.
//  Copyright © 2016 Travis Cunningham. All rights reserved.
//

import Foundation
import UIKit

//Create delegate to pass cancel and finish items
protocol ItemDetailViewControllerDelegate: class {
    func ItemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func ItemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func ItemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}


class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //Add Property for the delegate
    weak var delegate: ItemDetailViewControllerDelegate?
    
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    
    //Automatically Show Keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    
    //Cancel Action
    @IBAction func cancel() {
        
        //Attach he cancel delegate
        delegate?.ItemDetailViewControllerDidCancel(controller: self)
    }
    
    //Done Action
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.ItemDetailViewController(controller: self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.ItemDetailViewController(controller: self, didFinishAddingItem: item)
        }
        
    }
    
    //Prevent the cell from being selected
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) ->IndexPath? {
        return nil
    }
    
    //TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.replacingCharacters(in: range, with: string)
        
        
        doneBarButton.isEnabled = (newText.length > 0)
        
        return true
    }
    
    
    
}
