//
//  IntroViewController.swift
//  Geek Photo
//
//  Created by Gelei Chen on 15/5/16.
//  Copyright (c) 2015年 Geilei_Chen. All rights reserved.
//

import UIKit

class IntroViewController: UINavigationController {

    
    let defauls = NSUserDefaults.standardUserDefaults()
    func showIntro(){
        
        let page1 = EAIntroPage()
        page1.title = "Geek Photo >>"
        page1.desc = "Geek Photo allows you to convert any image into code. It's very cool"
        page1.titleFont = UIFont(name: "Georgia-BoldItalic", size: 20)
        page1.descColor = UIColor.whiteColor()
        page1.descFont = UIFont(name: "Georgia-Italic", size: 15)
        page1.titleIconView = UIImageView(image: UIImage(named: "matrix_1"))
        page1.titleIconView.contentMode = .ScaleAspectFit
        
        let page2 = EAIntroPage()
        page2.title = "For example >>"
        page2.desc = "This is the original image"
        page2.titleIconView = UIImageView(image: UIImage(named: "matrix_1_changed"))
        page2.titleFont = UIFont(name: "Georgia-BoldItalic", size: 20)
        page2.descColor = UIColor.whiteColor()
        page2.descFont = UIFont(name: "Georgia-Italic", size: 15)

        
        let page3 = EAIntroPage()
        page3.title = "This is the Result"
        page3.desc = "Let's Code our photo >_< !!!"
        page3.titleIconView = UIImageView(image: UIImage(named: "matrix_2"))
        page3.titleFont = UIFont(name: "Georgia-BoldItalic", size: 20)
        page3.descColor = UIColor.whiteColor()
        page3.descFont = UIFont(name: "Georgia-Italic", size: 15)

        let intro = EAIntroView(frame: self.view.bounds, andPages: [page1,page2,page3])
        intro.bgImage = UIImage(named: "intro_back")
        
        intro.pageControlY = CGFloat(250)
        
        let btn = UIButton()
        btn.frame = CGRectMake(0, 0, 230, 40)
        btn.setTitle("SKIP NOW", forState: UIControlState.Normal)
        
        
        intro.skipButton = btn
        intro.skipButtonY = CGFloat(60)
        intro.skipButtonAlignment = EAViewAlignment.Center
        intro.showInView(self.view, animateDuration: 0.3)
        
        
        
        defauls.setObject("YES", forKey: "intro_screen_viewed")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (defauls.objectForKey("intro_screen_viewed") == nil) {
            showIntro()
            writeFirstImageToDisk()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func writeFirstImageToDisk(){
        let savePath = NSHomeDirectory().stringByAppendingPathComponent("Documents/userImage.png")
        UIImagePNGRepresentation(UIImage(named: "testImage.png")).writeToFile(savePath, atomically: true)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "imageExist")
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
