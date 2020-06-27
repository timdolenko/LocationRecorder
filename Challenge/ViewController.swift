//
//  ViewController.swift
//  Challenge
//
//  Created by Tymofii Dolenko on 27.06.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let recordManager = NNNRecordManager()
    
    private static var reuseIdentifier = "identifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        recordManager.delegate = self
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        recordManager.start()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.reuseIdentifier)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension ViewController: NNNRecordManagerDelegate {
    func recordManagerDidAddNewRecord() {
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(recordManager.records.count)
        return recordManager.records.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.reuseIdentifier)
            else { return .init() }
        
        guard let record = recordManager.records[indexPath.row] as? NNNRecord
            else { return .init()}
        
        cell.textLabel?.text = record.description()
        
        return cell
    }
}
