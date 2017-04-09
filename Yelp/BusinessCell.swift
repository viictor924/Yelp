//
//  BusinessCell.swift
//  Yelp
//
//  Created by victor rodriguez on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var business: Business! {
        didSet{
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            categoryLabel.text = business.categories
            
            thumbImageView.setImageWith(business.imageURL!)
            ratingImageView.setImageWith(business.ratingImageURL!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
