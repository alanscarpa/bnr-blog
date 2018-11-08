//
//  PostMetadataCollectionViewCell.swift
//  Blog Nerd Ranch
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import UIKit

class PostMetadataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var authorImageView : UIImageView!
    @IBOutlet weak var authorLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var summaryLabel : UILabel!
    
    private var imageDataTask : URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpAccessibility()
    }
    
    override func prepareForReuse() {
        authorImageView.image = nil
        imageDataTask?.cancel()
    }
    
    private func setUpAccessibility() {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = .staticText
        titleLabel.accessibilityLabel = "Post Title"
        
        authorImageView.isAccessibilityElement = true
        authorImageView.accessibilityTraits = .image
        authorImageView.accessibilityLabel = "Author Image"
        
        authorLabel.isAccessibilityElement = true
        authorLabel.accessibilityTraits = .staticText
        authorLabel.accessibilityLabel = "Author Name"
        
        dateLabel.isAccessibilityElement = true
        dateLabel.accessibilityTraits = .staticText
        dateLabel.accessibilityLabel = "Date"
        
        summaryLabel.isAccessibilityElement = true
        summaryLabel.accessibilityTraits = .staticText
        summaryLabel.accessibilityLabel = "Summary"
    }
    
    func configure(forPostMetaData postMetaData: PostMetadata) {
        titleLabel.text = postMetaData.title
        authorLabel.text = postMetaData.author.name
        dateLabel.text = DateHandler.shared.shortStyle(fromDate: postMetaData.publishDate)
        summaryLabel.text = postMetaData.summary
        
        // todo cache image
        if let url = URL(string: postMetaData.author.image) {
            let imageRequest = ImageRequest(url: url)
            imageDataTask = imageRequest.load { [weak self] image, error in
                // todo handle error
                if let image = image {
                    self?.authorImageView.image = image
                }
            }
        }
    }
}
