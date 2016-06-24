//
//  Post.swift
//  Instagram
//
//  Created by Allison Tang on 6/21/16.
//  Copyright © 2016 Allison Tang. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
    
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        post["username"] = PFUser.currentUser()?.username
        //print (post["username"])
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        post.saveInBackgroundWithBlock(completion)
    }
       class func getPFFileFromImage(image: UIImage?) -> PFFile? {
            // check if image is not nil
            if let image = image {
                // get image data and check if that is not nil
                if let imageData = UIImagePNGRepresentation(image) {
                    return PFFile(name: "image.png", data: imageData)
                }
            }
            return nil
        }

}
