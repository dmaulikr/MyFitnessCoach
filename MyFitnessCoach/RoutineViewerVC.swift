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
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseTableCell") as! ExerciseTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        
    }
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return includedExercises?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseCollectionCell", for: indexPath) as! ExerciseCollectionViewCell
        return cell
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
            } else {
                title = "Unnamed exercise"
            }
            
            if let creatorTitle = exerciseDic?["creatorName"] as? String, creatorTitle != "" {
                creator = creatorTitle
            } else {
                creator = "System"
            }
        }
    }
    var mediaDic : [String : AnyObject]? {
        didSet {
            if let image = mediaDic?["image"] as? UIImage {
                mediaImageView.image = image
            } else {
                mediaImageView.image = UIImage(named: "defaultExerciseImage")
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
    
    var exerciseDic : [String : AnyObject]? {
        didSet {
            if let exerciseTitle = exerciseDic?["title"] as? String {
                title = exerciseTitle
            } else {
                title = "Unnamed exercise"
            }
            
            if let creatorTitle = exerciseDic?["creatorName"] as? String, creatorTitle != "" {
                creator = creatorTitle
            } else {
                creator = "System"
            }
            
            if let progressData = exerciseDic?["progressData"] as? [String : AnyObject] {
                progressInfo = progressData
            }
            
        }
    }
    var mediaDic : [String : AnyObject]? {
        didSet {
            if let image = mediaDic?["image"] as? UIImage {
                mediaImageView.image = image
            } else {
                mediaImageView.image = UIImage(named: "defaultExerciseImage")
            }
        }
    }
    
    private var title : String?
    private var creator : String?
    
    // UI Set-Up
    
    private var mediaImageView = UIImageView()
    
    private var progressInfo : [String : AnyObject]?
    
    private lazy var titleLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 22))
    
    private lazy var creatorLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16))
    
    private lazy var moreDetailsLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16), text: "More Details")
    
    private lazy var setsLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16), text: "Sets: ")
    
    private lazy var setsTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.font = UIFont(name: standardFont, size: 16)
        return textField
    }()
    
    private lazy var repsLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16), text: "Reps/Set: ")
    
    private lazy var repsTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.font = UIFont(name: standardFont, size: 16)
        return textField
    }()
    
    private lazy var weightLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16), text: "Weight (lbs): ")
    
    private lazy var weightTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.font = UIFont(name: standardFont, size: 16)
        return textField
    }()
    
    private lazy var benchmarkButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(benchmarkAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var progressButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(viewProgressAction), for: .touchUpInside)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let xMargin : CGFloat = 10
        var y : CGFloat = 10
        
        contentView.frame = CGRect(x: 0, y: 0, width: screenWidth - 2 * xMargin, height: screenHeight / 5)
        
        // Title Label
        titleLabel.frame = CGRect(x: xMargin, y: y, width: (contentView.frame.width / 5) * 4 - 3 * xMargin, height: contentView.frame.height / 6)
        titleLabel.text = title
        contentView.addSubview(titleLabel)
        
        // More Details Label
        
        moreDetailsLabel.frame = CGRect(x: (contentView.frame.width / 5) * 4, y: y, width: (contentView.frame.width / 5) - xMargin, height: contentView.frame.height / 6 )
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(moreDetailsAction))
        moreDetailsLabel.addGestureRecognizer(tapRecognizer)
        contentView.addSubview(moreDetailsLabel)
        
        y = y + titleLabel.frame.height + 10
        
        // Exercise Preview Image
        mediaImageView.frame = CGRect(x: xMargin, y: y, width: (contentView.frame.width / 4), height: contentView.frame.height / 2)
        contentView.addSubview(mediaImageView)
        
        // Progress Data
        setsLabel.frame = CGRect(x: mediaImageView.frame.width + 2 * xMargin, y: y, width: contentView.frame.width / 4, height: mediaImageView.frame.height / 6)
        contentView.addSubview(setsLabel)
        
        setsTextField.frame = CGRect(x: setsLabel.frame.maxX + xMargin, y: y, width: contentView.frame.width / 4, height: setsLabel.frame.height)
        contentView.addSubview(setsTextField)
        
        y = y + (mediaImageView.frame.height / 3)
        
        repsLabel.frame = CGRect(x: mediaImageView.frame.width + 2 * xMargin, y: y, width: contentView.frame.width / 4, height: mediaImageView.frame.height / 6)
        contentView.addSubview(repsLabel)
        
        repsTextField.frame = CGRect(x: repsLabel.frame.maxX + xMargin, y: y, width: contentView.frame.width / 4, height: repsLabel.frame.height)
        contentView.addSubview(repsTextField)
        
        y = y + (mediaImageView.frame.height / 3)
        
        weightLabel.frame = CGRect(x: mediaImageView.frame.width + 2 * xMargin, y: y, width: contentView.frame.width / 4, height: mediaImageView.frame.height / 6)
        contentView.addSubview(weightLabel)
        
        weightTextField.frame = CGRect(x: weightLabel.frame.maxX + xMargin, y: y, width: contentView.frame.width / 4, height: weightLabel.frame.height)
        contentView.addSubview(weightTextField)
        
        y = y + (mediaImageView.frame.height / 3) + 10
        
        // Benchmark and Progress Button
        
        benchmarkButton.backgroundColor = UIColor.green
        progressButton.backgroundColor = UIColor.blue
        
        benchmarkButton.frame = CGRect(x: xMargin, y: y, width: contentView.frame.width / 2 - 2 * xMargin, height: contentView.frame.height / 6)
        contentView.addSubview(benchmarkButton)
        
        progressButton.frame = CGRect(x: xMargin, y: y, width: contentView.frame.width / 2 - 2 * xMargin, height: contentView.frame.height / 6)
        contentView.addSubview(progressButton)
        
        // Creator Label
        creatorLabel.frame = CGRect(x: xMargin, y: (contentView.frame.height) - 10, width: contentView.frame.width - 2 * xMargin, height: (contentView.frame.height / 6))
        creatorLabel.text = "Submitted By: \(creator)"
        contentView.addSubview(creatorLabel)
        
    }
    
    func moreDetailsAction() {
        print("more details tapped")
    }
    
    func benchmarkAction() {
        print("benchmark action")
    }
    
    func viewProgressAction() {
        print("view progress action")
    }
    
}

func createBasicLabel(font : UIFont? = nil, text : String? = nil)-> UILabel {
    let label = UILabel()
    label.font = font
    label.text = text
    return label
}
