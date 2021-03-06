//
//  RoutineViewerVC.swift
//  MyFitnessCoach
//
//  Created by Andrew Meng on 2017-03-25.
//  Copyright © 2017 Andrew Meng. All rights reserved.
//

import UIKit

final class RoutineViewerVC : UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var routine : Routine? {
        didSet {
            includedExercises = routine?.exercisesIncluded
            routineNameLabel.text = routine?.title
            creatorNameLabel.text = routine?.creatorName
        }
    }
    
    private var tableViewOn : Bool = true
    
    private var includedExercises : [Exercise]?
    
    private var exerciseTableView : UITableView?
    
    private var exerciseCollectionView : UICollectionView?
    
    private lazy var routineNameHeader : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16), text: "Routine Name: ")
    
    private lazy var routineNameLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16))
    
    private lazy var creatorNameHeader : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16), text: "Creator Name: ")
    
    private lazy var creatorNameLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16))

    private lazy var muscleGroupsLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16), text: "Muscle Groups: ")
    
    // Add in grouping boxes and adding function here (the view)
    
    private lazy var exercisesHeader : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 22), text: "Exercises Included: ")
    
    private lazy var detailsSwitch : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16), text: "Details Off")
    
    private lazy var deleteModeSwitch : UISwitch = {
        let switchToggle = UISwitch()
        switchToggle.isUserInteractionEnabled = true
        switchToggle.isOn = false
        return switchToggle
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.topViewController?.title = routine?.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let xMargin : CGFloat = 10
        var y : CGFloat = 30
        
        if let navigationBarHeight = self.navigationController?.navigationBar.frame.height {
            y = y + navigationBarHeight
        }
        
        view.backgroundColor = UIColor.white
        
        // Routine and Creator Label and Names
        
        routineNameHeader.frame = CGRect(x: xMargin, y: y, width: screenWidth / 2 - 3 * xMargin, height: 24)
        view.addSubview(routineNameHeader)
        
        creatorNameHeader.frame = CGRect(x: routineNameHeader.frame.maxX + xMargin, y: y, width: screenWidth / 2 - 3 * xMargin, height: 24)
        view.addSubview(creatorNameHeader)
        
        y = y + routineNameHeader.frame.height + 10
        
        routineNameLabel.frame = CGRect(x: xMargin, y: y, width: screenWidth / 2 - 3 * xMargin, height: 24)
        view.addSubview(routineNameLabel)
        
        creatorNameLabel.frame = CGRect(x: creatorNameHeader.frame.minX + xMargin, y: y, width: screenWidth / 2 - 3 * xMargin, height: 24)
        view.addSubview(creatorNameLabel)
        
        y = y + routineNameLabel.frame.height + 10
        
        // Muscle Groups
        
        muscleGroupsLabel.frame = CGRect(x: xMargin, y: y, width: screenWidth - 2 * xMargin, height: 24)
        view.addSubview(muscleGroupsLabel)
        
        y = y + muscleGroupsLabel.frame.height + 10
        
        // add muscle group boxes
        
        // Exercises
        
        exercisesHeader.frame = CGRect(x: xMargin, y: y, width: 2 * (screenWidth / 3) - 2 * xMargin, height: 24)
        view.addSubview(exercisesHeader)
        
        detailsSwitch.frame = CGRect(x: exercisesHeader.frame.width + 2 * xMargin, y: y, width: screenWidth / 3 - 2 * xMargin, height: 24)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleExerciseView))
        detailsSwitch.addGestureRecognizer(tapRecognizer)
        detailsSwitch.isUserInteractionEnabled = true
        view.addSubview(detailsSwitch)
        
        y = y + exercisesHeader.frame.height + 10
        
        // TableView/CollectionView Container View
        let exercisesContainerView : UIView = UIView(frame: CGRect(x: xMargin, y: y, width: screenWidth - 2 * xMargin, height: 5 * (screenHeight / 8) - 20))
        
        let containerOptionsTab = UIView(frame: CGRect(x: 0, y: 0, width: exercisesContainerView.frame.width, height: 35))
        
        // Delete and Adding Actions
        let deleteModeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        deleteModeLabel.text = "Delete"
        containerOptionsTab.addSubview(deleteModeLabel)
        
        deleteModeSwitch.frame = CGRect(x: 2 * xMargin + deleteModeLabel.frame.width, y: 0, width: 15, height: 10)
        containerOptionsTab.addSubview(deleteModeSwitch)
        
        exercisesContainerView.addSubview(containerOptionsTab)
        
        exerciseTableView = UITableView(frame: CGRect(x: 0, y: containerOptionsTab.frame.height, width: exercisesContainerView.frame.width, height: exercisesContainerView.frame.height - containerOptionsTab.frame.height))
        
        exerciseTableView?.delegate = self
        exerciseTableView?.dataSource = self
        
        exercisesContainerView.addSubview(exerciseTableView!)
        
        let exerciseFlowLayout = UICollectionViewFlowLayout()
        exerciseFlowLayout.scrollDirection = .vertical
        exerciseFlowLayout.itemSize = CGSize(width: screenWidth - 20, height: screenHeight / 5)
        
        exerciseCollectionView = UICollectionView(frame: CGRect(x: 0, y: containerOptionsTab.frame.height, width: exercisesContainerView.frame.width, height: exercisesContainerView.frame.height - containerOptionsTab.frame.height), collectionViewLayout: exerciseFlowLayout)

        exerciseCollectionView?.isHidden = tableViewOn
        exerciseCollectionView?.backgroundColor = UIColor.white
        
        exercisesContainerView.addSubview(exerciseCollectionView!)
        exerciseCollectionView?.delegate = self
        exerciseCollectionView?.dataSource = self
        
        view.addSubview(exercisesContainerView)
        
        exerciseTableView?.register(ExerciseTableViewCell.self, forCellReuseIdentifier: "exerciseTableCell")
        exerciseCollectionView?.register(ExerciseCollectionViewCell.self, forCellWithReuseIdentifier: "exerciseCollectionCell")
        
    }
    
    func addMuscleGroup() {
        print("Called addMuscleGroup")
    }
    
    func toggleExerciseView() {
        print("toggled")
        tableViewOn = !tableViewOn
        exerciseTableView?.isHidden = !tableViewOn
        exerciseCollectionView?.isHidden = tableViewOn
        if tableViewOn {
            detailsSwitch.text = "Details Off"
        } else {
            detailsSwitch.text = "Details On"
        }
    }
    
    func deleteExerciseAction() {
        print("deleted")
    }
    
    // MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return includedExercises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseTableCell") as! ExerciseTableViewCell
        cell.exerciseInfo = includedExercises?[indexPath.row]
        //cell.mediaInfo = includedExercises?[indexPath.row].media
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        if deleteModeSwitch.isOn {
            print("Deleted")
        } else {
            print("else")
        }
    }
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return includedExercises?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseCollectionCell", for: indexPath) as! ExerciseCollectionViewCell
        cell.exerciseInfo = includedExercises?[indexPath.row]
        //cell.mediaInfo = includedExercises?[indexPath.row].media
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if deleteModeSwitch.isOn {
            print("Deleted")
        } else {
            print("else")
        }
    }
    
    // MARK : Collection View Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath)->CGSize {
        return CGSize(width: screenWidth - 20, height: screenHeight / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 250
    }
    
    
}

