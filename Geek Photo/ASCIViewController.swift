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

class ASCIViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UIAccelerometerDelegate,EAIntroDelegate{


    func introDidFinish(introView: EAIntroView!) {
        println("finish")
    }
    
    
    @IBOutlet weak var downView: UIView!{
        didSet{
            downView.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
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
    @IBOutlet weak var rightView: UIView!
    
    
    var inputImage = UIImage(named: "testImage.png")
    let converter = BKAsciiConverter()
    var pickFromCamera = false
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("imageExist"){
            loadImageFromDisk()
        } else {
            self.imageView.image = self.inputImage
        }
        
               
        
        if (self.view.bounds.size.height < 420) {
            imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
            rightView.frame = CGRectMake(self.view.bounds.size.width-199, 0, 199, 150)
            downView.frame = CGRectMake(0, self.view.bounds.height-150, self.view.bounds.size.width, 150)
            
            //6 plus
        } else if (self.view.bounds.size.height == 736) {
            imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 736)
            rightView.frame = CGRectMake(self.view.bounds.size.width-199, 0, 199, 150)
            downView.frame = CGRectMake(0, self.view.bounds.height-150, self.view.bounds.size.width, 150)
            // 6
        } else if (self.view.bounds.size.height == 667) {
            imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 667)
            rightView.frame = CGRectMake(self.view.bounds.size.width-199, 0, 199, 150)
            downView.frame = CGRectMake(0, 518, self.view.bounds.size.width, 150)
            // 5s / 5
        } else if (self.view.bounds.size.height == 568) {
            downView.frame = CGRectMake(0, 418, 320, 150)
            // 4s
        } else if (self.view.bounds.size.height == 480) {
            imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
            rightView.frame = CGRectMake(self.view.bounds.size.width-199, 0, 199, 150)
            downView.frame = CGRectMake(0, self.view.bounds.height-150, self.view.bounds.size.width, 150)
            // ipad
        } else {
            imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
            rightView.frame = CGRectMake(self.view.bounds.size.width-199, 0, 199, 150)
            downView.frame = CGRectMake(0, self.view.bounds.height-150, self.view.bounds.size.width, 150)
        }

        self.imageView.contentMode = .ScaleAspectFit
       
        self.fontSizeSlider.value = Float(self.converter.font.pointSize)
        self.pickImageButton.imageView?.contentMode = .ScaleAspectFit
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "save.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "saveImage:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "shareToWeChat:")

        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.translucent = true
        self.title = "Geek Photo"
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
                    imagePicker.allowsEditing = true
                    self.pickFromCamera = true
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
        //self.inputImage = image
        self.pickImageButton.setImage(image, forState: UIControlState.Normal)
       
    }
    @IBAction func convert(sender: UIButton) {
        writeImageToDisk()
        converter.convertImage(self.imageView.image, completionHandler: { (asciImage:UIImage?) -> Void in
            UIView.transitionWithView(self.imageView, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.imageView.image = asciImage!
            }, completion: nil)
        })
        converter.convertToString(self.imageView.image, completionHandler: { (asciString:String?) -> Void in
            
        })
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = chosenImage
        //self.inputImage = chosenImage
        self.pickImageButton.setImage(chosenImage, forState: UIControlState.Normal)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImage(sender: UIButton!){
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
    }
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        writeImageToDisk()
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
        self.performSegueWithIdentifier("toPopup", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPopup"{
            let dvc = segue.destinationViewController as! MenuViewController
            dvc.imageView = self.imageView
            let popupSegue = segue as! CCMPopupSegue
            
            
            if (self.view.bounds.size.height < 420) {
                
                popupSegue.destinationBounds = CGRectMake(0, 0, 300, 400)
                //6 plus
            } else if (self.view.bounds.size.height == 736) {
                popupSegue.destinationBounds = CGRectMake(0, 0, (UIScreen.mainScreen().bounds.size.height-200) * 0.6, UIScreen.mainScreen().bounds.size.height-260)
                // 6
            } else if (self.view.bounds.size.height == 667) {
                popupSegue.destinationBounds = CGRectMake(0, 0, (UIScreen.mainScreen().bounds.size.height-150) * 0.65, UIScreen.mainScreen().bounds.size.height-200)
                // 5s / 5
            } else if (self.view.bounds.size.height == 568) {
                popupSegue.destinationBounds = CGRectMake(0, 0, (UIScreen.mainScreen().bounds.size.height-150) * 0.7, UIScreen.mainScreen().bounds.size.height-200)
                // 4s
            } else if (self.view.bounds.size.height == 480) {
                popupSegue.destinationBounds = CGRectMake(0, 0, (UIScreen.mainScreen().bounds.size.height-100) * 0.76, UIScreen.mainScreen().bounds.size.height-150)
                // ipad
            } else {
                popupSegue.destinationBounds = CGRectMake(0, 0, (UIScreen.mainScreen().bounds.size.height-100) * 0.7, UIScreen.mainScreen().bounds.size.height-150)
            }
            popupSegue.backgroundBlurRadius = 7
            popupSegue.backgroundViewAlpha = 0.3
            popupSegue.backgroundViewColor = UIColor.blackColor()
            popupSegue.dismissableByTouchingBackground = true
            
        }
        
    }

    
    func writeImageToDisk(){
        let savePath = NSHomeDirectory().stringByAppendingPathComponent("Documents/userImage.png")
        if pickFromCamera{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "imageExist")
        } else {
            UIImagePNGRepresentation(self.imageView?.image).writeToFile(savePath, atomically: true)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "imageExist")
        }
        

        
    }
    func loadImageFromDisk(){
        let jpgPath = NSHomeDirectory().stringByAppendingPathComponent("Documents/userImage.png")
        self.imageView.image = UIImage(contentsOfFile: jpgPath)
        self.pickImageButton.setImage(UIImage(contentsOfFile: jpgPath), forState: UIControlState.Normal)
    }
            

    }

    

