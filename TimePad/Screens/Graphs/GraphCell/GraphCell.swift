//
//  GraphCell.swift
//  TimePad
//
//  Created by Melik Demiray on 6.11.2024.
//

import UIKit

final class GraphCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var numberTimeLabel: UILabel!
    @IBOutlet private weak var cardView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        configureCardView()
    }

    private func configureCardView() {
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
    }

    func configureCell(image: UIImage, title: String, times: (coding: String, reading: String, working: String, training: String), totalDuration: String, completedTasks: String) {
        imageView.image = image
        titleLabel.text = title
        switch title {
        case Constants.coding:
            numberTimeLabel.text = times.coding
        case Constants.reading:
            numberTimeLabel.text = times.reading
        case Constants.work:
            numberTimeLabel.text = times.working
        case Constants.workout:
            numberTimeLabel.text = times.training
        case "Total Time":
            numberTimeLabel.text = totalDuration
        case "Completed":
            numberTimeLabel.text = completedTasks
        default:
            break
        }

    }

}
