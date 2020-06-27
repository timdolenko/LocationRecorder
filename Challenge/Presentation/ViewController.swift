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
    
    private static var reuseIdentifier = "identifier"

    private var sceneDelegate: SceneDelegate {
        view.window!.windowScene!.delegate as! SceneDelegate
    }
    private var recordManager: NNNRecordManager {
        sceneDelegate.recordManager
    }
    private var records: [NNNRecord] {
        recordManager.records as? [NNNRecord] ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recordManager.delegate = self
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
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.tableView.reloadData()
            let indexPath = IndexPath(
                row: self.tableView.numberOfRows(inSection: 0) - 1,
                section: 0
            )
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.reuseIdentifier),
            indexPath.row < records.count - 1
            else { return .init() }
        
        cell.textLabel?.text = records[indexPath.row].description()
        
        return cell
    }
}
