//
//  TimerTests.swift
//  TimePadTests
//
//  Created by Melik Demiray on 4.11.2024.
//

import Testing
@testable import TimePad
import Foundation

struct TimerTests {

    private func createTimerView(hours: Int = 0, minutes: Int = 5, seconds: Int = 5) -> TimerView {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        return TimerView(frame: frame, hours: hours, minutes: minutes, seconds: seconds)
    }

    @Test
    func testPauseButtonTapped_ShouldPauseTimer() {
        // Given
        let timerView = createTimerView()
        let mockDelegate = MockTimerView()
        timerView.delegate = mockDelegate

        // When
        timerView.toggleTimer() // This will trigger pause since initial state is not paused

        // Then
        #expect(mockDelegate.isPauseButtonTappedCalled)
        #expect(timerView.isPaused)
    }

    @Test
    func testResumeButtonTapped_ShouldResumeTimer() {
        // Given
        let timerView = createTimerView()
        let mockDelegate = MockTimerView()
        timerView.delegate = mockDelegate

        // First pause the timer
        timerView.toggleTimer()
        #expect(timerView.isPaused)

        // When
        timerView.toggleTimer() // This will resume the timer

        // Then
        #expect(mockDelegate.isResumeButtonTappedCalled)
        #expect(!timerView.isPaused)
    }

    @Test
    func testTimerDidComplete_ShouldCompleteTimer() {
        // Given
        let timerView = createTimerView(hours: 0, minutes: 0, seconds: 1)
        let mockDelegate = MockTimerView()
        timerView.delegate = mockDelegate

        // When
        timerView.startTimer()

        // Then
        // Wait for 1.5 seconds to ensure timer completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            #expect(mockDelegate.isTimerDidCompleteCalled)
        }
    }

    @Test
    func testInitialization_ShouldSetCorrectInitialValues() {
        // Given
        let timerView = createTimerView(hours: 1, minutes: 30, seconds: 0)

        // Then
        #expect(!timerView.isPaused)
        #expect(timerView.lastHour == nil)
        #expect(timerView.lastMinute == nil)
        #expect(timerView.lastSeconds == nil)
    }

    @Test
    func testResetTimer_ShouldResetToNewValues() {
        // Given
        let timerView = createTimerView()
        let mockDelegate = MockTimerView()
        timerView.delegate = mockDelegate

        // When
        timerView.resetTimer(firstHour: 2, firstMinute: 15)

        // Then
        #expect(timerView.isPaused)
        #expect(mockDelegate.isPauseButtonTappedCalled)
    }

    @Test
    func testSetLastWorkModel_ShouldStoreCurrentValues() {
        // Given
        let timerView = createTimerView(hours: 1, minutes: 30, seconds: 0)

        // When
        timerView.setLastWorkModel()

        // Then
        #expect(timerView.lastHour != nil)
        #expect(timerView.lastMinute != nil)
        #expect(timerView.lastSeconds != nil)
    }

}

class MockTimerView: TimerViewDelegate {
    func pauseButtonTapped() {
        pauseButtonClicked()
    }

    func resumeButtonTapped() {
        resumeButtonClicked()
    }

    func timerDidComplete() {
        timerDidCompleteClicked()
    }


    var isPauseButtonTappedCalled = false
    var isResumeButtonTappedCalled = false
    var isTimerDidCompleteCalled = false

    func pauseButtonClicked() {
        isPauseButtonTappedCalled = true
    }

    func resumeButtonClicked() {
        isResumeButtonTappedCalled = true
    }

    func timerDidCompleteClicked() {
        isTimerDidCompleteCalled = true
    }

}
