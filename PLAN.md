# HW3 Student Plan

## Approach
I will use MVC architecture with UIKit and SnapKit.
The Student model and StudentStore will be used for student data. I will keep one shared StudentStore and pass it to the view controllers, so all screens use the same data.
For the main screen, I will use UITableView with reusable cells. Each cell will show the student's avatar, name, age, average grade, and scholarship status.
When the user taps a student, the app will open a detail screen with all information about that student.
The subjects on the detail screen will be buttons. When a subject is selected, the app will show students who have that exact subject. I will use the existing filtering method in StudentStore to keep the original order.
I will use SnapKit for layouts and UINavigationController for navigation. I will also add accessibility identifiers and support Dynamic Type.
For the bonus part, I plan to add forms for creating and editing students and support swipe-to-delete. These actions will use StudentStore methods.

## Milestones

- [ ] Student list and reusable cell
- [ ] Detail screen and navigation
- [ ] Subject-filtered list
- [ ] Unit and UI tests
- [ ] Optional add/edit/delete bonus, if attempted
- [ ] Local verification and CI review
- [ ] Final diff and evidence review

## Verification plan
 will test the student list, navigation, and subject filtering in the iPhone simulator.

I will add at least six new XCTest methods to check the model, StudentStore, and UI behavior. I will also test invalid input and store updates for the bonus features.

I will keep the provided tests unchanged.
Final test command:

```bash
xcodebuild -project StudentDirectory.xcodeproj \
  -scheme StudentDirectory \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  test
```

After testing, I will review the Git changes, complete AGENT_WORKLOG.md, and check the GitHub Actions results.
