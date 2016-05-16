//
//  Post.swift
//  chatariffic
//
//  Created by William L. Marr III on 5/16/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import Foundation

class Post {
    private var _postDescription: String!
    private var _imageURL: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    
    var postDescription: String! {
        return _postDescription
    }
    
    var imageURL: String? {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    init(postDescription: String, imageURL: String?, username: String) {
        self._postDescription = postDescription
        self._imageURL = imageURL
        self._username = username
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imageURL = dictionary["imageURL"] as? String {
            self._imageURL = imageURL
        }
        
        if let postDescription = dictionary["description"] as? String {
            self._postDescription = postDescription
        }
    }
}
