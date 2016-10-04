//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Matthijs on 05/07/2016.
//  Copyright © 2016 Razeware. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, NSCoding {
  var text = ""
  var checked = false
  var dueDate = Date()
  var shouldRemind = false
  var itemID: Int
  
  override init() {
    itemID = DataModel.nextChecklistItemID()
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    text = aDecoder.decodeObject(forKey: "Text") as! String
    checked = aDecoder.decodeBool(forKey: "Checked")
    
    dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
    shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
    itemID = aDecoder.decodeInteger(forKey: "ItemID")
    super.init()
  }
  
  func toggleChecked() {
    checked = !checked
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(text, forKey: "Text")
    aCoder.encode(checked, forKey: "Checked")
    aCoder.encode(dueDate, forKey: "DueDate")
    aCoder.encode(shouldRemind, forKey: "ShouldRemind")
    aCoder.encode(itemID, forKey: "ItemID")
  }
  
  func scheduleNotification() {
    removeNotification()
    
    if shouldRemind && dueDate > Date() {
      // 1
      let content = UNMutableNotificationContent()
      content.title = "Reminder:"
      content.body = text
      content.sound = UNNotificationSound.default()
      // 2
      let calendar = Calendar(identifier: .gregorian)
      let components = calendar.dateComponents(
        [.month, .day, .hour, .minute], from: dueDate)
      // 3
      let trigger = UNCalendarNotificationTrigger(
        dateMatching: components, repeats: false)
      // 4
      let request = UNNotificationRequest(
        identifier: "\(itemID)", content: content, trigger: trigger)
      // 5
      let center = UNUserNotificationCenter.current()
      center.add(request)
      print("Scheduled notification \(request) for itemID \(itemID)")
    }
  }
  
  func removeNotification() {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(
      withIdentifiers: ["\(itemID)"])
  }
  
  deinit {
    removeNotification()
  }
  
}
