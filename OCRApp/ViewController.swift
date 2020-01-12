import UIKit
import TesseractOCR
import AVKit
import FirebaseDatabase

class ViewController: UIViewController, G8TesseractDelegate {
    
    @IBOutlet weak var name: UITextField!
    var sendname = ""
    let synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var password: UITextField!
    let utterance = AVSpeechUtterance(string: "Hello. This is Tickbird™, an app meant to aid visually impaired people in aurally understanding prescriptions from any doctor. Click near the top to Scan a Prescription. Click near the middle to see past prescriptions. Click near the bottom to Update your Profile.")

    @IBAction func clicked(_ sender: Any) {
        let ref = Database.database().reference().child("\(name.text as! String)")
        let pass = password.text
        if (ref.value(forKey: "password") as! String) == pass {
            self.sendname = name.text!
            performSegue(withIdentifier: "username", sender: self)
        } else {
            let alert = UIAlertController(title: "Error", message: "Username or password incorrect", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! DatabaseTableViewController
        vc.finalName = self.sendname
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.speak(utterance)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }   
}
