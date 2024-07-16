//
//  CalculationsListViewController.swift
//  TinkoffCalculator
//
//  Created by Полина Голодаевская on 08.07.2024.
//

import UIKit

class CalculationsListViewController: UIViewController {
    
    var calculations: [Calculation] = []
    var groupedCalculations: [String: [Calculation]] = [:]
    var sortedDates: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize(){
        modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.systemGray5
        let tableHeaderView = UIView()
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30)
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        
        groupCalculationsByDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func expressionToString(_ expression: [CalculationHistoryItem]) -> String {
        var result = ""
        for operand in expression{
            switch operand {
            case let .number(value):
                result += String(value) + " "
            case let .operation(value):
                result += value.rawValue + " "
            }
        }
        return result
    }
    
    private func groupCalculationsByDate() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            groupedCalculations = Dictionary(grouping: calculations) { 
                calculation in dateFormatter.string(from: calculation.date)
            }
            
            sortedDates = groupedCalculations.keys.sorted(by: { dateFormatter.date(from: $0)! > dateFormatter.date(from: $1)! })
        }
    }


extension CalculationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}


extension CalculationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateKey = sortedDates[section]
        return groupedCalculations[dateKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedDates[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let dateKey = sortedDates[indexPath.section]
        if let historyItem = groupedCalculations[dateKey]?[indexPath.row] {
            cell.configure(with: expressionToString(historyItem.expression), result: String(historyItem.result))
        }
        return cell
    }
}
