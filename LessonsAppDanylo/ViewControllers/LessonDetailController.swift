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
    
    lazy var videoView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
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
