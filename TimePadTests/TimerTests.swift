////
////  TimerTests.swift
////  TimePadTests
////
////  Created by Melik Demiray on 4.11.2024.
////
//
//import Testing
//@testable import TimePad
//import Foundation
//
//struct TimerTests: TestSuite {
//
//    @Test
//    func testDidStartTimer_WhenTimerIsRunning_ShouldStopTimer() {
//        let viewModel = TimerView()
//        let mockDelegate = MockTimerVMDelegate()
//        viewModel.delegate = mockDelegate
//        viewModel.isTimerRunning = true
//
//        viewModel.didStartTimer()
//
//        #expect(mockDelegate.isStopTimerCalled).toBeTrue("Expected stopTimer to be called when timer is running.")
//    }
//
//    @Test
//    func testDidStartTimer_WhenTimerIsNotRunning_ShouldStartTimer() {
//        let viewModel = TimerVM()
//        let mockDelegate = MockTimerVMDelegate()
//        viewModel.delegate = mockDelegate
//        viewModel.isTimerRunning = false
//
//        viewModel.didStartTimer()
//
//        #expect(mockDelegate.isStartTimerCalled).toBeTrue("Expected startTimer to be called when timer is not running.")
//    }
//
//    @Test
//    func testDidPauseTimer_WhenTimerIsRunning_ShouldPauseTimer() {
//        let viewModel = TimerVM()
//        let mockDelegate = MockTimerVMDelegate()
//        viewModel.delegate = mockDelegate
//        viewModel.isTimerRunning = true
//
//        viewModel.didPauseTimer()
//
//        expect(mockDelegate.isPauseTimerCalled).toBeTrue("Expected pauseTimer to be called when timer is running.")
//    }
//
//    @Test
//    func testDidPauseTimer_WhenTimerIsNotRunning_ShouldResumeTimer() {
//        let viewModel = TimerVM()
//        let mockDelegate = MockTimerVMDelegate()
//        viewModel.delegate = mockDelegate
//        viewModel.isTimerRunning = false
//
//        viewModel.didPauseTimer()
//
//        expect(mockDelegate.isResumeTimerCalled).toBeTrue("Expected resumeTimer to be called when timer is not running.")
//    }
//
//    @Test
//    func testDidResetTimer_WhenTimerIsRunning_ShouldResetTimer() {
//        let viewModel = TimerVM()
//        let mockDelegate = MockTimerVMDelegate()
//        viewModel.delegate = mockDelegate
//        viewModel.isTimerRunning = true
//
//        viewModel.didResetTimer()
//
//        expect(mockDelegate.isResetTimerCalled).toBeTrue("Expected resetTimer to be called when timer is running.")
//    }
//
//    @Test
//    func testDidResetTimer_WhenTimerIsNotRunning_ShouldResetTimer() {
//        let viewModel = TimerVM()
//        let mockDelegate = MockTimerVMDelegate()
//        viewModel.delegate = mockDelegate
//        viewModel.isTimerRunning = false
//
//        viewModel.didResetTimer()
//
//        expect(mockDelegate.isResetTimerCalled).toBeTrue("Expected resetTimer to be called when timer is not running.")
//    }
//}
//
//class MockTimerVMDelegate: TimerViewDelegate {
//    var isStartTimerCalled = false
//    var isStopTimerCalled = false
//    var isPauseTimerCalled = false
//    var isResumeTimerCalled = false
//    var isResetTimerCalled = false
//
//    func startTimer() {
//        isStartTimerCalled = true
//    }
//
//    func stopTimer() {
//        isStopTimerCalled = true
//    }
//
//    func pauseTimer() {
//        isPauseTimerCalled = true
//    }
//
//    func resumeTimer() {
//        isResumeTimerCalled = true
//    }
//
//    func resetTimer() {
//        isResetTimerCalled = true
//    }
//
//    // Optional delegate methods can be implemented here if needed
//}
