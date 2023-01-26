//
//  DownloadingView.swift
//  LessonsAppDanylo
//
//  Created by Danylo Andriushchenko on 24.01.2023.
//

import Foundation
import UIKit


//Downloading view which is displayed when video is downloading
class DownloadingView: UIView{
    
    
    var lessonDetailViewModel: LessonDetailViewModel!
    
    ///- Returns:
    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        progressView.sizeToFit()
        progressView.heightAnchor.constraint(equalToConstant: progressView.bounds.height).isActive = true
        return progressView
    }()
    
    ///- Returns: Cancel button that cancels downloading video
    lazy var cancelBtn: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.title = "Cancel downloading"
        config.buttonSize = .small
        config.baseBackgroundColor = .darkGray
        config.baseForegroundColor = .white
        
        let button = UIButton(configuration: config, primaryAction: UIAction{  [weak self] _ in
            self?.didClickOnCancelButton()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    ///- Returns: Activity indicator
    lazy var activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect.zero
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.color = UIColor.lightGray
        indicator.sizeToFit()
        
        indicator.widthAnchor.constraint(equalToConstant: indicator.bounds.width).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: indicator.bounds.height).isActive = true
        return indicator
    }()
    
    

    init(lessonDetailViewModel: LessonDetailViewModel) {
        super.init(frame: CGRect.zero)
        
        self.lessonDetailViewModel = lessonDetailViewModel
        self.backgroundColor = .black.withAlphaComponent(0.5)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(activityIndicator)
        
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.startAnimating()
        
        self.addSubview(progressBar)
        
        progressBar.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor).isActive = true
        progressBar.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 15).isActive = true
        
        self.addSubview(cancelBtn)
        
        cancelBtn.centerXAnchor.constraint(equalTo: progressBar.centerXAnchor).isActive = true
        cancelBtn.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 15).isActive = true
        
        self.isHidden = !lessonDetailViewModel.isDownloading
        progressBar.progress = lessonDetailViewModel.progress
        
        lessonDetailViewModel.didChangeProgress = { [weak self] progress in
            DispatchQueue.main.async {
                self?.progressBar.progress = progress
            }
        }
        
    }
    
    
    ///Cancel downloading
    func didClickOnCancelButton(){
        lessonDetailViewModel.stopDownloadingVideo()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
