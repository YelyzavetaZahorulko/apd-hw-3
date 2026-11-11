# HW3 Agent Worklog

If no agent or AI tool was used, say so explicitly. If one was used, record
each material task, inspect the resulting diff, and record one recommendation
you rejected or revised; if none was rejectable, explain why.

| Date | Tool/task | Student review | Evidence |
| --- | --- | --- | --- |
| 2026-11-11 | ChatGPT — help with UIKit, MVC and SnapKit implementation | Reviewed the student list and reusable cell code. Checked that all student fields are displayed and the layout uses SnapKit. | `StudentListViewController.swift`, `StudentTableViewCell.swift` |
 |
| 2026-11-11 | ChatGPT — subject filtering | Revised the initial solution. Subject buttons originally displayed an alert, but the assignment requires a filtered list. Changed the implementation to use `students(matchingSubject:)` and push another list screen. | `StudentDetailViewController.swift`, `StudentListViewController.swift` |
| 2026-11-11 | ChatGPT — accessibility review | Checked the required identifiers and corrected the student list identifier to `studentList`. | `StudentListViewController.swift`, `StudentTableViewCell.swift` |
| 2026-11-11 | ChatGPT — debugging help | Investigated simulator display issues. Restarting the Mac resolved the black-screen problem, and the app opened normally afterward. | Xcode, iOS Simulator |

## Final review

- **Agent/tool disclosure:** I used ChatGPT to help with implementation, debugging, code review, test examples and documentation. 
- **Accepted and rejected/revised recommendations:** I accepted suggestions for navigation, subject filtering and accessibility improvements after reviewing the code. I revised the initial subject-button implementation because showing an alert did not satisfy the assignment. I changed it to open a filtered student list.

- **Exact local test command and result:** Not completed yet. The application was launched and manually checked in the iOS Simulator. The final `xcodebuild test` command and its result will be recorded after testing.

- **Exact local test command and result:** Ran all tests in Xcode
  using Product → Test (Cmd + U) on the iPhone 17 simulator.
  Result: All tests passed.

- **Known limitation or remaining risk:** The new XCTest methods still need a successful test run. The optional add, edit and delete user interface is not implemented.
