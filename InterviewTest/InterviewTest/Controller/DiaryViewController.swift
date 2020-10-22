//
//  ViewController.swift
//  InterviewTest
//
//  Created by Nguyễn Đức Thịnh on 10/7/20.
//  Copyright © 2020 Duc Thinh. All rights reserved.
//

import UIKit
import RealmSwift
class DiaryViewController: UITableViewController, DiaryTableViewCellDelegate, EditDiaryViewControllerDelegate{
    var diaryIndexSelected: IndexPath?
    var diaryEditedIndex: IndexPath?
    struct TableView {
        struct CellIdentifiers {
            static let diaryCell = "DiaryTableViewCell"
        }
    }
    var listDiary : [Diary] = []
    var groupedList : [[Diary]] = []
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: TableView.CellIdentifiers.diaryCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:TableView.CellIdentifiers.diaryCell)
        tableView.register(MyCustomHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        registerDefaults()
        handleFirstTime()
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
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
        let sec = self.groupedList[section][0]
        let locale = Locale(identifier: "en_US_POSIX")
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: sec.date!)
        let customFormatter = buildFormatter(locale: locale, dateFormat: "dd MMMM yyyy")
        let customDateString = dateFormatterToString(formatter: customFormatter, date: date!)
        view.title.text = customDateString
        view.title.textColor = UIColor(red: 0.455, green: 0.475, blue: 0.51, alpha: 1)
        view.image.image = UIImage(named: "Image-3")
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedList.count
    }
    
    func didTapDeleteButtonInCell(_ cell: DiaryTableViewCell) {
        
        let indexPath = tableView.indexPath(for: cell)
        diaryIndexSelected = indexPath
        let sec1 = groupedList[diaryIndexSelected?.section ?? 0]
        let diary = sec1[diaryIndexSelected?.row ?? 0]
        let object = realm.objects(Diary.self).filter("id = %@", diary.id as Any).first
        try! realm.write {
            if let obj = object {
                realm.delete(obj)
            }
        }
        groupedList[diaryIndexSelected?.section ?? 0].remove(at: diaryIndexSelected?.row ?? 0)
        let indexPaths = [diaryIndexSelected]
        tableView.deleteRows(at: indexPaths as! [IndexPath], with: .fade)
        let indexSet = IndexSet(arrayLiteral: diaryIndexSelected!.section)
        let sec = groupedList[diaryIndexSelected?.section ?? 0]
        if sec.count == 0 {
            groupedList.remove(at: diaryIndexSelected?.section ?? 0)
            tableView.deleteSections(indexSet, with: .fade)
        }
        
    }
    
    func didTapEditButtonInCell(_ cell: DiaryTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        diaryEditedIndex = indexPath
        performSegue(withIdentifier: "EditDiary", sender: cell)
    }
    
    //MARK:- Edit Diary viewcontroller delegate
    func editDiaryViewController(_ controller: EditDiaryViewController, didFinishEditing diary: Diary) {
        let cell = tableView.cellForRow(at: diaryEditedIndex!) as! DiaryTableViewCell
        cell.DiaryLabel.text = diary.title
        cell.text1.text = diary.content
        tableView.reloadRows(at: [diaryEditedIndex!], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Helper method
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
    
    func registerDefaults() {
        let dictionary: [String:Any] = ["FirstTime": true ]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            print("1st")
            getListDiary()
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        } else {
            print("2nd")
            let results = realm.objects(Diary.self)
            listDiary = []
            listDiary.append(contentsOf: results)
            let groupSorted = listDiary.groupSort(ascending: false, byDate: {
                let locale = Locale(identifier: "en_US_POSIX")
                let formatter = DateFormatter()
                formatter.locale = locale
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = formatter.date(from: $0.date!)
                return date!
            })
            groupedList = groupSorted
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
                    try! self.realm.write {
                        //self.realm.delete(self.realm.objects(Diary.self))
                        for i in self.listDiary {
                            self.realm.add(i)
                        }
                    }
                    self.groupedList = groupSorted
                    self.tableView.reloadData()
                }
            }
        }
    }
}

