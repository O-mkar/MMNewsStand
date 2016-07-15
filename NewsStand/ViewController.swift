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
    var horiScroll:UIScrollView!
    let indicatorcolor:UIView! = UIView()
    var labels:[UILabel]! = Array()
    var sticked = false
    var currentPage = 0
    var currentColor = UIColor(hexString: "FA783E")
    var images  = [UIImage]()
    var titles:[NSString] = ["Eating & Drinking","Salon & Spa","Hotel & Leisure","Health & Fitness"]
    var colors:[UIColor]! = [UIColor(hexString: "FA783E"), UIColor(hexString: "009688"),UIColor(hexString: "9c27b0"), UIColor(hexString: "009688"),UIColor(hexString: "9c27b0"), UIColor(hexString: "009688"),UIColor(hexString: "9c27b0"), UIColor(hexString: "009688"),UIColor(hexString: "9c27b0"), UIColor(hexString: "009688"),UIColor(hexString: "9c27b0"), UIColor(hexString: "009688")]
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerImageScrollView: UIScrollView!
    @IBOutlet weak var pagingScrollView: UIScrollView!
    @IBOutlet weak var bannerImage: JBKenBurnsView!
    @IBOutlet weak var bannerAlpha: UIView!
    @IBOutlet weak var bannerThin: UIView!
    @IBOutlet weak var scrollViewContentViewWidth: NSLayoutConstraint!
    @IBOutlet weak var headerImageContentViewWidth: NSLayoutConstraint!
    
    //Table View
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView3: UITableView!
    @IBOutlet weak var tableView4: UITableView!
    var tables = [97,98,99,100]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Banner settings

        bannerImage.clipsToBounds=true
        bannerImage.backgroundColor=UIColor.clearColor()
        bannerAlpha.alpha=0.3
        bannerThin.alpha=0.3
        bannerAlpha.backgroundColor=UIColor.blackColor()
        bannerThin.backgroundColor=UIColor.blackColor()
        
        self.setNeedsStatusBarAppearanceUpdate()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mScrollView.layoutIfNeeded()
        scrollViewContentViewWidth.constant = self.view.frame.width * 4
        headerImageContentViewWidth.constant = self.view.frame.width * 4
        self.bannerAlpha.mdInflateAnimatedFromPoint(CGPointMake(self.headerImage.center.x , self.headerImage.center.y), backgroundColor: self.currentColor, duration: 0.6, completion: nil)
     
        images.append(UIImage(named: "rest-bg.jpg")!)

        bannerImage.animateWithImages(images, transitionDuration:10, initialDelay: 0, loop: false, isLandscape: true)
        
        createHorizontalScroller()
        self.tabBarView.clipsToBounds = false
        tabBarView.layer.shadowColor = UIColor.blackColor().CGColor
        tabBarView.layer.shadowOpacity = 1
        tabBarView.layer.shadowOffset = CGSizeZero
        tabBarView.layer.shadowRadius = 5
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, forBarMetrics: UIBarMetrics.Default)

 
        //        navigationBarOriginalOffset = self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.height
//        print(navigationBarOriginalOffset)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableAtIndex(index: Int) -> UITableView {
        return self.view.viewWithTag(tables[index]) as! UITableView
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
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
//            tap.delegate = self
            titleLabel.addGestureRecognizer(tap)
            
            
            horiScroll.addSubview(titleLabel)
            labels.append(titleLabel)
            
            x+=lblWidth+buffer
        }
        horiScroll.showsHorizontalScrollIndicator=false
        horiScroll.backgroundColor=UIColor.clearColor()
        horiScroll.contentSize=CGSizeMake(x,47)
        horiScroll.contentInset = UIEdgeInsetsMake(0, -self.getCurrentOffset(currentPage), 0, 0.0);
        horiScroll.contentOffset=CGPointMake(-self.getCurrentOffset(currentPage), y)
//                horiScroll.delegate = self
        horiScroll.translatesAutoresizingMaskIntoConstraints = false
        
        if(titles.count != 0){
            indicatorcolor.frame=CGRectMake(labels[currentPage].frame.origin.x, 44, labels[currentPage].intrinsicContentSize().width+32, 3)
            indicatorcolor.backgroundColor=self.currentColor
            horiScroll.addSubview(indicatorcolor)
        }
        
        self.view.bringSubviewToFront(horiScroll)
        
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.tag == 66 || scrollView.tag == 67{
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        let currentIndex:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1

        currentPage = Int(currentIndex)
   
                
            

            
        
            updateUI()
        
    }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print(mScrollView.contentOffset.y)
