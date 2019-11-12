

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var colorRect: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
   
    override func awakeFromNib() {
    super.awakeFromNib()
    colorRect.layer.borderColor = UIColor.black.cgColor
    colorRect.layer.borderWidth = 1
}

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
 
    }

}
