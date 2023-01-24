//
//  MainViewController.swift
//  LessonsAppDanylo
//
//  Created by Danylo Andriushchenko on 23.01.2023.
//

import Foundation
import UIKit
class MainViewController: UIViewController{
    
    let mainViewModel = MainViewModel()
    
    //Create table view
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LessonCell.self, forCellReuseIdentifier: "LessonCell")
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Lessons"
        
        self.view.backgroundColor = UIColor(red: 27 / 255, green: 26 / 255, blue: 26 / 255, alpha: 1)
        
        self.view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        
        //Fetch lessons and reload table view
        do{
            Task{
                let _ = try await mainViewModel.fetchLessonsFromRemote()
                tableView.reloadData()
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .always
    }
}

//Table view data source and delegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.lessonCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let lessonCell = tableView.dequeueReusableCell(withIdentifier: "LessonCell") as? LessonCell else{
            return UITableViewCell()
        }
        let lessonCellModel = mainViewModel.lessonCellViewModels[indexPath.row]
        lessonCell.buildView(lessonCellViewModel: lessonCellModel)
        
        return lessonCell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lesson = mainViewModel.lessonCellViewModels[indexPath.row].lesson
        
        let lessonDetailViewModel = LessonDetailViewModel(lesson: lesson)
        
        //Push detail view controller
        let lessonDetailController = LessonDetailController()
        lessonDetailController.lessonDetailViewModel = lessonDetailViewModel
        
        self.navigationController?.pushViewController(lessonDetailController, animated: true)
     
    }
}
