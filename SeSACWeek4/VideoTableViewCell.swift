//
//  VideoTableViewCell.swift
//  SeSACWeek4
//
//  Created by 홍수만 on 2023/08/09.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    @IBOutlet var thumbnailImageiView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.numberOfLines = 2
        
        thumbnailImageiView.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
