//
//  QuestionsViewController.swift
//  Sneni
//
//  Created by Daman on 02/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
typealias QuestionsSelectedBlock = ([Question]) -> ()
typealias BoolBlock = (Bool) -> ()

class QuestionsViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet var lblQuestion: ThemeLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var btnBack: ThemeButton!
    @IBOutlet var btnPrevious: ThemeButton!
    @IBOutlet var btnNext: ThemeButton!
    
    var questions: [Question] = []
    var categoryId: String?
    //Question index for which the screen is showing options
    var currentIndex = 0
    private var currnetQuestion: Question {
        return questions[currentIndex]
    }
    var completionBlock: QuestionsSelectedBlock?
    private var completed = false
    var poppedBlock: BoolBlock?
    var totalServiceCharge: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if completed {
            poppedBlock?(true)
        }
        else {
            poppedBlock?(false)
        }
    }
    
    func setupView() {

        tableView.tableFooterView = UIView()
        //Iterate same screen for diffQuestions
        if questions.isEmpty {
            btnPrevious.isHidden = true
            guard let catId = categoryId else { return }
            getQuestions(categoryId: catId)
        }
        else {
            configureTable()
            updateUI()
        }

    }
    
    func updateUI() {
         
        labelTitle.text = "\(currentIndex+1)/\(questions.count)"
        lblQuestion.text = currnetQuestion.question
        if currentIndex == questions.count - 1 {
            //Continue
            btnNext.setTitle("Done".localized(), for: .normal)
            btnBack.isHidden = true
        }
        if currentIndex == 0 {
            btnPrevious.isHidden = true
            btnBack.isHidden = false
        }
    }
    
    func configureTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
    }
    
    
    func getQuestions(categoryId: String)  {
        
        let objR = API.getQuestions(categoryId: categoryId)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case APIResponse.Success(let object):
                guard let objModel = object as? QuestionList else { return }
                self.questions = objModel.questionList ?? []
                if !self.questions.isEmpty {
                    self.configureTable()
                    self.updateUI()
                }
                break
            default :
                break
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        popVC()
    }
    
    @IBAction func next(_ sender: Any) {
        if currnetQuestion.optionsList?.firstIndex(where: { $0.isSelected }) == nil { return }

        if currentIndex == questions.count - 1 {
            var selectedQuestions: [Question] = []
            for question in questions {
                let answers = question.optionsList?.filter({$0.isSelected})
                question.optionsList = answers
                selectedQuestions.append(question)
            }
            let vcs = self.navigationController?.viewControllers ?? []
            if let firstIndex = vcs.firstIndex(where: {$0 is QuestionsViewController}){
                let firstQuesVC = vcs[firstIndex] as! QuestionsViewController
                firstQuesVC.completionBlock?(selectedQuestions)
                self.completed = true
                self.navigationController?.popToViewController(vcs[firstIndex - 1], animated: true)
            }
            //Continue
        }
        else {
            let vc = QuestionsViewController.getVC(.options)
            vc.questions = questions
            vc.currentIndex = currentIndex + 1
            vc.poppedBlock = poppedBlock
            vc.totalServiceCharge = totalServiceCharge
            pushVC(vc)
        }
    }
    
}

extension QuestionsViewController : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currnetQuestion.optionsList?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.QuestionCell) as? QuestionCell
        cell?.selectionStyle = .none
        cell?.configureCell(currnetQuestion.optionsList![indexPath.row], multiSelect: currnetQuestion.isMultiselect, productPrice: totalServiceCharge)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = currnetQuestion.optionsList![indexPath.row]
        if currnetQuestion.isMultiselect {
            let selected = currnetQuestion.optionsList!.first(where: {$0.isSelected && $0.questionOptionId == option.questionOptionId})
            if selected != nil {
                selected!.isSelected = false
            }
            else {
                option.isSelected = true
            }
        }
        else {
            currnetQuestion.optionsList!.forEach { $0.isSelected = false }
            option.isSelected = true
        }

        tableView.reloadData()
    }

}
