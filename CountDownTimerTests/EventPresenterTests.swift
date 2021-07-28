//
//  EventPresenterTests.swift
//  EventPresenterTests
//
//  Created by Terrance Griffith on 7/22/21.
//

import XCTest
@testable import CountDownTimer

// MARK: Mock Classes
// MARK: Mock EventView
class MockEventView: EventView{
    
    // Keep track of what's being called
    var showEventInputBoxCalled = 0
    var showEventsCalled = 0
    var showWarningCalled = 0
    var showEventReachedCalled = 0
    var warningMsg = ""
    
    func showEventReaced() {
        showEventReachedCalled += 1
    }
    
    func show(event: Event) {
        showEventsCalled += 1
    }
    
    func showEventInputBox() {
        showEventInputBoxCalled += 1
    }
    
    func showWarningMsg(with message: String) {
        showWarningCalled += 1
        warningMsg = message
    }
}

class EventPresenterTests: XCTestCase {
    
    var mockEventView = MockEventView()
    var events = [Event]()
    var sut: EventPresenter!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        
        sut = EventPresenter(eventView: mockEventView, events: events)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        sut = nil
        try super.tearDownWithError()
    }
    
    func makeSUT(){
        sut = EventPresenter(eventView: mockEventView, events: events)
    }

    func testOnStart(){
        
        makeSUT()
        
        // When
        XCTAssertEqual( mockEventView.showEventInputBoxCalled, 0, "The showevent input box should'ntve been called yet")
        XCTAssertEqual( mockEventView.showEventsCalled, 0, "The showevent should'ntve been called yet")
        sut.onStart()
        
        // Then
        XCTAssertEqual( mockEventView.showEventInputBoxCalled, 1, "The showevent input box should've been called, incrementing the value")
    }
    
    func testValidEventEnteredNoTime(){
        
        makeSUT()
        
        // When
        XCTAssertEqual(events.count, 0, "The event shouldntve incremented yet")
        XCTAssertEqual(mockEventView.showWarningCalled, 0, "Warning shouldnt've fired off")
        XCTAssertTrue(mockEventView.warningMsg.isEmpty, "There shouldnt be a warning message")
        sut.eventEntered(name: "Event Name", year: 2050, month: 5, day: 6)
        
        // Then
        XCTAssertEqual(sut.events.count, 1, "The event shoudlve been incremented")
        XCTAssertEqual(mockEventView.showWarningCalled, 0, "Warning shouldnt've fired off")
        XCTAssertTrue(mockEventView.warningMsg.isEmpty, "There shouldnt be a warning message")
        
        if sut.events.count != 0{
            XCTAssertEqual(sut.events[0].name, "Event Name")
            XCTAssertEqual(sut.events[0].date.description , "2050-05-06 00:00:00 +0000")
        } else {
            XCTFail("There should be a value in the events list")
        }
    }
    
    func testInValidEventEnteredNoName(){
        
        makeSUT()
        
        // When
        XCTAssertEqual(events.count, 0, "The event shouldntve incremented yet")
        XCTAssertEqual(mockEventView.showWarningCalled, 0, "Warning shouldnt've fired off")
        XCTAssertTrue(mockEventView.warningMsg.isEmpty, "There shouldnt be a warning message")
        sut.eventEntered(name: "", year: 2030, month: 12, day: 10)
        
        // Then
        XCTAssertEqual(sut.events.count, 0)
        XCTAssertEqual(mockEventView.showWarningCalled, 1)
        XCTAssertEqual(mockEventView.warningMsg, "Event name was empty")
    }
    
    func testInValidEventEnteredPastDate(){
        
        makeSUT()
        
        // When
        XCTAssertEqual(events.count, 0, "The event shouldntve incremented yet")
        XCTAssertEqual(mockEventView.showWarningCalled, 0, "Warning shouldnt've fired off")
        XCTAssertTrue(mockEventView.warningMsg.isEmpty, "There shouldnt be a warning message")
        sut.eventEntered(name: "Event name", year: 2010, month: 12, day: 10)
        
        // Then
        XCTAssertEqual(sut.events.count, 0)
        XCTAssertEqual(mockEventView.showWarningCalled, 1)
        XCTAssertEqual(mockEventView.warningMsg, "Date must be in the future to be count down to ;)")
    }
    
    func testValidEventEnteredHourAndTime(){
        
        makeSUT()
        
        // When
        XCTAssertEqual(events.count, 0, "The event shouldntve incremented yet")
        XCTAssertEqual(mockEventView.showWarningCalled, 0, "Warning shouldnt've fired off")
        XCTAssertTrue(mockEventView.warningMsg.isEmpty, "There shouldnt be a warning message")
        sut.eventEntered(name: "Event Name", year: 2050, month: 5, day: 6, hour: 1, min: 23, sec: 45)
        
        // Then
        XCTAssertEqual(sut.events.count, 1, "The event shouldve been incremented")
        XCTAssertEqual(mockEventView.showWarningCalled, 0, "Warning shouldnt've fired off")
        XCTAssertTrue(mockEventView.warningMsg.isEmpty, "There shouldnt be a warning message")
        
        if sut.events.count != 0{
            XCTAssertEqual(sut.events[0].name, "Event Name")
            XCTAssertEqual(sut.events[0].date.description , "2050-05-06 01:23:45 +0000")
        } else {
            XCTFail("There should be a value in the events list")
        }
    }

}
