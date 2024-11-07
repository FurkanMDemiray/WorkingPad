//
//  GraphsVC.swift
//  TimePad
//
//  Created by Melik Demiray on 6.11.2024.
//

import UIKit

final class GraphsVC: UIViewController {

    @IBOutlet weak var heightConstraintCollectionView: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: GraphsVMProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        viewModel.didFetchWorkModels()
        createPieChart()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //updateCollectionViewHeight()
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(UINib(nibName: Constants.graphCell, bundle: nil), forCellWithReuseIdentifier: Constants.graphCell)
    }

    private func updateCollectionViewHeight() {
        heightConstraintCollectionView.constant = collectionView.contentSize.height
    }

    private func createPieChart() {
        view.addSubview(PieChartView())
    }

}

extension GraphsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.graphCell, for: indexPath) as! GraphCell
        cell.configureCell(image: UIImage(named: viewModel.getCellImages[indexPath.row])!, title: viewModel.getCellTitles[indexPath.row], times: viewModel.getSumsOfTimes, totalDuration: viewModel.getTotalDuration, completedTasks: viewModel.getSumOfCompletedTasks)
        return cell
    }
}

extension GraphsVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = 8 // Hücreler arası boşluk
        let numberOfItemsPerRow: CGFloat = 2
        let width = (collectionView.bounds.width - CGFloat(totalSpacing)) / numberOfItemsPerRow
        //let height = collectionView.bounds.height / 3 // Yüksekliği sabit bırakabilirsiniz.
        return CGSize(width: width, height: 120)
    }

    // Hücreler arasındaki yatay ve dikey boşlukları sıfır yaparak tam ekran kaplamasını sağlamak
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension GraphsVC: GraphsVMDelegate {
}
