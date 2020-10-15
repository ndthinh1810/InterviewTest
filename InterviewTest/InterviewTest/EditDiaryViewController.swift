//
//  EditDiaryViewController.swift
//  InterviewTest
//
//  Created by Nguyễn Đức Thịnh on 10/13/20.
//  Copyright © 2020 Duc Thinh. All rights reserved.
//

import UIKit
protocol EditDiaryViewControllerDelegate : class {
    func editDiaryViewController(_ controller: EditDiaryViewController, didFinishEditing diary: Diary)
}
class EditDiaryViewController: UIViewController {
    var diaryToEdit : Diary?
    weak var delegate: EditDiaryViewControllerDelegate?
    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var textView: UITextView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if let item = diaryToEdit {
            title = item.title
            textField?.text = item.title
            textView?.text = item.content
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField?.becomeFirstResponder()
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save() {
        if let item = diaryToEdit {
            title = item.title
            textField?.text = item.title
            textView?.text = item.content
            delegate?.editDiaryViewController(self, didFinishEditing: item)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
