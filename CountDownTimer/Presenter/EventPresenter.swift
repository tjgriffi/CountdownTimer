//
//  EventPresenter.swift
//  EventPresenter
//
//  Created by Terrance Griffith on 7/22/21.
//

import Foundation

class EventPresenter{
    
    let eventView: EventView
    var events: [Event]
    
    init(eventView: EventView, events: [Event]){
        self.eventView = eventView
        self.events = events
    }
    
    // On start show the event input box, and the table of events
    func onStart(){
        
        eventView.showEventInputBox()
        
        if events.count > 0{
            eventView.show(event: events[0])
        } else {

        }
        
    }
     
    // Example Date: 2020-05-07 07:00:00 +0000
    func eventEntered(name: String, year: Int, month: Int, day: Int, hour: Int? = 0, min: Int? = 0, sec: Int? = 0){
        
        // Check if the name was empty
        if name.isEmpty{
            eventView.showWarningMsg(with: "Event name was empty")
            return
        }
        
        // Create an event object with the given parameters and add it to the list of events
        var dateComponents = DateComponents()
                
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = min
        dateComponents.second = sec
        
//        let calendar = Calendar(identifier: .gregorian)
                
        guard let dateToAdd = Calendar.current.date(from: dateComponents) else {
            eventView.showWarningMsg(with: "Date was invalid")
            return
        }
        
        // Check if the date was in the past
        let now = Date()
        if now > dateToAdd{
            eventView.showWarningMsg(with: "Date must be in the future to be count down to ;)")
            return
        }
        
        print("dc: \(dateComponents.description)")
        print("add: \(dateToAdd.description)")
        
        // Create the event object
        let eventToAdd = Event.init(name: name, date: dateToAdd)
        
        // Add the event to the list of events
        events.append(eventToAdd)
        
        // Show the event in the VC
        eventView.show(event: eventToAdd)
    }
}
