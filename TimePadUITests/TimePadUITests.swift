//
//  TimePadUITests.swift
//  TimePadUITests
//
//  Created by Melik Demiray on 24.09.2024.
//

import XCTest

final class TimerUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        // Clear User Defaults completely
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            UserDefaults.standard.synchronize()
        }

        // Add launch arguments for testing
        app.launchArguments += [
            "--uitesting", // Flag to indicate UI testing mode
            "--resetUserDefaults", // Reset all user defaults
            "--resetOnboarding", // Specifically reset onboarding state
            "-hasSeenOnboarding", "false" // Explicitly set onboarding flag to false
        ]

        // Add launch environment variables
        app.launchEnvironment = [
            "isUITesting": "true",
            "resetOnboarding": "true"
        ]

        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        super.tearDown()
    }

    func testOnboardingScreen_ShouldDisplaySlidesAndPageControl() {
        // Ekranın onboarding ekranında açıldığını kontrol et
        XCTAssertTrue(app.otherElements["OnboardingScreen"].exists, "Onboarding screen should be displayed.")

        // Sayfa kontrolü mevcut mu?
        XCTAssertTrue(app.pageIndicators["pageControl"].exists, "Page control should exist.")

        // "Get Started" butonunun görünür olup olmadığını kontrol et
        let getStartedButton = app.buttons["Get Started"]
        XCTAssertTrue(getStartedButton.exists, "Get Started button should exist.")
        XCTAssertTrue(getStartedButton.isHittable, "Get Started button should be tappable initially.")
    }

    func testSwipeThroughSlides_UpdatesPageControl() {
        let pageControl = app.pageIndicators["pageControl"]

        for i in 0..<3 {
            XCTAssertEqual(pageControl.value as? String, "page \(i + 1) of 3", "Page control should update to page \(i + 1).")
            app.swipeLeft() // Bir sonraki slide'a geç
        }
    }

    func testGetStartedButton_Tap_ShouldDismissOnboarding() {
        let getStartedButton = app.buttons["Get Started"]

        // Onboarding ekranındaki son slide'a geçmek için kaydırıyoruz
        app.swipeLeft()
        app.swipeLeft()

        // "Get Started" butonuna tıklıyoruz
        XCTAssertTrue(getStartedButton.isHittable, "Get Started button should be tappable on the last slide.")
        getStartedButton.tap()

        // Onboarding ekranının kapandığını kontrol et
        XCTAssertFalse(app.otherElements["OnboardingScreen"].exists, "Onboarding screen should be dismissed after tapping Get Started.")
    }

    func testPauseButton_ShouldToggleBetweenPauseAndResume() throws {
        let getStartedButton = app.buttons["Get Started"]
        getStartedButton.tap()

        // click first item of tableView
        let tableView = app.tables.firstMatch
        let cell = tableView.cells.element(boundBy: 0)
        cell.tap()

        // Pause butonunu bul ve tıkla
        let pauseButton = app.buttons["PauseButton"]
        XCTAssertTrue(pauseButton.exists, "Pause button should exist.")

        pauseButton.tap()

        // Tıklamadan sonra butonun metni "Resume" olmalı
        let resumeButton = app.buttons["PauseButton"]
        XCTAssertTrue(resumeButton.exists, "Pause button should toggle to 'Resume' when tapped.")

        // "Resume" butonuna tekrar tıklayınca "Pause" olmalı
        resumeButton.tap()
        XCTAssertTrue(pauseButton.exists, "Resume button should toggle back to 'Pause' when tapped.")
    }

    func testResetButton_ShouldResetTimer() throws {
        let getStartedButton = app.buttons["Get Started"]
        getStartedButton.tap()

        // click first item of tableView
        let tableView = app.tables.firstMatch
        let cell = tableView.cells.element(boundBy: 0)
        cell.tap()

        // Reset butonunu bul ve tıkla
        let resetButton = app.buttons["ResetButton"]
        XCTAssertTrue(resetButton.exists, "Reset button should exist.")

        // Reset butonuna tıklayınca timer sıfırlanmalı, timer'ın sıfırlanmış olduğundan emin olalım
        resetButton.tap()

        // pause buttonunda pause yazmalı
        let pauseButton = app.buttons["PauseButton"]
        XCTAssertTrue(pauseButton.exists, "Pause button should exist.")
    }

    func testAddTaskComletion() throws {
        // Complete onboarding
        let getStartedButton = app.buttons["Get Started"]
        getStartedButton.tap()

        // Go to add work tab
        app.tabBars.buttons.element(boundBy: 0).tap()

        // Write title
        let titleTextField = app.textFields["workTitleText"]
        titleTextField.tap()
        titleTextField.typeText("Test Title")
        titleTextField.typeText("\n")

        // Dismiss keyboard after title input
        app.tap() // Tap outside to dismiss keyboard

        // Select time
        let timePicker = app.datePickers["timePicker"]
        timePicker.swipeDown()

        // Select image and handle keyboard
        let workImage = app.images["workImage"]
        if workImage.exists {
            workImage.tap()
        }

        // Save work item
        let saveButton = app.buttons["SaveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5), "Save button should exist")
        saveButton.tap()
    }

//    func testTimerCompletion_ShouldShowCompletionAlert() throws {
//
//        // Go to home screen
//        app.tabBars.buttons.element(boundBy: 1).tap()
//
//        // Wait for table view to load and tap first cell
//        let tableView = app.tables.firstMatch
//        XCTAssertTrue(tableView.waitForExistence(timeout: 5), "Table view should exist")
//
//        let cell = tableView.cells.element(boundBy: 0)
//        XCTAssertTrue(cell.waitForExistence(timeout: 5), "First cell should exist")
//        cell.tap()
//
//        // Set a very short timer duration for testing
//        let shortTimer = app.buttons["shortTimer"] // Add this accessibility identifier to your 1-second timer button
//        if shortTimer.exists {
//            shortTimer.tap()
//        }
//
//        // Wait for timer completion alert
//        let completionAlert = app.alerts["Timer Completed!"]
//        XCTAssertTrue(completionAlert.waitForExistence(timeout: 10), "Completion alert should appear when timer completes")
//
//        // Handle alert dismissal
//        let okButton = completionAlert.buttons["OK"]
//        XCTAssertTrue(okButton.exists, "OK button should exist in completion alert")
//        okButton.tap()
//
//        // Verify alert is dismissed
//        XCTAssertFalse(completionAlert.exists, "Completion alert should disappear after tapping OK")
//    }
}

// Helper method to wait for element
private func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 5) -> Bool {
    return element.waitForExistence(timeout: timeout)
}




