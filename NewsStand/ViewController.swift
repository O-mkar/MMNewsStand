//
//  ViewController.swift
//  NewsStand
//
//  Created by O-mkar on 12/07/16.
//  Copyright © 2016 O-mkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate, UITableViewDataSource {
    var navigationBarOriginalOffset : CGFloat = 190
    var i = 0
    var horiScroll:UIScrollView!
    let indicatorcolor:UIView! = UIView()
    var labels:[UILabel]! = Array()
    var sticked = false
    var titles:[NSString] = ["Title","Title","Title","Title","Title","Title","Title","Title","Title","Title","Title","Title","Title","Title","Title","Title","Title","Title"]
    var colors:[UIColor]! = [UIColor(hexString: "9c27b0"), UIColor(hexString: "009688"),UIColor(hexString: "9c27b0"), UIColor(hexString: "009688"),UIColor(hexString: "9c27b0"), UIColor(hexString: "009688"),UIColor(hexString: "9c27b0"), UIColor(hexString: "009688"),UIColor(hexString: "9c27b0"), UIColor(hexString: "009688"),UIColor(hexString: "9c27b0"), UIColor(hexString: "009688")]
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var headerImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mScrollView.scrollEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        createHorizontalScroller()
        self.navigationController?.navigationBarHidden = false
        self.tabBarView.clipsToBounds = false
        tabBarView.layer.shadowColor = UIColor.blackColor().CGColor
        tabBarView.layer.shadowOpacity = 1
        tabBarView.layer.shadowOffset = CGSizeZero
        tabBarView.layer.shadowRadius = 5
//        navigationBarOriginalOffset = self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.height
//        print(navigationBarOriginalOffset)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createHorizontalScroller(){
        
        var x , y ,buffer:CGFloat
        
        
        horiScroll=UIScrollView()
        horiScroll.frame=CGRectMake(0, 0, self.tabBarView.frame.width, 47)
        
        tabBarView.insertSubview(horiScroll, aboveSubview: mScrollView);
        
        x=0
        y=0
        buffer=10
        
        
        for i in 0 ..< titles.count {
            
            var titleLabel:UILabel!
            var bottomView:UIView!
            titleLabel=UILabel();
            
            
            //Label
            titleLabel.font=UIFont(name: "Roboto-Medium", size: 14)
            titleLabel.text=titles[i].uppercaseString as String
            titleLabel.userInteractionEnabled=true
            let lblWidth:CGFloat
            lblWidth = titleLabel.intrinsicContentSize().width + 32
            
            titleLabel.frame=CGRectMake(x, 10, lblWidth, 34)
            titleLabel.textAlignment=NSTextAlignment.Center
            titleLabel.tag=i+1
            titleLabel.textColor=UIColor.whiteColor()
            
            //Bottom
            bottomView=UIView()
            bottomView.backgroundColor=UIColor.whiteColor()
            
            
//            let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
//            tap.delegate = self
//            titleLabel.addGestureRecognizer(tap)
            
            
            horiScroll.addSubview(titleLabel)
            labels.append(titleLabel)
            
            x+=lblWidth+buffer
        }
        horiScroll.showsHorizontalScrollIndicator=false;
        horiScroll.backgroundColor=UIColor.clearColor();
        horiScroll.contentSize=CGSizeMake(x,47)
        horiScroll.contentInset = UIEdgeInsetsMake(0, self.view.center.x-25, 0, 0.0);
        horiScroll.contentOffset=CGPointMake(-(self.view.center.x-50), y)
        //        horiScroll.delegate = self
        horiScroll.translatesAutoresizingMaskIntoConstraints = false
        
        if(titles.count != 0){
            indicatorcolor.frame=CGRectMake(labels[0].frame.origin.x, 44, labels[0].intrinsicContentSize().width+32, 3)
            indicatorcolor.backgroundColor=colors[0]
            horiScroll.addSubview(indicatorcolor)
        }
        
        self.view.bringSubviewToFront(horiScroll)
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print(mScrollView.contentOffset.y)
        print(navigationBarOriginalOffset)
        let offset = scrollView.contentOffset.y
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            if(offset > 30){
                self.headerImage.alpha=0
            }
            else {
                
                self.headerImage.alpha=1
            }
            
            
        })

        if mScrollView.contentOffset.y > navigationBarOriginalOffset {
            mScrollView.contentOffset = CGPoint(x: 0, y: navigationBarOriginalOffset)

            if !sticked {
            sticked = true
            UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                self.horiScroll.backgroundColor=self.colors[0]
                self.indicatorcolor.backgroundColor=UIColor.whiteColor()
                self.horiScroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0.0);
                //                            horiScroll.contentOffset=CGPointMake(0, 0)
                self.horiScroll.scrollRectToVisible(self.labels[0].frame, animated: true)
                
                }, completion: nil)
            }
        }else {
            if mScrollView.contentOffset.y < navigationBarOriginalOffset {
                if sticked {
                    sticked = false
                self.horiScroll.setContentOffset(CGPointMake(-(self.view.center.x-50)+self.labels[0].center.x-self.labels[0].frame.size.width/2, 0), animated: true)
                UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                    self.horiScroll.contentInset = UIEdgeInsetsMake(0, self.view.center.x-25, 0, 0.0);

                    self.horiScroll.backgroundColor=UIColor.clearColor()
                    self.indicatorcolor.backgroundColor=self.colors[0]
                    
                    
                    
                    }, completion: nil)
                }
            }
            print(mScrollView.contentOffset.y)
            print(scrollView.contentOffset.y)
            mScrollView.contentOffset.y = offset

            print(" E \(mScrollView.contentOffset.y) ")
        }
//        headerView.frame.origin.y = max(navigationBarOriginalOffset!, scrollView.contentOffset.y)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = "Cell \(indexPath.row)"
        
        return cell!
        
    }
}