//        print(navigationBarOriginalOffset)
        let offset = scrollView.contentOffset.y
        
        if scrollView.tag == 66 {
            headerImageScrollView.contentOffset.x = pagingScrollView.contentOffset.x
            return
        }
        
        if scrollView.tag == 67 {
            pagingScrollView.contentOffset.x = headerImageScrollView.contentOffset.x
            return
        }
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            if(offset > 30){
                self.headerImageScrollView.alpha=0
            }
            else {
                
                self.headerImageScrollView.alpha=1
            }
            
            
        })

        if mScrollView.contentOffset.y > navigationBarOriginalOffset {
            
            mScrollView.contentOffset = CGPoint(x: 0, y: navigationBarOriginalOffset)



            if !sticked {
            sticked = true
            UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in

                self.horiScroll.backgroundColor=self.currentColor
                self.indicatorcolor.backgroundColor=UIColor.whiteColor()
                self.horiScroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0.0);
                //                            horiScroll.contentOffset=CGPointMake(0, 0)
                self.horiScroll.scrollRectToVisible(self.labels[self.currentPage].frame, animated: true)
                
                }, completion: nil)
            }
        }else {
            if mScrollView.contentOffset.y < navigationBarOriginalOffset {
                if sticked {
                    sticked = false
                    self.horiScroll.setContentOffset(CGPointMake(currentPage == 0 ? -self.getCurrentOffset(currentPage) : self.getCurrentOffset(currentPage), 0), animated: true)
                UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                    self.horiScroll.contentInset = UIEdgeInsetsMake(0, self.getCurrentOffset(0), 0, 0.0);
                
                    self.horiScroll.backgroundColor=UIColor.clearColor()
                    self.indicatorcolor.backgroundColor=self.currentColor
                    
                    
                    
                    }, completion: nil)
                }
            }
            print(scrollView.contentOffset.y)
            
            if offset < 0.0 {
                mScrollView.contentOffset.y = 0.0
            }else{
                    mScrollView.contentOffset.y = offset
            }
            print(" E \(mScrollView.contentOffset.y) ")
        }
    

    }
    
    func getCurrentOffset(buttons: Int) -> CGFloat{

        if buttons == 0 {
            return self.view.center.x-((labels[buttons].intrinsicContentSize().width+32)/2)

        }
        return self.labels[buttons].center.x-self.view.center.x
    }
    func moveToPage(index: Int){
        
    var frame = pagingScrollView.frame;
    frame.origin.x = frame.size.width * CGFloat(index)
    frame.origin.y = 0

    self.pagingScrollView.scrollRectToVisible(frame, animated: true)

    }
    func handleTap(sender:UIGestureRecognizer){
        //uncomment  it when you require to change the colors according to category
        //currentColor=colors[sender.view!.tag-1]
        
        currentPage = sender.view!.tag-1
        print("Current Page: \(currentPage)")
        moveToPage(currentPage)

        // Notify delegate about the new page
        
        updateUI()
//        self.bannerAlpha.mdInflateAnimatedFromPoint(CGPointMake(self.bannerImage.center.x , self.bannerImage.center.y), backgroundColor: self.currentColor, duration: 0.6, completion: nil)
    }
    
    func updateUI(){
        
        self.horiScroll.setContentOffset(CGPointMake(currentPage == 0 ? -self.getCurrentOffset(currentPage) : self.getCurrentOffset(currentPage), 0), animated: true)
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
            self.mScrollView.contentOffset.y = 0.0
            self.tableAtIndex(self.currentPage).contentOffset.y = 0.0
            
            self.horiScroll.contentInset = UIEdgeInsetsMake(0, self.getCurrentOffset(0), 0, 0.0);
            
            self.horiScroll.backgroundColor=UIColor.clearColor()
            self.indicatorcolor.backgroundColor=self.currentColor
            
            }, completion: nil)
        
        if mScrollView.contentOffset.y >= navigationBarOriginalOffset{
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.indicatorcolor.frame=CGRectMake(self.labels[self.currentPage].frame.origin.x, 44, self.labels[self.currentPage].intrinsicContentSize().width+32, 3)
                self.indicatorcolor.backgroundColor=UIColor.whiteColor()
                
                self.horiScroll.scrollRectToVisible(self.labels[self.currentPage].frame, animated: true)
                self.horiScroll.backgroundColor=self.currentColor
                
            })
            
            
        }
        else{
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.indicatorcolor.frame=CGRectMake(self.labels[self.currentPage].frame.origin.x, 44, self.labels[self.currentPage].intrinsicContentSize().width+32, 3)
                self.indicatorcolor.backgroundColor=self.currentColor
                //                self.horiScroll.scrollRectToVisible(self.labels[sender.view!.tag-1].frame, animated: true)
                
                //Center Content
                self.horiScroll.setContentOffset(CGPointMake(self.currentPage == 0 ? -self.getCurrentOffset(self.currentPage) : self.getCurrentOffset(self.currentPage), 0), animated: true)
                self.horiScroll.contentInset = UIEdgeInsetsMake(0, self.getCurrentOffset(0), 0, 0.0);
                
                
            })
            self.bannerAlpha.mdInflateAnimatedFromPoint(CGPointMake(self.headerImage.center.x , self.headerImage.center.y), backgroundColor: self.colors[currentPage], duration: 0.6, completion: nil)
            
        }
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

