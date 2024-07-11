//
//  CalculationsListViewController.swift
//  TinkoffCalculator
//
//  Created by Полина Голодаевская on 08.07.2024.
//

import UIKit

class CalculationsListViewController: UIViewController {
    var result: String?
    
    @IBOutlet weak var CalculationLabel: UILabel!
    
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
        CalculationLabel.text = result
    }
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}