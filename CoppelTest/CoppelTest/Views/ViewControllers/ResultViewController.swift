//
//  ResultViewController.swift
//  CoppelTest
//
//  Created by Javier Morales on 26/10/21.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
    
    @UsesAutoLayout
    var resultLabel = UILabel()
    
    private let segmentendControl: UISegmentedControl = {
        let segmented = UISegmentedControl()
        segmented.insertSegment(withTitle: "Popular", at: 0, animated: true)
        segmented.insertSegment(withTitle: "Top Rated", at: 0, animated: true)
        segmented.insertSegment(withTitle: "On TV", at: 0, animated: true)
        segmented.insertSegment(withTitle: "Arriving Today", at: 0, animated: true)
        segmented.apportionsSegmentWidthsByContent = true
        return segmented
    }()
    
    var viewModel = ResultVCViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        viewModel.reslut.bind { [weak self](loginResult) in
            switch loginResult {
            case .success(let token):
                //self?.resultLabel.text = "Success: \(token)"
            case .fail(let message):
                self?.resultLabel.text = "Failed: \(message)"
            }
        }
        
    }
    
    private func setupView() {
        self.title = "Result"
        view.backgroundColor = UIColor.lightGray
        
        self.view.addSubview(resultLabel)
        self.view.addSubview(segmentendControl)
        
        NSLayoutConstraint.activate([
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        segmentendControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentendControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentendControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentendControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentendControl.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
