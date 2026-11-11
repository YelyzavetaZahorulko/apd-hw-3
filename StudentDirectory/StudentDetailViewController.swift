import UIKit
import SnapKit

final class StudentDetailViewController: UIViewController {

    private var student: Student
    private let store: StudentStore
    
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()

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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editStudentTapped)
        )

        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "editStudentButton"

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

        nameLabel.text = "Name: \(student.name)"
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
    
    @objc private func editStudentTapped() {
        let alert = UIAlertController(
            title: "Edit Student",
            message: "Change name or age",
            preferredStyle: .alert
        )

        alert.addTextField { field in
            field.text = self.student.name
            field.placeholder = "Name"
        }

        alert.addTextField { field in
            field.text = "\(self.student.age)"
            field.placeholder = "Age"
            field.keyboardType = .numberPad
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else { return }

            let name = alert.textFields?.first?.text ?? ""
            let ageText = alert.textFields?.last?.text ?? ""

            guard let age = Int(ageText) else {
                self.showEditError()
                return
            }

            do {
                try self.store.updateStudent(
                    id: self.student.id,
                    name: name,
                    age: age
                )

                self.student.name = name
                self.student.age = age

                self.title = name
                self.nameLabel.text = "Name: \(name)"
                self.ageLabel.text = "Age: \(age)"
            } catch {
                self.showEditError()
            }
        })

        present(alert, animated: true)
    }

    private func showEditError() {
        let alert = UIAlertController(
            title: "Invalid Input",
            message: "Please enter a valid name and positive age.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