class ExerciseTableViewCell : UITableViewCell {
    
    var exerciseInfo : Exercise? {
        didSet {
            title = exerciseInfo?.title
            creator = exerciseInfo?.creatorName
        }
    }
    
    var mediaInfo : MediaData? {
        didSet {
            mediaImageView.image = mediaInfo?.photo
        }
    }
    
    private var title : String?
    private var creator : String?
    private var mediaImageView = UIImageView()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: standardFont, size: 18)
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
        backgroundView?.backgroundColor = UIColor.white
        
        // Content View
        contentView.frame = CGRect(x: 0, y: 0, width: screenWidth - 2 * xMargin, height: screenHeight / 6)
        
        titleLabel.frame = CGRect(x: 10, y: 10, width: contentView.frame.width - 20, height: contentView.frame.height / 2 - 20)
        titleLabel.text = title!
        contentView.addSubview(titleLabel)
        
        creatorLabel.frame = CGRect(x: 10, y: contentView.frame.height - 40, width: contentView.frame.width / 2 - 20, height: contentView.frame.height / 2 - 20)
        creatorLabel.text = creator!
        contentView.addSubview(creatorLabel)
        
        mediaImageView.frame = CGRect(x: contentView.frame.width / 2 + 40, y: 10, width: contentView.frame.width / 2 - 60, height: contentView.frame.height - 20)
        mediaImageView.backgroundColor = UIColor.black
        contentView.addSubview(mediaImageView)
    }
}

class ExerciseCollectionViewCell : UICollectionViewCell, UITextFieldDelegate {
    
    var exerciseInfo : Exercise? {
        didSet {
            title = exerciseInfo?.title
            creator = exerciseInfo?.creatorName
            progressInfo = exerciseInfo?.progressData
        }
    }
    var mediaInfo : MediaData? {
        didSet {
            mediaImageView.image = mediaInfo?.photo
        }
    }
    
    private var title : String?
    private var creator : String?
    
    // UI Set-Up
    
