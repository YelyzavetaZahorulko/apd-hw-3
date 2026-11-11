import UIKit
import SnapKit

final class StudentDetailViewController: UIViewController {

    private let student: Student
    private let store: StudentStore

    init(student: Student, store: StudentStore) {
        self.student = student
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = student.name
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "studentDetails"

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        let nameLabel = UILabel()
        nameLabel.text = "Name: \(student.name)"

        let ageLabel = UILabel()
        ageLabel.text = "Age: \(student.age)"

        let gradeLabel = UILabel()
        gradeLabel.text = String(
            format: "Average grade: %.2f",
            student.averageGrade
        )

        let scholarshipLabel = UILabel()
        scholarshipLabel.text = "Scholarship: " +
            (student.isScholarshipHolder ? "Yes" : "No")

        let subjectsTitle = UILabel()
        subjectsTitle.text = "Subjects:"
        subjectsTitle.font = .boldSystemFont(ofSize: 18)

        let subjectsStack = UIStackView()
        subjectsStack.axis = .vertical
        subjectsStack.spacing = 10

        for subject in student.subjects {
            let button = UIButton(type: .system)
            button.setTitle(subject, for: .normal)
            button.contentHorizontalAlignment = .leading
            button.accessibilityIdentifier = "subjectButton.\(subject)"

            button.addAction(UIAction { [weak self] _ in
                guard let self = self else { return }

                let filteredVC = StudentListViewController(
                    store: self.store,
                    subject: subject
                )

                self.navigationController?.pushViewController(
                    filteredVC,
                    animated: true
                )
            }, for: .touchUpInside)

            subjectsStack.addArrangedSubview(button)
        }

        let avatarView = UIImageView()
        avatarView.image = UIImage(named: student.avatarName)
        avatarView.contentMode = .scaleAspectFit

        avatarView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }

        [
            avatarView,
            nameLabel,
            ageLabel,
            gradeLabel,
            scholarshipLabel,
            subjectsTitle,
            subjectsStack
        ].forEach { stackView.addArrangedSubview($0) }
    }
}
