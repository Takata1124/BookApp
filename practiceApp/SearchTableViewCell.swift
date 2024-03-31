//
//  SearchTableViewCell.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var item: Item? = nil {
        didSet {
            self.clearImages()
            self.setupImage(item: item)
            self.setupData(item: item)
        }
    }
    
    var indexRow: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func clearImages() {
        imageView1.image = nil
    }
    
    private func setupImage(item: Item?) {
        guard let item = item else { return }
        Task {
            do {
                let image = try await APIClient.alamofireImageRequest(url: item.largeImageUrl)
                imageView1.image = image
            } catch {
                print(error)
            }
        }
    }
    
    private func setupData(item: Item?) {
        guard let item = item else { return }
        titleLabel.text = item.title
    }
}
