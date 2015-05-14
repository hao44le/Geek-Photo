//
//  ASCIViewController.swift
//  Gelei_Chen
//
//  Created by Gelei Chen on 15/4/24.
//  Copyright (c) 2015 Geilei_Chen. All rights reserved.
//

import UIKit
import BKAsciiImage
import AVFoundation
import QuartzCore

class ASCIViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UIAccelerometerDelegate{



    @IBOutlet weak var downView: UIView!{
        didSet{
            downView.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        }
    }

    @IBOutlet weak var scrollView: UIScrollView!{
        didSet {
            scrollView.contentSize = CGSizeMake((UIScreen.mainScreen().bounds.size.height), UIScreen.mainScreen().bounds.size.height)
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 1.0
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet weak var fontSizeSlider: UISlider!{
        didSet{
            fontSizeSlider.tintColor = UIColor.blackColor()
        }
    }
    @IBOutlet weak var fontSizeLabel: UILabel!
   
    var inputImage = UIImage(named: "testImage.png")
    var thumbnailImage = UIImage(named: "thumbnail.jpg")
    let converter = BKAsciiConverter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = self.inputImage
        self.fontSizeSlider.value = Float(self.converter.font.pointSize)
        self.pickImageButton.imageView?.contentMode = .ScaleAspectFit
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "save.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "saveImage:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "shareToWeChat:")

        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.translucent = true
        self.title = "Code image"
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changeFontSize(sender: UISlider) {
        let slider = self.fontSizeSlider
        self.converter.font = UIFont.systemFontOfSize(slider.value.f)
        self.fontSizeLabel.text = NSString(format: "Size: %0.1f", slider.value) as String
        
    }
    
    @IBAction func changeScale(sender: UISwitch) {
        converter.reversedLuminance = !self.converter.reversedLuminance
        
    }
    
    
    @IBAction func reverse(sender: UISwitch) {
        converter.grayscale = !self.converter.grayscale
    }
    
    @IBAction func pickNewImage(sender: UIButton) {
        
        let alertController = UIAlertController(title: "More images", message: nil, preferredStyle: .ActionSheet)
        
        
        let goAction = UIAlertAction(title: "Photo Albums", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
              
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(picker, animated: true, completion: nil)
            } else {
                let alert = AMSmoothAlertView(dropAlertWithTitle: "Sorry!", andText: "Can not open Photo Albums", andCancelButton: false, forAlertType: AlertType.Failure)
                alert.show()
                let delay = 2.0 * Double(NSEC_PER_SEC)
                var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alert.dismissAlertView()
                })
            }
            
        }
        
        alertController.addAction(goAction)
        
        let OKAction = UIAlertAction(title: "Camera", style: .Default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.Camera) {
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType =
                        UIImagePickerControllerSourceType.Camera
                    imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
                    //imagePicker.mediaTypes = [kUTTypeImage as NSString]
                    imagePicker.allowsEditing = false
                    
                    self.presentViewController(imagePicker, animated: true, 
                        completion: nil)
            } else {
                let alert = AMSmoothAlertView(dropAlertWithTitle: "Sorry!", andText: "Can not open camera", andCancelButton: false, forAlertType: AlertType.Failure)
                alert.show()
                let delay = 2.0 * Double(NSEC_PER_SEC)
                var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    alert.dismissAlertView()
                })
            }
            
        }
        alertController.addAction(OKAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
            
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
        alertController.view.tintColor = UIColor.blackColor()
        

    }
    
    func imagePickerDidSelectImage(image: UIImage!) {
        self.imageView.image = image
        self.inputImage = image
        self.pickImageButton.setImage(image, forState: UIControlState.Normal)
       
    }
    @IBAction func convert(sender: UIButton) {
        
        converter.convertImage(self.inputImage, completionHandler: { (asciImage:UIImage?) -> Void in
            UIView.transitionWithView(self.imageView, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.imageView.image = asciImage!
            }, completion: nil)
        })
        converter.convertToString(self.inputImage, completionHandler: { (asciString:String?) -> Void in
            
        })
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = chosenImage
        self.inputImage = chosenImage
        self.pickImageButton.setImage(chosenImage, forState: UIControlState.Normal)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImage(sender: UIButton!){
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
    }
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        if error != nil {
            let alert = AMSmoothAlertView(dropAlertWithTitle: "Sorry!", andText: "\(error.debugDescription)", andCancelButton: false, forAlertType: AlertType.Failure)
            alert.show()
            let delay = 2.0 * Double(NSEC_PER_SEC)
            var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                alert.dismissAlertView()
            })
        } else {
            let alert = AMSmoothAlertView(dropAlertWithTitle: "Congratulation!", andText: "The image has saved", andCancelButton: false, forAlertType: AlertType.Success)
            alert.show()
            let delay = 2.0 * Double(NSEC_PER_SEC)
            var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                alert.dismissAlertView()
            })
        }
        
    }
    
    func shareToWeChat(sender: UIButton!){
       let alert = UIAlertController(title: "Share", message: "Share this face with your WeChat Friends!", preferredStyle: UIAlertControllerStyle.Alert)
        let friend = UIAlertAction(title: "Friend", style: UIAlertActionStyle.Default) { (_) -> Void in
            self.shareToWeChatFriend()
        }
        let moments = UIAlertAction(title: "Moments", style: UIAlertActionStyle.Default) { (_) -> Void in
            self.shareToWeChatTimeline()
        }

        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) { (_) -> Void in
            
        }
        alert.addAction(friend)
        alert.addAction(moments)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func shareToWeChatTimeline(){
        var req = SendMessageToWXReq()
        req.scene = Int32(WXSceneTimeline.value)
        req.bText = false
        let media = WXMediaMessage()
        let img = WXImageObject()
        img.imageData = UIImageJPEGRepresentation(imageView.image, 1.0)
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
        img.imageData = UIImageJPEGRepresentation(imageView.image, 1.0)
        media.mediaObject = img
        req.message = media
        WXApi.sendReq(req)
        
    }
    func shareToInstagram(){
        let imageData = UIImageJPEGRepresentation(imageView.image, 1.0)
        
    }
    

    /*
    func uploadImageToParse(image:UIImage){
        let imageFile = PFFile(data: UIImagePNGRepresentation(image))
        println(imageFile.url)
        var userPhoto = PFObject(className:"UserPhoto")
        userPhoto["imageName"] = "My trip to Hawaii!"
        userPhoto["imageFile"] = imageFile
        userPhoto.saveInBackground()
    }
    func shareToFacebook(sender: UIButton!){
        let shareActionSheet = UIActionSheet()
        
    }

    func getShareLinkContentWithContentURL(url:NSURL)->FBSDKShareLinkContent{
        let content = FBSDKShareLinkContent()
        content.contentURL = url
        return content
    }
    func getShareDialogWithContentURL(url:NSURL)->FBSDKShareDialog{
        let shareDialog = FBSDKShareDialog()
        shareDialog.shareContent = self.getShareLinkContentWithContentURL(url)
        return shareDialog
    }*/
    
    
}
