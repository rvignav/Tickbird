import UIKit
import TesseractOCR
import AVKit
import FirebaseDatabase

class ViewController: UIViewController, G8TesseractDelegate {
    
    @IBOutlet weak var name: UITextField!
    var sendname = ""
    let synthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var pastbutton: UIButton!
    
    @IBOutlet weak var password: UITextField!
    let utterance = AVSpeechUtterance(string: "Hello. This is Tickbird™, an app meant to aid visually impaired people in aurally understanding prescriptions from any doctor. Click at the very top right to access our Privacy Policy. Click near the top to Scan a Prescription. If you want to see you past prescriptions, input your name and password, and then click near the middle. Click near the bottom to Update your Profile.")

    @IBAction func clicked(_ sender: Any) {
        if (name.text == "" || password.text == "") {
            let alert = UIAlertController(title: "Error", message: "Please fill out all fields.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let ref = Database.database().reference()
            let pass = password.text
            var firpass = ""
            var bool = false;
            ref.child(name.text as! String).child("password").observeSingleEvent(of: .value, with: { dataSnapshot in
              firpass = dataSnapshot.value as? String ?? ""
                if firpass == pass {
                    bool = true
                }
                if bool {
                    self.sendname = self.name.text!
                    let vc = DatabaseTableViewController(nibName: "DatabaseTableViewController", bundle: nil)
                    vc.finalName = self.sendname
                    self.navigationController?.pushViewController(vc, animated: true)
                    let next = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatabaseTableViewController") as! DatabaseTableViewController
                    self.present(next, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Incorrect username or password", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.speak(utterance)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([doneButton], animated: false)
        
        name.inputAccessoryView = toolbar
        password.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
