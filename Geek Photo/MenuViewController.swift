//
//  MenuViewController.swift
//  Geek Photo
//
//  Created by Gelei Chen on 15/5/14.
//  Copyright (c) 2015年 Geilei_Chen. All rights reserved.
//

import UIKit
import Social
class MenuViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    var dic :UIDocumentInteractionController?
    let thumbnailImage = UIImage(named: "thumbnail.jpg")
    var imageView:UIImageView?
    var slvc: SLComposeViewController?
    let cellName = ["Facebook","Twitter","WeChat Moment","WeChat Friend","Sina Weibo","Tencent Weibo","Tencent QQ","Tencent Qzone"]
    override func viewDidLoad() {
         super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.label.text = cellName[indexPath.row]
        cell.imageView.image = UIImage(named: cellName[indexPath.row])
        return cell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellName.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        shareToWeChatFriend()
    }
    
    @IBAction func click(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            shareToInstagram()
        } else {
            unableToShare()
        }
        
    }
    
    func unableToShare(){
        let alert = AMSmoothAlertView(dropAlertWithTitle: "Sorry!", andText: "Fail to share. You can try agian.", andCancelButton: false, forAlertType: AlertType.Failure)
        alert.show()
        let delay = 2.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissAlertView()
        })

    }
    
    
    func shareToTwitter(){
        let string = "test iOS twitter share"
        slvc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        self.slvc!.addImage(imageView?.image)
        self.slvc!.setInitialText(string)
        self.presentViewController(slvc!, animated: true, completion: nil)
        
        let alert = AMSmoothAlertView(dropAlertWithTitle: "Success!", andText: "You have successfully shared the image on twitter!", andCancelButton: false, forAlertType: AlertType.Success)
        alert.show()
        let delay = 2.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissAlertView()
        })

    }
    
    func shareToFacebook(){
        let string = "test iOS facebook share"
        slvc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        self.slvc!.addImage(imageView?.image)
        self.slvc!.setInitialText(string)
        self.presentViewController(slvc!, animated: true, completion: nil)
        
        let alert = AMSmoothAlertView(dropAlertWithTitle: "Success!", andText: "You have successfully shared the image on facebook!", andCancelButton: false, forAlertType: AlertType.Success)
        alert.show()
        let delay = 2.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissAlertView()
        })
    }
    
    func shareToWeChatTimeline(){
        var req = SendMessageToWXReq()
        req.scene = Int32(WXSceneTimeline.value)
        req.bText = false
        let media = WXMediaMessage()
        let img = WXImageObject()
        img.imageData = UIImageJPEGRepresentation(imageView!.image, 1.0)
        media.mediaObject = img
        req.message = media
        WXApi.sendReq(req)
        
        let alert = AMSmoothAlertView(dropAlertWithTitle: "Success!", andText: "You have successfully shared the image on WeChat Moments!", andCancelButton: false, forAlertType: AlertType.Success)
        alert.show()
        let delay = 2.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissAlertView()
        })
        
    }
    func shareToWeChatFriend(){
        var req = SendMessageToWXReq()
        req.scene = Int32(WXSceneSession.value)
        req.bText = false
        let media = WXMediaMessage()
        media.title = "代码图片"
        media.description = "把图片变成代码"
        media.setThumbImage(self.thumbnailImage)
        let img = WXImageObject()
        img.imageData = UIImageJPEGRepresentation(imageView!.image, 1.0)
        media.mediaObject = img
        req.message = media
        WXApi.sendReq(req)
        
        let alert = AMSmoothAlertView(dropAlertWithTitle: "Success!", andText: "You have successfully shared the image to your WeChat Friend!", andCancelButton: false, forAlertType: AlertType.Success)
        alert.show()
        let delay = 2.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissAlertView()
        })
        
    }
    func shareToSinaWeibo(){
        let string = "test iOS Sina Weibo share"
        slvc = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        self.slvc!.addImage(imageView?.image)
        self.slvc!.setInitialText(string)
        self.presentViewController(slvc!, animated: true, completion: nil)
        
        let alert = AMSmoothAlertView(dropAlertWithTitle: "Success!", andText: "You have successfully shared the image to your Sina Weibo!", andCancelButton: false, forAlertType: AlertType.Success)
        alert.show()
        let delay = 2.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissAlertView()
        })
    }
    
    func shareToTencentWeibo(){
        let string = "test iOS Tencent Weibo share"
        slvc = SLComposeViewController(forServiceType: SLServiceTypeTencentWeibo)
        self.slvc!.addImage(imageView?.image)
        self.slvc!.setInitialText(string)
        self.presentViewController(slvc!, animated: true, completion: nil)
        
        let alert = AMSmoothAlertView(dropAlertWithTitle: "Success!", andText: "You have successfully shared the image to your Tencent Weibo!", andCancelButton: false, forAlertType: AlertType.Success)
        alert.show()
        let delay = 2.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissAlertView()
        })
    }
    func shareToQQ(){
        
    }
    func shareToQzone(){
        
    }
    
    func shareToInstagram(){
        let savePath = NSHomeDirectory().stringByAppendingPathComponent("Documents/Test.ig")
        UIImagePNGRepresentation(self.imageView?.image).writeToFile(savePath, atomically: true)
        
        let rect = CGRectMake(0, 0, 0, 0)
        let jpgPath = NSHomeDirectory().stringByAppendingPathComponent("Documents/Test.ig")
        let igImageHookFile = NSURL(string: NSString(format: "file://%@", jpgPath) as String)
        dic = UIDocumentInteractionController(URL: igImageHookFile!)
        self.dic?.UTI = "com.instagram.photo"
        let instagramURL = NSURL(string: "instagram://media?id=MEDIA_ID")
        
        
        if UIApplication.sharedApplication().canOpenURL(instagramURL!){
            self.dic?.presentOpenInMenuFromRect(rect, inView: self.view, animated: true)
        } else {
            unableToShare()
        }
    
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
