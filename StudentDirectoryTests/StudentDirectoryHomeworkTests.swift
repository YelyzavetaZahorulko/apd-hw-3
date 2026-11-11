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
    
    func testAddingStudentUsesDefaultValues() throws {
        let store = StudentStore()

        try store.addStudent(name: "New Student", age: 21)

        let student = try XCTUnwrap(store.students.last)

        XCTAssertEqual(student.name, "New Student")
        XCTAssertEqual(student.age, 21)
        XCTAssertEqual(student.averageGrade, 0)
        XCTAssertFalse(student.isScholarshipHolder)
        XCTAssertTrue(student.subjects.isEmpty)
        XCTAssertEqual(student.avatarName, "avatar-default")
    }

    func testAddingNonPositiveAgeFails() {
        let store = StudentStore()
        let originalStudents = store.students

        XCTAssertThrowsError(
            try store.addStudent(name: "Test", age: 0)
        ) { error in
            XCTAssertEqual(
                error as? StudentStoreError,
                .nonPositiveAge
            )
        }

        XCTAssertEqual(store.students, originalStudents)
    }

    func testUpdatingStudentChangesOnlyNameAndAge() throws {
        let store = StudentStore()
        let original = try XCTUnwrap(store.students.first)

        try store.updateStudent(
            id: original.id,
            name: "Updated Name",
            age: 25
        )

        let updated = try XCTUnwrap(
            store.students.first { $0.id == original.id }
        )

        XCTAssertEqual(updated.name, "Updated Name")
        XCTAssertEqual(updated.age, 25)
        XCTAssertEqual(updated.id, original.id)
        XCTAssertEqual(updated.averageGrade, original.averageGrade)
        XCTAssertEqual(updated.isScholarshipHolder, original.isScholarshipHolder)
        XCTAssertEqual(updated.subjects, original.subjects)
        XCTAssertEqual(updated.avatarName, original.avatarName)
    }

    func testUpdatingUnknownStudentFails() {
        let store = StudentStore()
        let originalStudents = store.students
        let unknownID = UUID()

        XCTAssertThrowsError(
            try store.updateStudent(
                id: unknownID,
                name: "Test",
                age: 20
            )
        ) { error in
            XCTAssertEqual(
                error as? StudentStoreError,
                .unknownID(unknownID)
            )
        }

        XCTAssertEqual(store.students, originalStudents)
    }

    func testDeletingStudentRemovesOnlySelectedStudent() throws {
        let store = StudentStore()
        let originalStudents = store.students
        let student = try XCTUnwrap(originalStudents.first)

        try store.deleteStudent(id: student.id)

        XCTAssertEqual(
            store.students.count,
            originalStudents.count - 1
        )

        XCTAssertFalse(
            store.students.contains { $0.id == student.id }
        )

        XCTAssertEqual(
            store.students,
            Array(originalStudents.dropFirst())
        )
    }
}
