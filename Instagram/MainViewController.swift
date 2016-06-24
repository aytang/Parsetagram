//
//  MainViewController.swift
//  Instagram
//
//  Created by Allison Tang on 6/20/16.
//  Copyright © 2016 Allison Tang. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    //let CellIdentifier = "postTableViewCell", HeaderViewIdentifier = "postTableViewHeaderView"
    @IBOutlet weak var tableView: UITableView!
    var counter = 0
    var rows = 20
    @IBAction func isLogOff(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock{(error: NSError?) in
            print ("You are logged off.")
             self.performSegueWithIdentifier("logOutSegue", sender: nil)
        }
        }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            //isMoreDataLoading = true
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                isMoreDataLoading = true
                loadMoreData()
                //print ("we're at the bottom!")
                //print (counter)
                
            }
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func loadMoreData(){
        isMoreDataLoading = false
        rows += 1
        self.loadingMoreView!.stopAnimating()
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        //tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
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
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (data, response, error) in
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        });
        task.resume()

        
        // Do any additional setup after loading the view.
    }

func refreshControlAction(refreshControl: UIRefreshControl) {
    refreshControl.endRefreshing()
    self.tableView.reloadData()
    
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postTableViewCell", forIndexPath: indexPath) as! postTableViewCell
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                let post = posts[indexPath.row]
                cell.userLabel.text = post["username"] as? String
                let time = post.createdAt!
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MMM dd, H:mm a"
                cell.captionLabel.text = post["caption"] as? String
                cell.recapLabel.text = post["caption"] as? String
                cell.timeLabel.text = "Time posted:\(formatter.stringFromDate(time))"
                cell.likesLabel.text = "Likes: \(cell.likes)"
                cell.createdLabel.text = "\(formatter.stringFromDate(time))"
                //cell.createdLabel.text = "\(post.createdAt!)"
                post["media"].getDataInBackgroundWithBlock {(imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            cell.pictureView.image = UIImage(data: imageData)
                            //self.counter += 1
                        }
                    }
                }
               // cell.pictureView.image = Post.post["media"]
                //cell.captionLabel.text = Post.post["caption"]
                //}
            } else {
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
         let post = posts[indexPath!.row]
        let detailViewController = segue.destinationViewController as! detailViewController
        detailViewController.post = post
            }}
        print ("prepare for segue called")
 
    }
 */
/*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        header.headerLabel.text = "hi"
        return header
    }
 */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
