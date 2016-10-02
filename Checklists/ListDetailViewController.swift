import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
  
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishAdding checklist: Checklist)
  
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  weak var delegate: ListDetailViewControllerDelegate?
  
  var checklistToEdit: Checklist?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let checklist = checklistToEdit {
      title = "Edit Checklist"
      textField.text = checklist.name
      doneBarButton.isEnabled = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let checklist = checklistToEdit {
      checklist.name = textField.text!
      delegate?.listDetailViewController(self,
                                         didFinishEditing: checklist)
    } else {
      let checklist = Checklist(name: textField.text!)
      delegate?.listDetailViewController(self,
                                         didFinishAdding: checklist)
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    let oldText = textField.text! as NSString
    let newText = oldText.replacingCharacters(in: range, with: string) as NSString
    
    doneBarButton.isEnabled = (newText.length > 0)
    return true
  }  
}
