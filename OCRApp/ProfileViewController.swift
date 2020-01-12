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
    let utterance = AVSpeechUtterance(string: "This is your profile. Please enter your name, your physician's name, your conditions, your age, and your password in the fields.")
    
    @IBAction func confirmButton(_ sender: Any) {
        view.endEditing(true)
        let ref = Database.database().reference()
         ref.child("\(nameField.text as! String)/password").setValue(passField.text as! String)
        ref.child("\(nameField.text as! String)/physician").setValue(physicianField.text as! String)
        ref.child("\(nameField.text as! String)/conditions").setValue(conditionsField.text as! String)
        ref.child("\(nameField.text as! String)/age").setValue(ageField.text as! String)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        synthesizer.speak(utterance)
        configureTextFields()
        
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
