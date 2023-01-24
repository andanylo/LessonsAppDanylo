//
//  LessonCell.swift
//  LessonsAppDanylo
//
//  Created by Danil Andriuschenko on 23.01.2023.
//

import Foundation
import UIKit

class LessonCell: UITableViewCell{
    
    
    var lessonCellViewModel: LessonCellViewModel?
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        thumbnailImageView.image = nil
    }
    
    //Lazy initialization of title label
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        //Constraints
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 5
        
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func loadAndSetThumbnailImage(lessonCellViewModel: LessonCellViewModel) async{
        
        guard let thumbnailImage = try? await lessonCellViewModel.asyncLoadThumnnailImage(from: lessonCellViewModel.lesson.thumbnail) else{
            return
        }
        //Check if cell wasn't reused
        if self.lessonCellViewModel === lessonCellViewModel{
            //Set image
            DispatchQueue.main.async {
                self.thumbnailImageView.image = thumbnailImage
            }
        }
    }
    
    
    func buildView(lessonCellViewModel: LessonCellViewModel){
        self.lessonCellViewModel = lessonCellViewModel
        
        //Add thumbnail image view if needed
        if thumbnailImageView.superview == nil{
            self.contentView.addSubview(thumbnailImageView)
            
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15).isActive = true
            thumbnailImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        }
        
        //Load and set thumbnail image
        Task{ [weak self] in
            await self?.loadAndSetThumbnailImage(lessonCellViewModel: lessonCellViewModel)
        }
        //Add title label if not added to the cell
        if titleLabel.superview == nil{
            self.contentView.addSubview(titleLabel)

            titleLabel.leadingAnchor.constraint(equalTo: self.thumbnailImageView.trailingAnchor, constant: 15).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15).isActive = true
            
        }
        
        
        titleLabel.text = lessonCellViewModel.lesson.name

        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.accessoryType = .disclosureIndicator
        self.separatorInset.left = 130
    }
    
    
}
