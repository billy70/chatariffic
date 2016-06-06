//
//  PostCell.swift
//  chatariffic
//
//  Created by William L. Marr III on 5/15/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var showcaseImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var request: Request?   // Alamofire Request type
    var likeRef: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeTapped(_:)))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
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
        
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
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
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // Note that in Firebase, if there is no data in 'snapshot.value' (i.e., the data does not exist),
            // then 'snapshot.value' will equal NSNull (which means the post was not liked).
            if (snapshot.value as? NSNull) != nil {
                self.likeImage.image = UIImage(named: "heart-empty")
            } else {
                self.likeImage.image = UIImage(named: "heart-full")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // Note that in Firebase, if there is no data in 'snapshot.value' (i.e., the data does not exist),
            // then 'snapshot.value' will equal NSNull (which means the post was not liked).
            if (snapshot.value as? NSNull) != nil {
                self.likeImage.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
            }
        })
    }
}
