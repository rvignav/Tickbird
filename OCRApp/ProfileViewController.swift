import Foundation
import UIKit
import FirebaseDatabase
import AVKit

class ProfileViewController:UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var physicianField: UITextField!
    @IBOutlet weak var conditionsField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    let synthesizer = AVSpeechSynthesizer()
    let utterance = AVSpeechUtterance(string: "This is your profile. Please enter your name, your physician's name, your conditions, your age, and your password in the fields, then click confirm at the bottom.")
    
    @IBAction func confirmButton(_ sender: Any) {
        if (nameField.text == "" || passField.text == "" || physicianField.text == "" || conditionsField.text == "" || ageField.text == "") {
            let alert = UIAlertController(title: "Error", message: "Please fill out all fields.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            view.endEditing(true)
            var bool = false
            let ref = Database.database().reference()
            let databaseHandle = ref.observe(.childAdded, with: { (snapshot) in
                let name = snapshot.key
                if (name == self.nameField.text as! String) {
                     bool = true
                }
            })
            if (!bool) {
                ref.child("\(nameField.text as! String)/password").setValue(passField.text as! String)
                ref.child("\(nameField.text as! String)/physician").setValue(physicianField.text as! String)
                ref.child("\(nameField.text as! String)/conditions").setValue(conditionsField.text as! String)
                ref.child("\(nameField.text as! String)/age").setValue(ageField.text as! String)
            }
            else {
                let alert = UIAlertController(title: "Error", message: "The username \(nameField.text as! String) is not available. Please choose another.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        synthesizer.speak(utterance)
        configureTextFields()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
               
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([doneButton], animated: false)
        
        nameField.inputAccessoryView = toolbar
        physicianField.inputAccessoryView = toolbar
        ageField.inputAccessoryView = toolbar
        passField.inputAccessoryView = toolbar
        conditionsField.inputAccessoryView = toolbar
    }
           
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    private func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    private func configureTextFields(){
        nameField.delegate = self
        physicianField.delegate = self
        conditionsField.delegate = self
        ageField.delegate = self
        
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
