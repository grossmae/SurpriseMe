//
//  SMViewController.swift
//  SurpriseMe
//
//  Created by Evan Grossman on 9/2/16.
//  Copyright © 2016 Evan Grossman. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SMViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let loadingView = UIView()
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_topLayoutGuideBottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(self.snp_bottomLayoutGuideTop)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
            make.width.equalTo(view)
        }
        
        view.addSubview(loadingView)
        loadingView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        loadingView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.7)
        
        loadingView.addSubview(loadingIndicator)
        loadingIndicator.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(loadingView)
        }
        
        loadingView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setBottomView(bottomView: UIView) {
        contentView.snp_updateConstraints { (make) -> Void in
            make.bottom.equalTo(bottomView)
        }
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
        view.bringSubviewToFront(loadingView)
        loadingView.hidden = false
    }
    
    func stopLoading() {
        loadingView.hidden = true
        loadingIndicator.stopAnimating()
    }
    
    func keyboardWasShown(notification: NSNotification) {
        
        let info: NSDictionary = notification.userInfo!
        let keyboardBeg = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue
        let keyboardSize = keyboardBeg!.size
        
        let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height + 75, 0)
        scrollView.contentInset = contentInsets;
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero;
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
}