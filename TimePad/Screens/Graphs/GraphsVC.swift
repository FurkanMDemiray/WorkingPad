//
//  GraphsVC.swift
//  TimePad
//
//  Created by Melik Demiray on 6.11.2024.
//

import UIKit

//MARK: - GraphsVC
final class GraphsVC: UIViewController {

  @IBOutlet private weak var emptyView: UIView!
  @IBOutlet private weak var heightConstraintCollectionView: NSLayoutConstraint!
  @IBOutlet private weak var collectionView: UICollectionView!

  var viewModel: GraphsVMProtocol! {
    didSet {
      viewModel.delegate = self
    }
  }

  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    // Show tutorial if it hasn't been shown before
    if !UserDefaults.standard.bool(forKey: "HasSeenGraphsTutorial") {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        self?.showTutorial()
      }
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.didFetchWorkModels()

  }

  //MARK: - Private Methods
  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.isScrollEnabled = false
    collectionView.register(
      UINib(nibName: Constants.graphCell, bundle: nil),
      forCellWithReuseIdentifier: Constants.graphCell)
  }

  private func navigateToGraphDetailVC(indexPath: IndexPath) {
    let vc = GraphDetailVC()
    let viewModel = GraphDetailVM()
    let selectedType = getSelectedType(for: indexPath.row)
    viewModel.selectedType = selectedType
    vc.viewModel = viewModel
    self.navigationController?.pushViewController(vc, animated: true)
  }

  private func getSelectedType(for index: Int) -> String? {
    switch index {
    case 0: return Constants.coding
    case 1: return Constants.reading
    case 2: return Constants.work
    case 3: return Constants.workout
    case 4: return Constants.all  // For Completed cell
    case 5: return Constants.totalTime  // For Total Time cell
    default: return nil
    }
  }

  func showTutorial() {
    let tutorialView = TutorialView(frame: view.bounds)
    view.addSubview(tutorialView)

    // Define tutorial steps
    let steps: [(title: String, description: String, frame: CGRect)] = [
      (
        title: "Activity Cards",
        description:
          "These cards show your progress in different activities like coding, reading, working, and training.",
        frame: collectionView.frame
      ),
      (
        title: "Pie Chart",
        description:
          "When you start to add activities, pie chart will visualize the distribution of your time across different activities.",
        frame: view.subviews.first(where: { $0 is PieChartView })?.frame ?? .zero
      ),
      (
        title: "Detailed Statistics",
        description:
          "Tap any card to see detailed statistics and graphs for that specific activity.",
        frame: collectionView.frame
      ),
    ]

    tutorialView.startTutorial(steps: steps) {
      // Save that tutorial has been shown
      UserDefaults.standard.set(true, forKey: "HasSeenGraphsTutorial")
    }
  }
}

//MARK: - CollectionView Delegate and DataSource
extension GraphsVC: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int
  {
    return 6
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    let cell =
      collectionView.dequeueReusableCell(withReuseIdentifier: Constants.graphCell, for: indexPath)
      as! GraphCell
    cell.configureCell(
      image: UIImage(named: viewModel.getCellImages[indexPath.row])!,
      title: viewModel.getCellTitles[indexPath.row], times: viewModel.getSumsOfTimes,
      totalDuration: viewModel.getTotalDuration, completedTasks: viewModel.getSumOfCompletedTasks)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    navigateToGraphDetailVC(indexPath: indexPath)
  }
}

//MARK: - CollectionView FlowLayout
extension GraphsVC: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 8
  }

  func collectionView(
    _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let totalSpacing = 8  // Space between cells
    let numberOfItemsPerRow: CGFloat = 2
    let width = (collectionView.bounds.width - CGFloat(totalSpacing)) / numberOfItemsPerRow
    //let height = collectionView.bounds.height / 3 // You can keep the height fixed
    return CGSize(width: width, height: 120)
  }

  // Set horizontal and vertical spacing between cells to zero to make it full screen
  func collectionView(
    _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }

}

//MARK: - ViewModel Delegate
extension GraphsVC: GraphsVMDelegate {
  func showNoDataLabel() {
    emptyView.isHidden = false
  }

  func hideNoDataLabel() {
    emptyView.isHidden = true
  }

  func updateCollectionView() {
    collectionView.reloadData()
  }

  func createPieChart(with segment: [PieChartView.Segment]) {
    if self.view.subviews.contains(where: { $0 is PieChartView }) {
      self.view.subviews.forEach { if $0 is PieChartView { $0.removeFromSuperview() } }
    }

    let chartView = UIView()
    chartView.translatesAutoresizingMaskIntoConstraints = false
    chartView.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)
    self.view.addSubview(chartView)

    let screenHeight = UIScreen.main.bounds.height
    var height: CGFloat
    switch screenHeight {
    case ...667:  // iPhone SE, iPhone 8 and smaller
      height = 150
    case 668...844:  // iPhone X/XS/11 Pro/12 mini/13 mini
      height = 200
    case 845...926:  // iPhone XR/XS Max/11/11 Pro Max/12/12 Pro/13/13 Pro/15/16
      height = 275
    case 927...932:  // iPhone 12 Pro Max/13 Pro Max/15 Pro/16 Pro
      height = 275
    default:  // Larger devices
      height = 300
    }

    // Set up Auto Layout constraints
    NSLayoutConstraint.activate([
      chartView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
      chartView.heightAnchor.constraint(equalToConstant: height),
      chartView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      chartView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 4),
      chartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
      chartView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
    ])

    let pieChartView = PieChartView()
    pieChartView.translatesAutoresizingMaskIntoConstraints = false
    chartView.addSubview(pieChartView)
    pieChartView.configure(segments: segment)

    //Set up Auto Layout constraints
    NSLayoutConstraint.activate([
      pieChartView.widthAnchor.constraint(equalToConstant: height),
      pieChartView.heightAnchor.constraint(equalToConstant: height),
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
      label.leadingAnchor.constraint(equalTo: pieChartView.trailingAnchor, constant: 8),
    ])
  }

  func createMutableString() -> NSMutableAttributedString {
    let text = NSMutableAttributedString()

    let redText = NSAttributedString(
      string: "Red: Coding\n",
      attributes: [.foregroundColor: UIColor.hexStringToUIColor(hex: Colors.red)])
    text.append(redText)

    let greenText = NSAttributedString(
      string: "Green: Reading\n",
      attributes: [.foregroundColor: UIColor.hexStringToUIColor(hex: Colors.green)])
    text.append(greenText)

    let purpleText = NSAttributedString(
      string: "Purple: Working\n",
      attributes: [.foregroundColor: UIColor.hexStringToUIColor(hex: Colors.purple)])
    text.append(purpleText)

    let orangeText = NSAttributedString(
      string: "Orange: Training\n\n\n",
      attributes: [.foregroundColor: UIColor.hexStringToUIColor(hex: Colors.orange)])
    text.append(orangeText)

    let informationText = NSAttributedString(
      string: "For more detail\nclick any card.", attributes: [.foregroundColor: UIColor.white])
    text.append(informationText)

    return text
  }

}
