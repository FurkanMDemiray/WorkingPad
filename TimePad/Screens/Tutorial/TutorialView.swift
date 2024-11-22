import UIKit

final class TutorialView: UIView {

  private let cardView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.fillColor).withAlphaComponent(
      0.9)
    view.layer.cornerRadius = 16
    view.layer.borderWidth = 2
    view.layer.borderColor = UIColor.black.cgColor
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 20, weight: .bold)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("Next", for: .normal)
    button.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.red)
    button.layer.cornerRadius = 12
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private var currentStep = 0
  private var tutorialSteps: [(title: String, description: String, frame: CGRect)] = []
  private var completion: (() -> Void)?

  private var cardConstraints: [NSLayoutConstraint] = []

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    backgroundColor = UIColor.black.withAlphaComponent(0.7)

    addSubview(cardView)
    cardView.addSubview(titleLabel)
    cardView.addSubview(descriptionLabel)
    cardView.addSubview(nextButton)

    NSLayoutConstraint.activate([
      cardView.widthAnchor.constraint(equalToConstant: 300),
      cardView.heightAnchor.constraint(equalToConstant: 200),

      titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

      nextButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
      nextButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
      nextButton.widthAnchor.constraint(equalToConstant: 120),
      nextButton.heightAnchor.constraint(equalToConstant: 44),
    ])

    nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
  }

  func startTutorial(
    steps: [(title: String, description: String, frame: CGRect)], completion: @escaping () -> Void
  ) {
    self.tutorialSteps = steps
    self.completion = completion
    showStep(at: 0)
  }

  private func showStep(at index: Int) {
    guard index < tutorialSteps.count else {
      completion?()
      removeFromSuperview()
      return
    }

    let step = tutorialSteps[index]
    titleLabel.text = step.title
    descriptionLabel.text = step.description

    // Remove previous constraints
    NSLayoutConstraint.deactivate(cardConstraints)
    cardConstraints.removeAll()

    // Calculate the best position for the card
    let targetFrame = step.frame
    let cardHeight: CGFloat = 200
    let defaultSpacing: CGFloat = 20

    // Use larger spacing for pie chart (assuming it's the second step)
    let spacing: CGFloat = (index == 1) ? 60 : defaultSpacing

    // Check if there's room below the target frame
    let spaceBelow = bounds.height - targetFrame.maxY - spacing - cardHeight
    let spaceAbove = targetFrame.minY - spacing - cardHeight

    if spaceBelow >= 0 {
      // Position below
      cardConstraints = [
        cardView.topAnchor.constraint(equalTo: topAnchor, constant: targetFrame.maxY + spacing),
        cardView.centerXAnchor.constraint(equalTo: centerXAnchor),
      ]
    } else if spaceAbove >= 0 {
      // Position above
      cardConstraints = [
        cardView.bottomAnchor.constraint(equalTo: topAnchor, constant: targetFrame.minY - spacing),
        cardView.centerXAnchor.constraint(equalTo: centerXAnchor),
      ]
    } else {
      // Position in center of screen
      cardConstraints = [
        cardView.centerYAnchor.constraint(equalTo: centerYAnchor),
        cardView.centerXAnchor.constraint(equalTo: centerXAnchor),
      ]
    }

    // Ensure card stays within screen bounds horizontally
    let minX = defaultSpacing
    let maxX = bounds.width - 300 - defaultSpacing  // 300 is card width
    let xPos = min(max(targetFrame.midX - 150, minX), maxX)
    cardConstraints.append(
      cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xPos))

    NSLayoutConstraint.activate(cardConstraints)

    // Animate the change
    UIView.animate(withDuration: 0.3) {
      self.layoutIfNeeded()
    }

    nextButton.setTitle(index == tutorialSteps.count - 1 ? "Finish" : "Next", for: .normal)
  }

  @objc private func nextButtonTapped() {
    currentStep += 1
    showStep(at: currentStep)
  }
}