    private var mediaImageView = UIImageView()
    
    private var progressInfo : [ProgressDataEntry]?
    
    private lazy var titleLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 22))
    
    private lazy var creatorLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16))
    
    private lazy var moreDetailsLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 16), text: "More Details")
    
    private lazy var setsLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 14), text: "Sets: ")
    
    private lazy var setsTextField : UITextField = {
        let textField = UITextField()
        textField.text = "0"
        textField.font = UIFont(name: standardFont, size: 14)
        return textField
    }()
    
    private lazy var repsLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 14), text: "Reps/Set: ")
    
    private lazy var repsTextField : UITextField = {
        let textField = UITextField()
        textField.text = "0"
        textField.font = UIFont(name: standardFont, size: 14)
        return textField
    }()
    
    private lazy var weightLabel : UILabel = createBasicLabel(font: UIFont(name: standardFont, size: 14), text: "Weight (lbs): ")
    
    private lazy var weightTextField : UITextField = {
        let textField = UITextField()
        textField.text = "0"
        textField.font = UIFont(name: standardFont, size: 14)
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
        
        moreDetailsLabel.frame = CGRect(x: (contentView.frame.width / 5) * 3, y: y, width: (contentView.frame.width / 5) - xMargin, height: contentView.frame.height / 6 )
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(moreDetailsAction))
        moreDetailsLabel.addGestureRecognizer(tapRecognizer)
        contentView.addSubview(moreDetailsLabel)
        
        y = y + titleLabel.frame.height + 20
        
        // Exercise Preview Image
        mediaImageView.frame = CGRect(x: xMargin, y: y, width: (contentView.frame.width / 4), height: contentView.frame.height / 2 + 10)
        contentView.addSubview(mediaImageView)
        
        // Progress Data
        setsLabel.frame = CGRect(x: mediaImageView.frame.width * 2 + 5 * xMargin, y: y, width: contentView.frame.width / 4, height: mediaImageView.frame.height / 6)
        contentView.addSubview(setsLabel)
        
        setsTextField.frame = CGRect(x: setsLabel.frame.maxX + xMargin, y: y, width: contentView.frame.width / 4, height: setsLabel.frame.height)
        setsTextField.delegate = self
        contentView.addSubview(setsTextField)
        
        setsTextField.text = String(describing: progressInfo?.last?.sets ?? 0)
        
        y = y + (mediaImageView.frame.height / 3)
        
        repsLabel.frame = CGRect(x: mediaImageView.frame.width * 2 + 5 * xMargin, y: y, width: contentView.frame.width / 4, height: mediaImageView.frame.height / 6)
        repsTextField.delegate = self
        contentView.addSubview(repsLabel)
        
        repsTextField.frame = CGRect(x: repsLabel.frame.maxX + xMargin, y: y, width: contentView.frame.width / 4, height: repsLabel.frame.height)
        contentView.addSubview(repsTextField)
        
        repsTextField.text = String(describing: progressInfo?.last?.reps ?? 0)
        
        y = y + (mediaImageView.frame.height / 3)
        
        weightLabel.frame = CGRect(x: mediaImageView.frame.width * 2 + 5 * xMargin, y: y, width: contentView.frame.width / 4, height: mediaImageView.frame.height / 6)
        contentView.addSubview(weightLabel)
        
        weightTextField.frame = CGRect(x: weightLabel.frame.maxX + xMargin, y: y, width: contentView.frame.width / 4, height: weightLabel.frame.height)
        weightTextField.delegate = self
        contentView.addSubview(weightTextField)
        
        weightTextField.text = String(describing: progressInfo?.last?.weight ?? 0)
        
        y = y + (mediaImageView.frame.height / 3)
        
        // Benchmark and Progress Button
        
        benchmarkButton.backgroundColor = UIColor.green
        progressButton.backgroundColor = UIColor.blue
        
        benchmarkButton.frame = CGRect(x: xMargin, y: y, width: contentView.frame.width / 2 - 2 * xMargin, height: contentView.frame.height / 6)
        contentView.addSubview(benchmarkButton)
        
        progressButton.frame = CGRect(x: benchmarkButton.frame.maxX + xMargin, y: y, width: contentView.frame.width / 2 - 2 * xMargin, height: contentView.frame.height / 6)
        contentView.addSubview(progressButton)
        
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        let textValue = Int(text)
        
        guard textValue != nil else { textField.text = "0"; return }
        
        if textValue! > 999 { textField.text = "999" }
        else if textValue! < 0 { textField.text = "0" }
    }
    
}

func createBasicLabel(font : UIFont? = nil, text : String? = nil)-> UILabel {
    let label = UILabel()
    label.font = font
    label.text = text
    return label
}
