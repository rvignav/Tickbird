import UIKit

protocol TableViewNew {
    func onClickCell(index: Int)
}

class NewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    var cellDelegate:TableViewNew?
    var index: IndexPath = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickMe(_ sender: Any) {
        cellDelegate?.onClickCell(index: (index.row))
    }
}
