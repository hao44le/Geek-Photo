//
//  MenuViewController.swift
//  Geek Photo
//
//  Created by Gelei Chen on 15/5/14.
//  Copyright (c) 2015年 Geilei_Chen. All rights reserved.
//

import UIKit
import Social
class MenuViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    var dic :UIDocumentInteractionController?
    let thumbnailImage = UIImage(named: "thumbnail.jpg")
    var imageView:UIImageView?
    var slvc: SLComposeViewController?
    let cellName = ["Facebook","Twitter","WeChat Moment","WeChat Friend","Sina Weibo","Tencent Weibo","Tencent QQ","Tencent Qzone"]
    override func viewDidLoad() {
         super.viewDidLoad()
        if (self.view.bounds.size.height < 420) {
            
        
        //6 plus
        } else if (self.view.bounds.size.height == 736) {
            self.seperatorView.frame = CGRectMake(8, 250, 360, 1)
            self.topImageView.frame = CGRectMake(110, 50, 170, 170)
            self.shareLabel.frame = CGRectMake(150, 3, 75, 29)
            self.collectionView.frame = CGRectMake(40, 270, 400,400)
            // 6
        } else if (self.view.bounds.size.height == 667) {
           self.seperatorView.frame = CGRectMake(8, 210, 320, 1)
            self.topImageView.frame = CGRectMake(95, 40, 150, 150)
            self.shareLabel.frame = CGRectMake(130, 3, 75, 29)
            self.collectionView.frame = CGRectMake(20, 250, 367,350)
            
            // 5s / 5
        } else if (self.view.bounds.size.height == 568) {
           
            // 4s
        } else if (self.view.bounds.size.height == 480) {
            self.seperatorView.frame = CGRectMake(8, 150, 270, 1)
            self.topImageView.frame = CGRectMake(90, 25, 120, 120)
            self.shareLabel.frame = CGRectMake(120, 3, 75, 20)
            self.collectionView.frame = CGRectMake(0, 170, 367,300)
            // ipad
        } else {
           
        }

        
        // Do any additional setup after loading the view.
    }



    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var shareLabel: UILabel!
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
        cell.height = self.view.bounds.size.height
        
        return cell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellName.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                shareToFacebook()
            } else {
                unableToShare()
            }
            
        case 1:
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                shareToTwitter()
            } else {
                unableToShare()
            }
        case 2:
            //moments
            shareToWeChatTimeline()
        case 3:
            //friend
            shareToWeChatFriend()
        case 4:
            //sina weibo
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeSinaWeibo){
                shareToSinaWeibo()
            } else {
                unableToShare()
            }
        case 5:
            //tencent weibo
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTencentWeibo){
                shareToTencentWeibo()
            } else {
                unableToShare()
            }
        case 6:
            //tencent qq
            shareToQQ()
        case 7:
            //tencent qzone
            shareToQzone()
        default:break
        }
    }
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            if (self.view.bounds.size.height < 420) {
                return CGSize(width: 65, height: 65)
                
                //6 plus
            } else if (self.view.bounds.size.height == 736) {
                return CGSize(width: 65, height: 65)
                // 6
            } else if (self.view.bounds.size.height == 667) {
                return CGSize(width: 80, height: 80)
                // 5s / 5
            } else if (self.view.bounds.size.height == 568) {
                return CGSize(width: 65, height: 65)
                // 4s
            } else if (self.view.bounds.size.height == 480) {
                return CGSize(width: 65, height: 65)
                // ipad
            } else {
                return CGSize(width: 65, height: 65)
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
        let string = "I just create this cool code image. You can try one yourself. It's avaliable on App Store. It's called Geek Photo"
        slvc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        self.slvc!.addImage(imageView?.image)
        self.slvc!.setInitialText(string)
        self.presentViewController(slvc!, animated: true, completion: nil)


    }
    
    func shareToFacebook(){
        let string = "I just create this cool code image. You can try one yourself. It's avaliable on App Store. It's called Geek Photo"
        slvc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        self.slvc!.addImage(imageView?.image)
        self.slvc!.setInitialText(string)
        self.presentViewController(slvc!, animated: true, completion: nil)
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

        
    }
    func shareToSinaWeibo(){
        let string = "I just create this cool code image. You can try one yourself. It's avaliable on App Store. It's called Geek Photo"
        slvc = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        self.slvc!.addImage(imageView?.image)
        self.slvc!.setInitialText(string)
        self.presentViewController(slvc!, animated: true, completion: nil)
        
    }
    
    func shareToTencentWeibo(){
        let string = "I just create this cool code image. You can try one yourself. It's avaliable on App Store. It's called Geek Photo"
        slvc = SLComposeViewController(forServiceType: SLServiceTypeTencentWeibo)
        self.slvc!.addImage(imageView?.image)
        self.slvc!.setInitialText(string)
        self.presentViewController(slvc!, animated: true, completion: nil)
        

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
