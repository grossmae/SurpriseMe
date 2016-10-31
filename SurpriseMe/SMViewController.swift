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
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(SMViewController.keyboardWasShown(_:)), name:.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(SMViewController.keyboardWillHide(_:)), name:.UIKeyboardWillHide, object: nil);
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
            make.width.equalTo(view)
        }
        
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        loadingView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        
        loadingView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(loadingView)
        }
        
        loadingView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setBottomView(bottomView: UIView) {
        contentView.snp.updateConstraints { (make) -> Void in
            make.bottom.equalTo(bottomView)
        }
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
        view.bringSubview(toFront: loadingView)
        loadingView.isHidden = false
    }
    
    func stopLoading() {
        loadingView.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func keyboardWasShown(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInsets;
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero;
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
