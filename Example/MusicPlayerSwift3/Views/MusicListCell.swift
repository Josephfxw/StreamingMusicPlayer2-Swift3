//
//  MusicListCell.swift
//  MusicPlayerSwift3
//


import UIKit

class MusicListCell: UITableViewCell {

    @IBOutlet weak var musicNumberLabel: UILabel!
    @IBOutlet weak var musicTitleLabel: UILabel!
    @IBOutlet weak var musicIndicator: MusicPlayerSwift3View!
    
    var state: MusicPlayerSwift3ViewState = .stopped {
        didSet {
            musicIndicator.state = state
            musicNumberLabel.isHidden = state != .stopped
        }
    }
    
    var musicNumber: Int = 1 {
        didSet {
            musicNumberLabel.text = String(musicNumber)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    



}
