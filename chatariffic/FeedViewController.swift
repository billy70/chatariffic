//
//  FeedViewController.swift
//  chatariffic
//
//  Created by William L. Marr III on 5/15/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
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

}

extension FeedViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print(post.postDescription)
        return tableView.dequeueReusableCellWithIdentifier("postCell")!
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
        return 300
    }
}
