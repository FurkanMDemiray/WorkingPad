//
//  OnboardingVC.swift
//  TimePad
//
//  Created by Melik Demiray on 3.11.2024.
//

import UIKit

final class OnboardingVC: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .systemGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private let getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let slides: [(image: String, title: String)] = [
        ("onboarding1", "Create and Manage Your Tasks"),
        ("onboarding2", "Track Your Progress"),
        ("onboarding3", "Stay Productive with Working Pad")
    ]

    private var slidesViews: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update content size and slide frames after layout
        setupSlideFrames()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.hexStringToUIColor(hex: Colors.background)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(pageControl)
        view.addSubview(getStartedButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50)
            ])

        setupSlides()
        getStartedButton.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
        scrollView.delegate = self
    }

    private func setupSlides() {
        // Remove existing slide views
        slidesViews.forEach { $0.removeFromSuperview() }
        slidesViews.removeAll()

        // Create new slide views
        for (index, slide) in slides.enumerated() {
            let slideView = createSlideView(image: slide.image, title: slide.title)
            contentView.addSubview(slideView)
            slidesViews.append(slideView)

            slideView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                slideView.topAnchor.constraint(equalTo: contentView.topAnchor),
                slideView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
                slideView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
                ])

            if index == 0 {
                slideView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            } else {
                slideView.leadingAnchor.constraint(equalTo: slidesViews[index - 1].trailingAnchor).isActive = true
            }

            if index == slides.count - 1 {
                slideView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            }
        }
    }

    private func setupSlideFrames() {
        contentView.frame.size.width = scrollView.frame.width * CGFloat(slides.count)
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: scrollView.frame.height)
    }

    private func createSlideView(image: String, title: String) -> UIView {
        let slideView = UIView()

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: image)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        slideView.addSubview(imageView)
        slideView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: slideView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: slideView.topAnchor, constant: 50),
            imageView.widthAnchor.constraint(equalTo: slideView.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: slideView.heightAnchor, multiplier: 0.7),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: slideView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: slideView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: slideView.bottomAnchor, constant: -20)
            ])

        return slideView
    }

    @objc private func getStartedTapped() {
        let tabBarVC = TabbarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
}

extension OnboardingVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(page)
    }
}
