//
//  Dog.swift
//  SeemuSwiftiAd


import UIKit
import iAd

class Dog: UIViewController, ADBannerViewDelegate {
    
    var UIiAd: ADBannerView = ADBannerView()
    
    func appdelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        UIiAd.delegate = self
        UIiAd = self.appdelegate().UIiAd
        UIiAd.frame = CGRectMake(0, 21, 0, 0)
        self.view.addSubview(UIiAd)
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIiAd.delegate = nil
        //UIiAd = nil
        UIiAd.removeFromSuperview()
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        UIiAd.alpha = 1
        UIView.commitAnimations()
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0)
        UIiAd.alpha = 1
        UIView.commitAnimations()
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
