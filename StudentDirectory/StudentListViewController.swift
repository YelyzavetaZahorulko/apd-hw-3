import UIKit
import SnapKit

final class StudentListViewController: UIViewController {

    private let store: StudentStore
    private let subject: String?
    private let tableView = UITableView()

    private var displayedStudents: [Student] {
        if let subject = subject {
            return store.students(matchingSubject: subject)
        }
        return store.students
    }

    init(store: StudentStore, subject: String? = nil) {
        self.store = store
        self.subject = subject
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func setupUI() {
        title = subject ?? "Students"
        if subject == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addStudentTapped)
            )
            navigationItem.rightBarButtonItem?.accessibilityIdentifier = "addStudentButton"
        }
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(
            StudentTableViewCell.self,
            forCellReuseIdentifier: StudentTableViewCell.reuseIdentifier
        )
        
        tableView.accessibilityIdentifier = "studentList"
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    @objc private func addStudentTapped() {
        let alert = UIAlertController(
            title: "Add Student",
            message: "Enter student information",
            preferredStyle: .alert
        )

        alert.addTextField { field in
            field.placeholder = "Name"
        }

        alert.addTextField { field in
            field.placeholder = "Age"
            field.keyboardType = .numberPad
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let name = alert.textFields?[0].text,
                  let ageText = alert.textFields?[1].text,
                  let age = Int(ageText) else {
                return
            }

            do {
                try self.store.addStudent(name: name, age: age)
                self.tableView.reloadData()
            } catch {
                self.showError()
            }
        })

        present(alert, animated: true)
    }

    private func showError() {
        let alert = UIAlertController(
            title: "Invalid Input",
            message: "Please enter a valid name and positive age.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension StudentListViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        displayedStudents.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StudentTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? StudentTableViewCell else {
            return UITableViewCell()
        }

        let student = displayedStudents[indexPath.row]
        cell.configure(with: student)
        return cell
    }
}

extension StudentListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let student = displayedStudents[indexPath.row]

        let detailsVC = StudentDetailViewController(
            student: student,
            store: store
        )

        navigationController?.pushViewController(detailsVC, animated: true)
    }
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        guard subject == nil else { return nil }

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] _, _, completion in

            guard let self = self else {
                completion(false)
                return
            }

            let student = self.displayedStudents[indexPath.row]

            do {
                try self.store.deleteStudent(id: student.id)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
            } catch {
                completion(false)
            }
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

