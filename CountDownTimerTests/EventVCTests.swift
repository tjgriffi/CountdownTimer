//
//  CountDownTimerTests.swift
//  CountDownTimerTests
//
//  Created by Terrance Griffith on 7/22/21.
//

import XCTest
@testable import CountDownTimer

class MockEventPresenter: EventPresenter{
    
    var onStartCalled = 0
    var eventEnteredCalled = 0
    
    override func onStart() {
        onStartCalled += 1
    }
    
    override func eventEntered(name: String, year: Int, month: Int, day: Int, hour: Int? = -7, min: Int? = 0, sec: Int? = 0) {
        eventEnteredCalled += 1
    }
}

class EventVCTests: XCTestCase {
    
    var mockEventPresenter: MockEventPresenter!
    var events: [Event] = [Event]()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func makeSUT() -> EventViewController{
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateInitialViewController() as! EventViewController
        
        mockEventPresenter = MockEventPresenter(eventView: controller, events: events)
        
        controller.presenter = mockEventPresenter
        controller.loadViewIfNeeded()
        
        return controller
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testViewDidLoadCallsPresenter(){
        
        let sut = makeSUT()
        
        sut.viewDidLoad()
        
        XCTAssertGreaterThan(mockEventPresenter.onStartCalled, 0)
    }
    
    func testEventEnteredCalled(){
        
        let sut = makeSUT()
        
        sut.startPressed()
        
        XCTAssertEqual(mockEventPresenter.eventEnteredCalled, 1)
    }
        
    func testTimeUntilDate(){
        
        let sut = makeSUT()
        
        // Create date 20 days from now
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 20
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        XCTAssertEqual(sut.calcTimeUntilDate(date: futureDate!), 1728000)
    }
    
    func testGetTimerValues(){
        
        let sut = makeSUT()
        
        var totalTimeSeconds = 283571
        
        var timerValues = sut.getTimerValues(seconds: totalTimeSeconds)
        
        XCTAssertEqual(timerValues[0], 3)
        XCTAssertEqual(timerValues[1], 6)
        XCTAssertEqual(timerValues[2], 46)
        XCTAssertEqual(timerValues[3], 11)
        
        totalTimeSeconds = 0
        timerValues = sut.getTimerValues(seconds: totalTimeSeconds)
        
        XCTAssertEqual(timerValues[0], 0)
        XCTAssertEqual(timerValues[1], 0)
        XCTAssertEqual(timerValues[2], 0)
        XCTAssertEqual(timerValues[3], 0)
        
        totalTimeSeconds = -1
        timerValues = sut.getTimerValues(seconds: totalTimeSeconds)
        
        XCTAssertEqual(timerValues[0], 0)
        XCTAssertEqual(timerValues[1], 0)
        XCTAssertEqual(timerValues[2], 0)
        XCTAssertEqual(timerValues[3], 0)
    }

}
