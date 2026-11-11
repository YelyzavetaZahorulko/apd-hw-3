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
}

