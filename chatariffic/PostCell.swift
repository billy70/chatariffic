//
//  PostCell.swift
//  chatariffic
//
//  Created by William L. Marr III on 5/15/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var showcaseImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!
    var request: Request?   // Alamofire Request type
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        showcaseImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(post: Post, image: UIImage?) {
        self.post = post
        
        if let postDescription = post.postDescription where post.postDescription != "" {
            self.descriptionText.text = postDescription
        } else {
            self.descriptionText.text = ""
        }
        
        self.likesLabel.text = "\(post.likes)"
        
        if post.imageURL != nil {
            
            if image != nil {
                self.showcaseImage.image = image
            } else {
                
                request = Alamofire.request(.GET, post.imageURL!)
                    .validate(contentType: ["image/*"])
                    .response(completionHandler: { (request, response, data, error) in
                    
                    if error == nil {
                        let responseImage = UIImage(data: data!)!
                        self.showcaseImage.image = responseImage
                        FeedViewController.imageCache.setObject(responseImage, forKey: self.post.imageURL!)
                    } else {
                        print("Error getting image from URL \(post.imageURL)")
                    }
                })
                
            }
        } else {
            self.showcaseImage.hidden = true
        }
    }
}
