//
//  yourPostsViewController.swift
//  Instagram
//
//  Created by Allison Tang on 6/22/16.
//  Copyright © 2016 Allison Tang. All rights reserved.
//

import UIKit
import Parse

class yourPostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    @IBOutlet weak var profPicImageView: UIImageView!
    @IBOutlet weak var yourTableView: UITableView!
   
    @IBOutlet weak var makeProfPic: UIButton!
    var counter = 0
    var rows = 0
    var numPosts = 0
    
    @IBAction func dismissProfPic(sender: AnyObject) {
        self.profPicImageView.hidden = true
        self.makeProfPic.hidden = true
    }
    
    @IBAction func setProfPic(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        //vc.sourceType = UIImagePickerControllerSourceType.Camera
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)

        //self.performSegueWithIdentifier("profPicSegue", sender: nil)
        
    }
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        //profPicImageView.image = editedImage
        // Do something with the images (based on your use case)
        
        //completion goes to the next block of code to be executed
        
        print ("got the pic")
        profPicImageView.image = originalImage
        self.profPicImageView.hidden = false
        self.makeProfPic.hidden = false
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func isLogOff(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock{(error: NSError?) in
            print ("You are logged off.")
            self.performSegueWithIdentifier("logOutSegue", sender: nil)
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            //isMoreDataLoading = true
            let scrollViewContentHeight = yourTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - yourTableView.bounds.size.height
            if (scrollView.contentOffset.y > scrollOffsetThreshold && yourTableView.dragging) {
                let frame = CGRectMake(0, yourTableView.contentSize.height, yourTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                isMoreDataLoading = true
                loadMoreData()
                //print ("we're at the bottom!")
                //print (counter)
                
            }
        }
    }
    
    func loadMoreData(){
        isMoreDataLoading = false
        rows += 1
        self.loadingMoreView!.stopAnimating()
        self.yourTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        yourTableView.delegate = self
        self.makeProfPic.hidden = true
        self.profPicImageView.hidden = true
        yourTableView.dataSource = self
        let frame = CGRectMake(0, yourTableView.contentSize.height, yourTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        yourTableView.addSubview(loadingMoreView!)
        var insets = yourTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        yourTableView.contentInset = insets
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        yourTableView.insertSubview(refreshControl, atIndex: 0)
        let url = NSURL(string: "https://www.instagram.com")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (data, response, error) in
            self.yourTableView.reloadData()
            refreshControl.endRefreshing()
        });
        task.resume()
        
        
        // Do any additional setup after loading the view.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        self.yourTableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("yourTableViewCell", forIndexPath: indexPath) as! yourTableViewCell
        let query = PFQuery(className: "Post")
        //query.whereKey("likesCount", greaterThan: 100)
        //query.limit = 20
        query.orderByDescending("createdAt")
        //query.whereKey("author", equalTo: PFUser.self)
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                let post = posts[indexPath.row]
                //print ("1.\(PFUser.currentUser()?.username as String!)")
                //print ("2.\(post["username"])")
                if "\(post["username"])" == "\(PFUser.currentUser()?.username as String!)" {
                self.numPosts += 1
                cell.capLabel.text = post["caption"] as? String
                //cell.recapLabel.text = post["caption"] as? String
                //cell.timeLabel.text = post["timeStamp"] as? String
                post["media"].getDataInBackgroundWithBlock {(imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            cell.picImageView.image = UIImage(data: imageData)
                            self.counter += 1
                        }
                    }
                    }
                // cell.pictureView.image = Post.post["media"]
                //cell.captionLabel.text = Post.post["caption"]
                //}
                }
            }
            else {
                print(error?.localizedDescription)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
         let query = PFQuery(className: "Post")
         query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
         if let posts = posts {
         */
        return rows
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
