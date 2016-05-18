//
//  FeedViewController.swift
//  chatariffic
//
//  Created by William L. Marr III on 5/15/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newPostField: MaterialTextField!
    @IBOutlet weak var imageSelectImage: UIImageView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 360
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            print("Firebase snapshot value for observeEventType(): \(snapshot.value)")
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snapshot in snapshots {
                    print("Snapshot: \(snapshot)")
                    
                    if let postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                        
                        let key = snapshot.key
                        let post = Post(postKey: key, dictionary: postDictionary)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cameraImageTapped(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(sender: MaterialButton) {
        
        if let postText = newPostField.text where postText != "" {
            if let postImage = imageSelectImage.image {
                print("Attempting to upload image...")
                
                let urlString = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlString)!
                let imageData = UIImageJPEGRepresentation(postImage, 0.2)!
                let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                // Use Alamofire to build up the POST request to ImageShack which comforms
                // to the format expected by their API endpoint.
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    print("Assembling the multipart form data...")
                    
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: imageData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    
                    }, encodingCompletion: { encodingResult in
                        
                        print("Multipart form data completion handler called...")
                        
                        switch encodingResult {
                            case .Success(let upload, _, _):
                                upload.responseJSON(completionHandler: { response in
                                    if let info = response.result.value as? Dictionary<String, AnyObject> {
                                        
                                        if let links = info["links"] as? Dictionary<String, AnyObject> {
                                            if let imageLink = links["image_link"] as? String {
                                                print("Image link: \(imageLink)")
                                            }
                                        }
                                    }
                                })
                            case .Failure(let error):
                                print("Error uploading to ImageShack: \(error)")
                        }
                })
            }
        }
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("postCell") as? PostCell {
            
            cell.request?.cancel()
            
            var image: UIImage?
            
            if let imageURL = post.imageURL {
                image = FeedViewController.imageCache.objectForKey(imageURL) as? UIImage
            }
            
            cell.configureCell(post, image: image)
            return cell
        } else {
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}

extension FeedViewController: UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.imageURL == nil {
            return 150
            
        } else {
            return tableView.estimatedRowHeight
        }
    }
}

extension FeedViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectImage.image = image
    }
}

extension FeedViewController: UINavigationControllerDelegate {
    
}
