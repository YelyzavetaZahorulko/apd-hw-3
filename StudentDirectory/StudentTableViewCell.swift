import UIKit
import SnapKit

final class StudentTableViewCell: UITableViewCell {

    static let reuseIdentifier = "StudentTableViewCell"

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let gradeLabel = UILabel()
    private let scholarshipLabel = UILabel()
    private let infoStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        accessoryType = .disclosureIndicator

        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 28

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        ageLabel.font = .preferredFont(forTextStyle: .subheadline)
        gradeLabel.font = .preferredFont(forTextStyle: .subheadline)
        scholarshipLabel.font = .preferredFont(forTextStyle: .caption1)

        [nameLabel, ageLabel, gradeLabel, scholarshipLabel].forEach {
            $0.adjustsFontForContentSizeCategory = true
            $0.numberOfLines = 0
        }

        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.alignment = .fill

        [nameLabel, ageLabel, gradeLabel, scholarshipLabel].forEach {
            infoStack.addArrangedSubview($0)
        }

        contentView.addSubview(avatarImageView)
        contentView.addSubview(infoStack)

        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.greaterThanOrEqualToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56)
        }

        infoStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(12)
        }
    }

    func configure(with student: Student) {
        avatarImageView.image = UIImage(named: student.avatarName)
            ?? UIImage(named: "avatar-default")

        nameLabel.text = student.name
        ageLabel.text = "Age: \(student.age)"
        gradeLabel.text = String(format: "Average grade: %.1f", student.averageGrade)
        scholarshipLabel.text = student.isScholarshipHolder
            ? "Scholarship: Yes"
            : "Scholarship: No"

        scholarshipLabel.textColor = student.isScholarshipHolder
            ? .systemGreen
            : .secondaryLabel

        isAccessibilityElement = true
        accessibilityIdentifier = "studentCell.\(student.id.uuidString)"
        accessibilityLabel = "\(student.name), age \(student.age), average grade \(student.averageGrade), scholarship \(student.isScholarshipHolder ? "yes" : "no")"
        accessibilityTraits = .button
    }
}
