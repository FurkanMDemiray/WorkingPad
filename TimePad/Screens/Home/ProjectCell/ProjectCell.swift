//
//  ProjectCell.swift
//  TimePad
//
//  Created by Melik Demiray on 24.09.2024.
//

import UIKit

class ProjectCell: UITableViewCell {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var playImage: UIImageView!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCardView()
        configurePlayImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func configureCardView() {
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 2
    }

    private func configurePlayImage() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(playTapped))
        playImage.isUserInteractionEnabled = true
        playImage.addGestureRecognizer(gesture)
    }

    @objc private func playTapped() {
        print("Play tapped")
    }

    func configure(with model: WorkModel) {
        guard let hour = model.hour, let minute = model.minute else { return }
        titleLabel.text = model.title
        // time format 00:00
        timeLabel.text = "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
        tagLabel.text = model.type
    }

}
