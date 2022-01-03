//
//  DocsTableViewCell.swift
//  FaceKi
//
//  Created by Logictrix on 09/12/21.
//

import UIKit

class DocsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageLeading: NSLayoutConstraint!
    @IBOutlet weak var lblLeading: NSLayoutConstraint!
    @IBOutlet weak var imageheight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    @IBOutlet weak var holderVw_1: UIView!
    @IBOutlet weak var seriesLbl_1: UILabelCustomClass!
    @IBOutlet weak var docPhotoVw_1: UIImageView!
    @IBOutlet weak var docTextLbl_1: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
