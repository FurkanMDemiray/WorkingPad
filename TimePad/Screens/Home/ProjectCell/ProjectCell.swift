//
//  ProjectCell.swift
//  TimePad
//
//  Created by Melik Demiray on 24.09.2024.
//

import UIKit

final class ProjectCell: UITableViewCell {

  @IBOutlet private weak var cardView: UIView!
  @IBOutlet private weak var playImage: UIImageView!
  @IBOutlet private weak var timeLabel: UILabel!
  @IBOutlet private weak var tagLabel: UILabel!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var typeImage: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    configureCardView()
    configurePlayImage()
  }

  private func configureCardView() {
    cardView.layer.cornerRadius = 10
    cardView.clipsToBounds = true
    cardView.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.fillColor)
  }

  private func configurePlayImage() {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(playTapped))
    playImage.isUserInteractionEnabled = true
    playImage.addGestureRecognizer(gesture)
  }

  @objc private func playTapped() {
    print("Play tapped")
  }

  func configure(with model: WorkModel, _ isHistory: Bool = false) {
    guard let hour = model.hour, let minute = model.minute, let seconds = model.seconds,
      let firstHour = model.firstHour, let firstMinute = model.firstMinute
    else { return }
    titleLabel.text = model.title
    if isHistory {
      timeLabel.text =
        "\(String(format: "%02d", firstHour)):\(String(format: "%02d", firstMinute)):\(String(format: "%02d", seconds))"
    } else {
      timeLabel.text =
        "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", seconds))"
    }
    if model.type == "Work" {
      typeImage.image = UIImage(named: "work")
    } else if model.type == "Workout" {
      typeImage.image = UIImage(named: "workout")
    } else if model.type == "Coding" {
      typeImage.image = UIImage(named: "coding")
    } else if model.type == "Reading" {
      typeImage.image = UIImage(named: "reading")
    }
    tagLabel.text = model.type
  }

}
