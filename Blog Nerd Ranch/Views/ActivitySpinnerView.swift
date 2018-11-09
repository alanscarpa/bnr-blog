//
//  ActivitySpinnerView.swift
//  Blog Nerd Ranch
//
//  Created by Alan Scarpa on 11/8/18.
//  Copyright © 2018 Chris Downie. All rights reserved.
//

import UIKit

class ActivitySpinnerView {
    static let shared = ActivitySpinnerView()
    private init(){}
    private var activityIndicatorContainer : UIView?
    
    func showSpinner() {
        if let activityIndicatorContainer = activityIndicatorContainer {
            activityIndicatorContainer.isHidden = false
        } else {
            guard let containerView = UIApplication.shared.keyWindow else { return }
            let spinnerBackgroundView = UIView()
            spinnerBackgroundView.backgroundColor = .black
            spinnerBackgroundView.clipsToBounds = true
            spinnerBackgroundView.layer.cornerRadius = 10
            
            let spinnerView = UIActivityIndicatorView()
            spinnerView.style = UIActivityIndicatorView.Style.whiteLarge
            
            spinnerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            spinnerView.translatesAutoresizingMaskIntoConstraints = false
            
            containerView.addSubview(spinnerBackgroundView)
            spinnerBackgroundView.addSubview(spinnerView)
            NSLayoutConstraint.activate([
                spinnerBackgroundView.heightAnchor.constraint(equalToConstant: 80),
                spinnerBackgroundView.widthAnchor.constraint(equalTo: spinnerBackgroundView.heightAnchor),
                spinnerBackgroundView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                spinnerBackgroundView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                spinnerView.heightAnchor.constraint(equalToConstant: 40),
                spinnerView.widthAnchor.constraint(equalTo: spinnerView.heightAnchor),
                spinnerView.centerXAnchor.constraint(equalTo: spinnerBackgroundView.centerXAnchor),
                spinnerView.centerYAnchor.constraint(equalTo: spinnerBackgroundView.centerYAnchor)
                ])
            spinnerView.startAnimating()
            activityIndicatorContainer = spinnerBackgroundView
        }
    }
    
    func hideSpinner() {
        guard let activityIndicatorContainer = activityIndicatorContainer else { return }
        activityIndicatorContainer.isHidden = true
    }
}
