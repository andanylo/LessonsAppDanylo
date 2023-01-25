//
//  LessonDetailController.swift
//  LessonsAppDanylo
//
//  Created by Danil Andriuschenko on 24.01.2023.
//

import Foundation
import UIKit
import AVKit
class LessonDetailController: UIViewController{
    
    var lessonDetailViewModel: LessonDetailViewModel!
    
    
    ///- Returns: Video view which holds video player
    lazy var videoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    
    ///- Returns: A title label which displays title of the lesson
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    
    ///- Returns: Description label which displays description of the lesson
    lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    ///- Returns: A button which presents next lesson detail screen
    ///
    lazy var nextLessonBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 5
        config.title = "Next lesson"
        config.buttonSize = .medium
        
        let button = UIButton(configuration: config, primaryAction: UIAction{
           [weak self] _ in
            self?.presentNextLessonController()
        })
        button.isHidden = lessonDetailViewModel.returnNextDetailViewModel() == nil
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    ///- Returns: A custom download button for navigation bar item
    lazy var downloadBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "icloud.and.arrow.down")
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.title = "Download"
        config.buttonSize = .small
        
        let button = UIButton(configuration: config, primaryAction: UIAction{ [weak self] _ in
            self?.downloadingView.isHidden = false
        })
        return button
    }()
    
    ///- Returns: A download video view that displays downloading info
    lazy var downloadingView: DownloadingView = {
        let view = DownloadingView(lessonDetailViewModel: self.lessonDetailViewModel)
        return view
    }()
    
    var player: AVPlayer?
    var playerController: AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 27 / 255, green: 26 / 255, blue: 26 / 255, alpha: 1)
        
        self.view.addSubview(videoView)
        
        videoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        videoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        videoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        videoView.heightAnchor.constraint(equalTo: videoView.widthAnchor, multiplier: 0.5625).isActive = true
        
        self.view.layoutIfNeeded()
        
        
        buildPlayer()
        
        //Downloading view
        self.view.addSubview(downloadingView)
        
        downloadingView.topAnchor.constraint(equalTo: videoView.topAnchor).isActive = true
        downloadingView.bottomAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        downloadingView.leadingAnchor.constraint(equalTo: videoView.leadingAnchor).isActive = true
        downloadingView.trailingAnchor.constraint(equalTo: videoView.trailingAnchor).isActive = true
        
        //Title label
        self.view.addSubview(titleLabel)
      
        titleLabel.topAnchor.constraint(equalTo: self.videoView.bottomAnchor, constant: 15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.videoView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.videoView.trailingAnchor, constant: -15).isActive = true
        
        titleLabel.text = lessonDetailViewModel.lesson.name
        titleLabel.sizeToFit()
        
        //Descirption label
        self.view.addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        descriptionLabel.text = lessonDetailViewModel.lesson.description
        descriptionLabel.sizeToFit()
        
        
        //Next lesson button
        self.view.addSubview(nextLessonBtn)
        
        nextLessonBtn.sizeToFit()
        nextLessonBtn.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15).isActive = true
        nextLessonBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        
        
        //Download navigation bar button
        let downloadNavigationBarButton = UIBarButtonItem(customView: downloadBtn)
        self.navigationItem.rightBarButtonItem = downloadNavigationBarButton
    }
    
    //Presents detailed view controller next to this one
    func presentNextLessonController(){
        guard let nextLessonViewModel = lessonDetailViewModel.returnNextDetailViewModel() else{
            return
        }
        //Pop to root navigation controller so that the videos wouldn't be stored in the memory
        self.navigationController?.popToRootViewController(animated: true)
        
        let detailController = LessonDetailController()
        detailController.lessonDetailViewModel = nextLessonViewModel
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
  
    //Build a player and add it to the player view
    func buildPlayer(){
        guard let url = URL(string: lessonDetailViewModel.lesson.video_url) else {
            return
        }
        player = AVPlayer(url: url)
        playerController = AVPlayerViewController()
        playerController?.player = player
        playerController?.view.frame.size = videoView.bounds.size
        playerController?.showsPlaybackControls = true
        playerController?.allowsPictureInPicturePlayback = true
        
        self.addChild(playerController!)
        self.videoView.addSubview(playerController!.view)
        
        playerController?.view.translatesAutoresizingMaskIntoConstraints = false
        playerController?.view.topAnchor.constraint(equalTo: videoView.topAnchor).isActive = true
        playerController?.view.bottomAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        playerController?.view.leadingAnchor.constraint(equalTo: videoView.leadingAnchor).isActive = true
        playerController?.view.trailingAnchor.constraint(equalTo: videoView.trailingAnchor).isActive = true
        
        playerController?.didMove(toParent: self)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.largeTitleDisplayMode = .never
    }
}
