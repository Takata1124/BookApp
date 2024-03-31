//
//  CollectionViewCell.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/03.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageUrlView: UIImageView!
    
    var item: Item? = nil {
        didSet {
            self.clearImages()
            self.setupImage(item: item)
        }
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func clearImages() {
        imageUrlView.image = nil
    }
    
    private func setupImage(item: Item?) {
        guard let item = item else { return }
        Task {
            do {
                let image = try await APIClient.alamofireImageRequest(url: item.largeImageUrl)
                imageUrlView.image = image
            } catch {
                print(error)
            }
        }
    }
}
