//
//  PostMetadataCollectionViewCell.swift
//  Blog Nerd Ranch
//
//  Created by Chris Downie on 8/28/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import UIKit

class PostMetadataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = UIAccessibilityTraits.staticText
        titleLabel.accessibilityLabel = "Post Title"
    }
    
    func configure(forPostMetaData postMetaData: PostMetadata) {
        titleLabel.text = postMetaData.title
    }
}
