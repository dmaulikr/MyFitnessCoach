//
//  RoutineViewerVC.swift
//  MyFitnessCoach
//
//  Created by Andrew Meng on 2017-03-25.
//  Copyright © 2017 Andrew Meng. All rights reserved.
//

import UIKit

final class RoutineViewerVC : UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var routine : [String : AnyObject]? {
        didSet {
            includedExercises = routine?["exercises"] as? [String : AnyObject]
        }
    }
    
    private var includedExercises : [String : AnyObject]?
    
    private var exerciseTableView = UITableView()
    private var exerciseCollectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseTableView.register(ExerciseTableViewCell.self, forCellReuseIdentifier: "exerciseTableCell")
        exerciseCollectionView.register(ExerciseCollectionViewCell.self, forCellWithReuseIdentifier: "exerciseCollectionCell")
    }
    
    // MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return includedExercises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseTableCell") as? ExerciseTableViewCell
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        
    }
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return includedExercises?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseCollectionCell", for: indexPath) as? ExerciseCollectionViewCell
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }
    
}

class ExerciseTableViewCell : UITableViewCell {
    
    var exerciseDic : [String : AnyObject]? {
        didSet {
            if let exerciseTitle = exerciseDic?["title"] as? String {
                title = exerciseTitle
            }
            if let creatorTitle = exerciseDic?["creatorName"] as? String {
                creator = creatorTitle
            }
        }
    }
    var mediaDic : [String : AnyObject]? {
        didSet {
            if let image = mediaDic?["image"] as? UIImage {
                mediaImageView.image = image
            }
        }
    }
    
    private var title : String?
    private var creator : String?
    private var mediaImageView = UIImageView()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: standardFont, size: 22)
        return label
    }()
    
    private lazy var creatorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: standardFont, size: 16)
        return label
    }()
    
    override func layoutSubviews() {
        let xMargin : CGFloat = 20
        
        backgroundView?.frame = CGRect(x: 0, y: 0, width: screenWidth - 2 * xMargin, height: screenHeight / 6)
        backgroundView?.backgroundColor = UIColor.clear
        
        // Content View
        
        contentView.frame = CGRect(x: 0, y: 0, width: screenWidth - 2 * xMargin, height: screenHeight / 6)
        
        titleLabel.frame = CGRect(x: 10, y: 10, width: contentView.frame.width - 20, height: contentView.frame.height / 2 - 20)
        titleLabel.text = title
        contentView.addSubview(titleLabel)
        
        creatorLabel.frame = CGRect(x: 10, y: contentView.frame.height - 10, width: contentView.frame.width / 2 - 20, height: contentView.frame.height / 4 - 20)
        creatorLabel.text = creator
        contentView.addSubview(creatorLabel)
        
        mediaImageView.frame = CGRect(x: contentView.frame.width / 2 + 10, y: 10, width: contentView.frame.width / 2 - 20, height: contentView.frame.height - 20)
        contentView.addSubview(mediaImageView)
    }
}

class ExerciseCollectionViewCell : UICollectionViewCell {
    
}
