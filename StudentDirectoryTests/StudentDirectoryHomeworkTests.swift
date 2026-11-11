import XCTest
import UIKit
@testable import StudentDirectory

final class StudentDirectoryHomeworkTests: XCTestCase {

    func testSeedDataHasTenStudents() {
        let store = StudentStore()

        XCTAssertEqual(store.students.count, 10)
    }

    func testStudentNamesAreNotEmpty() {
        let store = StudentStore()

        XCTAssertTrue(
            store.students.allSatisfy {
                !$0.name.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty
            }
        )
    }

    func testSubjectFilteringIsExact() {
        let store = StudentStore()

        guard let subject = store.students
            .flatMap(\.subjects).first else {
            XCTFail("No subjects in seed data")
            return
        }

        let result = store.students(matchingSubject: subject)
        let expected = store.students.filter {
            $0.subjects.contains(subject)
        }

        XCTAssertEqual(result, expected)
    }

    func testAddingStudentIncreasesCount() throws {
        let store = StudentStore()
        let originalCount = store.students.count

        try store.addStudent(name: "Test Student", age: 20)

        XCTAssertEqual(store.students.count, originalCount + 1)
        XCTAssertEqual(store.students.last?.name, "Test Student")
    }

    func testAddingBlankNameFails() {
        let store = StudentStore()
        let originalCount = store.students.count

        XCTAssertThrowsError(
            try store.addStudent(name: "   ", age: 20)
        ) { error in
            XCTAssertEqual(error as? StudentStoreError, .blankName)
        }

        XCTAssertEqual(store.students.count, originalCount)
    }

    func testDeletingUnknownStudentFails() {
        let store = StudentStore()
        let unknownID = UUID()
        let originalStudents = store.students

        XCTAssertThrowsError(
            try store.deleteStudent(id: unknownID)
        ) { error in
            XCTAssertEqual(
                error as? StudentStoreError,
                .unknownID(unknownID)
            )
        }

        XCTAssertEqual(store.students, originalStudents)
    }

    func testStudentCellDisplaysStudentInformation() {
        let student = StudentSeedData.students[0]

        let cell = StudentTableViewCell(
            style: .default,
            reuseIdentifier: StudentTableViewCell.reuseIdentifier
        )

        cell.configure(with: student)

        XCTAssertEqual(
            cell.accessibilityIdentifier,
            "studentCell.\(student.id.uuidString)"
        )

        XCTAssertTrue(
            cell.accessibilityLabel?.contains(student.name) == true
        )
    }
}
