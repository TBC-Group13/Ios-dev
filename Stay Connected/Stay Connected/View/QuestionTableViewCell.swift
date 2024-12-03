//
//  QuestionTableViewCell.swift
//  Stay Connected
//
//  Created by Anna Harris on 03.12.24.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    static let identifier = "QuestionTableViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()

    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .purple
        label.numberOfLines = 1
        return label
    }()

    private let tagTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()

    private let repliesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(tagsLabel)
        containerView.addSubview(tagTitleLabel)
        containerView.addSubview(repliesLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            tagTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            tagTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            tagTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: tagTitleLabel.topAnchor, constant: 16),
           
            tagsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            tagsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),

            repliesLabel.leadingAnchor.constraint(equalTo: tagsLabel.leadingAnchor),
            repliesLabel.trailingAnchor.constraint(equalTo: tagsLabel.trailingAnchor),
            repliesLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 8),
            repliesLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with question: Question, tagTitle: String, repliesCount: Int) {
        titleLabel.text = question.title
        tagsLabel.text = question.tags.joined(separator: ", ")
        tagTitleLabel.text = tagTitle
        repliesLabel.text = "Replies: \(repliesCount)"
    }
}


