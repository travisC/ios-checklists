//
//  ViewController.swift
//  Checklists
//
//  Created by Travis Cunningham on 3/5/16.
//  Copyright © 2016 Travis Cunningham. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var items: [ChecklistItem]
    
    var checklist: Checklist!

    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        super.init(coder: aDecoder)
        loadChecklistItems()
    }
    
    func loadChecklistItems(){
        //1
        let path = dataFilePath()
        // 2
        if FileManager.default.fileExists(atPath: path) {
            //3
            if let data = NSData(contentsOfFile:path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith:data as Data)
                items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
                unarchiver.finishDecoding()
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[(indexPath as NSIndexPath).row]
        
        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath){
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[(indexPath as NSIndexPath).row]

            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //1 - Remove from Data Model
        items.remove(at: (indexPath as NSIndexPath).row)
        
        //2 - Remove from Table View
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        saveChecklistItems()
    }
    
    
    func configureCheckmarkForCell(_ cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureTextForCell(_ cell: UITableViewCell,
                              withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    
    //Delegate Methods from ItemDetailViewController
    func ItemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismiss(animated: true,completion: nil)
    }
    
    func ItemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {

        let newRowIndex = items.count
        
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true,completion: nil)
        
        saveChecklistItems()
    }
    
    func ItemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismiss(animated: true, completion: nil)
        
        saveChecklistItems()
    }
    
    
    //Attach delegate to seque
    func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        //1
        if segue.identifier == "AddItem" {
            //2
            let navigationController = segue.destination as! UINavigationController
            
            //3
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            //4
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination
                as! UINavigationController
            let controller = navigationController.topViewController
                as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }

    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items,forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(),atomically: true)
    }
    

}

