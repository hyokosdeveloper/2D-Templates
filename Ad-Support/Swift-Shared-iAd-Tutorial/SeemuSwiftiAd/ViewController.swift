//
//  ViewController.swift
//  SeemuSwiftiAd


import UIKit
import iAd

class ViewController: UIViewController, ADBannerViewDelegate {

    var UIiAd: ADBannerView = ADBannerView()
    
    
     var SH = UIScreen.mainScreen().bounds.height
    var BV: CGFloat = 0
    
    // 1
    func appdelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    // 2
    override func viewWillAppear(animated: Bool) {
       println("Showing ad")
        BV = UIiAd.bounds.height
        
        UIiAd.delegate = self
        UIiAd = self.appdelegate().UIiAd
        UIiAd.frame = CGRectMake(0, SH - BV, 0, 0)
        self.view.addSubview(UIiAd)

        
        self.view.addSubview(UIiAd)
    }
    
    // 3
    override func viewWillDisappear(animated: Bool) {
        UIiAd.delegate = nil
        //UIiAd = nil
        UIiAd.removeFromSuperview()
    }
    
    // 4
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        println("ad loaded")
        UIiAd.frame = CGRectMake(0, SH + 50, 0, 0)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        UIiAd.alpha = 1
        UIiAd.frame = CGRectMake(0, SH - 50, 0, 0)
        UIView.commitAnimations()
    }
    
    // 5
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        println("failed to receive ad")
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0)
        UIiAd.alpha = 1
        UIView.commitAnimations()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

