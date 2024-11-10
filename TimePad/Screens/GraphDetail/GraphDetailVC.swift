//
//  GraphDetailVC.swift
//  TimePad
//
//  Created by Melik Demiray on 8.11.2024.
//

import UIKit

class GraphDetailVC: UIViewController {

    var viewModel: GraphDetailVMProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }




}

extension GraphDetailVC: GraphDetailVMDelegate {
    func updateCollectionView() {
        // update collection view
    }
}
