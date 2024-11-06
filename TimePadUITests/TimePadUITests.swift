////
////  TimePadUITests.swift
////  TimePadUITests
////
////  Created by Melik Demiray on 24.09.2024.
////
//
//import XCTest
//
//final class TimerUITests: XCTestCase {
//
//    private var app: XCUIApplication!
//
//    override func setUpWithError() throws {
//        continueAfterFailure = false
//        app = XCUIApplication()
//        // delete user defaults
//        app.launchArguments.append("--resetUserDefaults") // UserDefaults'ları sıfırlamak için argüman ekliyoruz
//
//        //app.launchArguments.append("--resetOnboarding") // Onboarding ekranını başlatmak için argüman ekliyoruz
//        app.launch()
//    }
//
//    func testOnboardingScreen_ShouldDisplaySlidesAndPageControl() {
//        // Ekranın onboarding ekranında açıldığını kontrol et
//        XCTAssertTrue(app.otherElements["OnboardingScreen"].exists, "Onboarding screen should be displayed.")
//
//        // Sayfa kontrolü mevcut mu?
//        XCTAssertTrue(app.pageIndicators["pageControl"].exists, "Page control should exist.")
//
//        // "Get Started" butonunun görünür olup olmadığını kontrol et
//        let getStartedButton = app.buttons["Get Started"]
//        XCTAssertTrue(getStartedButton.exists, "Get Started button should exist.")
//        XCTAssertFalse(getStartedButton.isHittable, "Get Started button should not be tappable initially.")
//    }
//
//    func testSwipeThroughSlides_UpdatesPageControl() {
//        let pageControl = app.pageIndicators["pageControl"]
//
//        for i in 0..<3 {
//            XCTAssertEqual(pageControl.value as? String, "\(i + 1) of 3", "Page control should update to page \(i + 1).")
//            app.swipeLeft() // Bir sonraki slide'a geç
//        }
//    }
//
//    func testGetStartedButton_Tap_ShouldDismissOnboarding() {
//        let getStartedButton = app.buttons["Get Started"]
//
//        // Onboarding ekranındaki son slide'a geçmek için kaydırıyoruz
//        app.swipeLeft()
//        app.swipeLeft()
//
//        // "Get Started" butonuna tıklıyoruz
//        XCTAssertTrue(getStartedButton.isHittable, "Get Started button should be tappable on the last slide.")
//        getStartedButton.tap()
//
//        // Onboarding ekranının kapandığını kontrol et
//        XCTAssertFalse(app.otherElements["OnboardingScreen"].exists, "Onboarding screen should be dismissed after tapping Get Started.")
//    }
//
//    func testPauseButton_ShouldToggleBetweenPauseAndResume() throws {
//        // Pause butonunu bul ve tıkla
//        let pauseButton = app.buttons["Pause"]
//        XCTAssertTrue(pauseButton.exists, "Pause button should exist.")
//
//        pauseButton.tap()
//
//        // Tıklamadan sonra butonun metni "Resume" olmalı
//        let resumeButton = app.buttons["Resume"]
//        XCTAssertTrue(resumeButton.exists, "Pause button should toggle to 'Resume' when tapped.")
//
//        // "Resume" butonuna tekrar tıklayınca "Pause" olmalı
//        resumeButton.tap()
//        XCTAssertTrue(pauseButton.exists, "Resume button should toggle back to 'Pause' when tapped.")
//    }
//
//    func testResetButton_ShouldResetTimer() throws {
//        // Reset butonunu bul ve tıkla
//        let resetButton = app.buttons["Reset"]
//        XCTAssertTrue(resetButton.exists, "Reset button should exist.")
//
//        // Reset butonuna tıklayınca timer sıfırlanmalı, timer'ın sıfırlanmış olduğundan emin olalım
//        resetButton.tap()
//
//        // Timer'in başlangıç değerleri ile güncellendiğini kontrol et
//        let timerLabel = app.staticTexts["timerLabel"]
//        XCTAssertEqual(timerLabel.label, "00:00:00", "Timer should reset to 00:00:00 when reset button is tapped.")
//    }
//
//    func testTimerCompletion_ShouldShowCompletionAlert() throws {
//        // Timer'i tamamlamak için ileriye sar (otomasyon için zaman atlama yapılabilir)
//
//        // Tamamlandığında, "Timer Completed!" alertinin görünmesi beklenir
//        let completionAlert = app.alerts["Timer Completed!"]
//        XCTAssertTrue(completionAlert.waitForExistence(timeout: 5), "Completion alert should appear when timer completes.")
//
//        // Alert üzerindeki "OK" butonuna tıklayınca alert kapanmalı
//        let okButton = completionAlert.buttons["OK"]
//        XCTAssertTrue(okButton.exists, "OK button should exist in completion alert.")
//        okButton.tap()
//
//        XCTAssertFalse(completionAlert.exists, "Completion alert should disappear after tapping OK.")
//    }
//}
