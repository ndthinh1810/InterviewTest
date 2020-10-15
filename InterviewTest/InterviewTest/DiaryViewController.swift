//
//  ViewController.swift
//  InterviewTest
//
//  Created by Nguyễn Đức Thịnh on 10/7/20.
//  Copyright © 2020 Duc Thinh. All rights reserved.
//

import UIKit

class DiaryViewController: UITableViewController, DiaryTableViewCellDelegate, EditDiaryViewControllerDelegate{
    var diaryIndexSelected: IndexPath?
    struct TableView {
      struct CellIdentifiers {
        static let diaryCell = "DiaryTableViewCell"
      }
    }
    
    var listDiary:[Diary] = []
    var groupedList:[[Diary]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: TableView.CellIdentifiers.diaryCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:TableView.CellIdentifiers.diaryCell)
        tableView.register(MyCustomHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        getListDiary()
    }
   
    
    // MARK: TableView Delegate 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = groupedList[section]
        return section.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        let theCell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.diaryCell,for: indexPath)as! DiaryTableViewCell
        let section = self.groupedList[indexPath.section]
        let diary = section[indexPath.row]
        theCell.delegate = self
        theCell.DiaryLabel.text = diary.title
        theCell.text1.text = diary.content
        return theCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                    "sectionHeader") as! MyCustomHeader
        
        view.title.text = "Apr"
        view.title.textColor = UIColor(red: 0.455, green: 0.475, blue: 0.51, alpha: 1)
        view.image.image = UIImage(named: "Image-3")
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedList.count
    }
    
    func didTapDeleteButtonInCell(_ cell: DiaryTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        diaryIndexSelected = indexPath
        groupedList[diaryIndexSelected?.section ?? 0].remove(at: diaryIndexSelected?.row ?? 0)
        let indexPaths = [diaryIndexSelected]
        tableView.deleteRows(at: indexPaths as! [IndexPath], with: .fade)
    }
    
    func didTapEditButtonInCell(_ cell: DiaryTableViewCell) {
        performSegue(withIdentifier: "EditDiary", sender: cell)
    }
    
    //MARK:- Edit Diary viewcontroller delegate
    func editDiaryViewController(_ controller: EditDiaryViewController, didFinishEditing diary: Diary) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Helper method
       func buildFormatter(locale: Locale, hasRelativeDate: Bool = false, dateFormat: String? = nil) -> DateFormatter {
           let formatter = DateFormatter()
           formatter.timeStyle = .none
           formatter.dateStyle = .medium
           if let dateFormat = dateFormat { formatter.dateFormat = dateFormat }
           formatter.doesRelativeDateFormatting = hasRelativeDate
           formatter.locale = locale
           return formatter
       }
       
       func dateFormatterToString( formatter: DateFormatter,  date: Date) -> String {
              return formatter.string(from: date)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDiary" {
            let controller = segue.destination as? EditDiaryViewController
            controller?.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! DiaryTableViewCell) {
                let section = self.groupedList[indexPath.section]
                let diary = section[indexPath.row]
                controller?.diaryToEdit = diary
            }
        }
    }
       
}

// MARK: Rest API
extension DiaryViewController {
    func getListDiary() {
        MockProjectAPI.shared.getUserAPI().getListDiary { (result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.listDiary.append(contentsOf: result)
                //list at here have data, group successed
                let groupSorted = self.listDiary.groupSort(ascending: false, byDate: {
                    let locale = Locale(identifier: "en_US_POSIX")
                    let formatter = DateFormatter()
                    formatter.locale = locale
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date = formatter.date(from: $0.date!)
                    return date!
                })
                DispatchQueue.main.async {
                    self.groupedList = groupSorted
                    self.tableView.reloadData()
                }
            }
        }
    }
}

