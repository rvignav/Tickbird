import UIKit
import AVKit
import FirebaseDatabase

var vals = [String]()

class DatabaseTableViewController: UIViewController { // UITableViewDelegate, UITableViewDataSource

    var finalName = ""
    var list = [String]()
    
    @IBOutlet var tableView: UITableView!
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    let synthesizer = AVSpeechSynthesizer()
    let utterance = AVSpeechUtterance(string: "This is all your past prescriptions. They will show up alphabetically. Use accessbility to find the buttons for each prescription. Once you click it, it will read your prescription out loud to you, so make sure you follow the instructions from your doctor. ")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       // synthesizer.speak(utterance)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func data() {
        ref = Database.database().reference()
        databaseHandle = ref?.child("\(finalName)/prescriptions").observe(.childAdded, with: { (snapshot) in
           let post = snapshot.key as? String
            if let actualPost = post {
                self.list.append(actualPost)
                self.tableView.reloadData()
            }
            let p = snapshot.value as? String
            if let act = p {
                vals.append(act)
                self.tableView.reloadData()
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}

extension DatabaseTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewTableViewCell
        
        
        //  UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        //cell.backgroundColor = UIColor(red: 23, green: 22, blue: 60, alpha: 0)
        //cell?.textLabel?.font = UIFont(name: "Futura Medium", size: 20.0)
        //cell.textLabel?.textColor = UIColor(red: 244, green: 197, blue: 102, alpha: 255)
        //cell.textLabel?.backgroundColor = .none
        
        cell?.lblName.text = list[indexPath.row]
        cell?.cellDelegate = self
        cell?.index = indexPath
        
        return(cell!)
    }
}

extension DatabaseTableViewController: TableViewNew {
    func onClickCell(index: Int) {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        let synthesize = AVSpeechSynthesizer()
        let utt = AVSpeechUtterance(string: "Prescription for \(list[index]): \(vals[index])")
        synthesize.speak(utt)
    }
}

