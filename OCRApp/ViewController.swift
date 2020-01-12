import UIKit
import TesseractOCR
import AVKit
import FirebaseDatabase

class ViewController: UIViewController, G8TesseractDelegate {
    
    @IBOutlet weak var name: UITextField!
    
    let synthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var password: UITextField!
    let utterance = AVSpeechUtterance(string: "Hello. This is Tickbird™, an app meant to aid visually impaired people in aurally understanding prescriptions from any doctor. Click near the top to Scan a Prescription. Click near the middle to see past prescriptions. Click near the bottom to Update your Profile.")

    @IBAction func clicked(_ sender: Any) {
        let ref = Database.database().reference().child("\(name.text as! String)")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextView") as! DatabaseTableViewController
        let pass = password.text
        if (ref.value(forKey: "password") as! String) == pass {
            self.present(nextViewController, animated:true, completion:nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Username or password incorrect", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.speak(utterance)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }   
}
