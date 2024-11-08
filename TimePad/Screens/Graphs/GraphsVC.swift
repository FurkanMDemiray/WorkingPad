//
//  GraphsVC.swift
//  TimePad
//
//  Created by Melik Demiray on 6.11.2024.
//

import UIKit

final class GraphsVC: UIViewController {

    @IBOutlet private weak var heightConstraintCollectionView: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!

    var viewModel: GraphsVMProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        viewModel.didFetchWorkModels()
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(UINib(nibName: Constants.graphCell, bundle: nil), forCellWithReuseIdentifier: Constants.graphCell)
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
    func createPieChart(with segment: [PieChartView.Segment]) {
        let chartView = UIView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)
        self.view.addSubview(chartView)

        let screenHeight = UIScreen.main.bounds.height
        var height: CGFloat

        if screenHeight <= 667 {
            height = 150
        } else {
            height = 250
        }

        // Set up Auto Layout constraints
        NSLayoutConstraint.activate([
            chartView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            chartView.heightAnchor.constraint(equalToConstant: height),
            chartView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            chartView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 4),
            chartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8)
            ])

        let pieChartView = PieChartView()
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.addSubview(pieChartView)
        pieChartView.configure(segments: segment)

        //Set up Auto Layout constraints
        NSLayoutConstraint.activate([
            pieChartView.widthAnchor.constraint(equalToConstant: height),
            pieChartView.heightAnchor.constraint(equalToConstant: height)
            ])

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.attributedText = createMutableString()
        chartView.addSubview(label)

        // Set up Auto Layout constraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: pieChartView.trailingAnchor, constant: 8)
            ])
    }

    func createMutableString() -> NSMutableAttributedString {
        let text = NSMutableAttributedString()

        let redText = NSAttributedString(string: "Red: Coding\n", attributes: [.foregroundColor: UIColor.hexStringToUIColor(hex: Colors.red)])
        text.append(redText)

        let greenText = NSAttributedString(string: "Green: Reading\n", attributes: [.foregroundColor: UIColor.hexStringToUIColor(hex: Colors.green)])
        text.append(greenText)

        let purpleText = NSAttributedString(string: "Purple: Working\n", attributes: [.foregroundColor: UIColor.hexStringToUIColor(hex: Colors.purple)])
        text.append(purpleText)

        let orangeText = NSAttributedString(string: "Orange: Training\n\n\n", attributes: [.foregroundColor: UIColor.hexStringToUIColor(hex: Colors.orange)])
        text.append(orangeText)

        let informationText = NSAttributedString(string: "For more information\nclick any graph.", attributes: [.foregroundColor: UIColor.white])
        text.append(informationText)

        return text
    }

}
