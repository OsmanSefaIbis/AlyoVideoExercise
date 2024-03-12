//
//  VideoCell.swift
//  AlyoCase
//
//  Created by Sefa İbiş on 12.03.2024.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var videoName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with data: VideoItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.videoName.text = data.t
        }
    }
}
