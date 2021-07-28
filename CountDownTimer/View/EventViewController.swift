//
//  EventViewController.swift
//  EventViewController
//
//  Created by Terrance Griffith on 7/22/21.
//

import UIKit

protocol EventView{
    func showEventInputBox()
    func show(event: Event)
    func showWarningMsg(with message:String)
    func showEventReaced()
}

class EventViewController: UIViewController {
    
    @IBOutlet weak var eventStackView: UIStackView!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var eventNameTF: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var eventLabel: UILabel!
    
    var presenter: EventPresenter!
    var updateTimer: Timer?     // Stores the timer
    var totalTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Tell the presenter to start
        presenter.onStart()
    }
    
    // MARK: - IBActions
    @IBAction func startPressed(){
        
        // Get the info of the date picked
        let date = eventDatePicker.date
        let calendar = Calendar.current
        
        // Take the information from the date input and enter an event
        presenter.eventEntered(name: eventNameTF.text!, year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date), hour: calendar.component(.hour, from: date), sec: calendar.component(.second, from: date))
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Extensions
// MARK: EventView
extension EventViewController: EventView{
    
    func show(event: Event) {
        // Show the appropriate events
        eventStackView.isHidden = false
        eventLabel.isHidden = false
        eventDatePicker.isHidden = true
        startBtn.isHidden = true
        eventNameTF.isHidden = true
        
        // Set the label
        eventLabel.text = event.name
        
        // Adjust the count down labels
        totalTime = calcTimeUntilDate(date: event.date)
        
        // Start the timer action
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerAction), userInfo: nil, repeats: true)
    }
    
    func calcTimeUntilDate(date: Date)-> Int{
        
        return Int(round(date.timeIntervalSinceNow))
    }
    
    @objc func updateTimerAction(){
        
        // Update timer label values
        let timerValues = getTimerValues(seconds: totalTime)
        
        // Set the timervalues
        daysLabel.text = String(timerValues[0])
        hoursLabel.text = String(timerValues[1])
        minLabel.text = String(timerValues[2])
        secLabel.text = String(timerValues[3])
        
        // Decrement the total time
        totalTime -= 1
        
        // If the time less than 0, stop the action, and show some success alert
        if totalTime <= -1{
            // Stop the timer action and such
            updateTimer = nil
            
            // Show the success
            showEventReaced()
            
        }
    }
    
    func getTimerValues(seconds: Int) -> [Int]{
        
        var valueReturnValues = [0,0,0,0]
        
        var totalTimeSeconds = seconds
        var days = 0, hours = 0, min = 0, sec = 0
        
        if totalTimeSeconds > 0{
            days = totalTimeSeconds / 86400
            totalTimeSeconds %= 86400
        }
        
        if totalTimeSeconds > 0{
            hours = totalTimeSeconds / 3600
            totalTimeSeconds %= 3600
        }
        
        if totalTimeSeconds > 0{
            min = totalTimeSeconds / 60
            totalTimeSeconds %= 60
        }
            
        if totalTimeSeconds >= 0{
            sec = totalTimeSeconds
        }
        
        valueReturnValues[0] = days
        valueReturnValues[1] = hours
        valueReturnValues[2] = min
        valueReturnValues[3] = sec
        
        return valueReturnValues
    }
    
    func decrementValues(){
        
    }
    
    func showEventInputBox() {
        eventDatePicker.isHidden = false
        startBtn.isHidden = false
        eventNameTF.isHidden = false
        eventStackView.isHidden = true
        eventLabel.isHidden = true
    }
    
    func showWarningMsg(with message: String) {
        let warningAlertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        
        warningAlertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        self.present(warningAlertController, animated: true, completion: nil)
    }
    
    func showEventReaced() {
        
        let eventReachedController = UIAlertController(title: "Event Reached!", message: "The countdown has finished, hopefully the event was worth it!! :D", preferredStyle: .alert)
        
        eventReachedController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {_ in
            self.eventNameTF.text! = ""
            self.showEventInputBox()
        }))
        
        self.present(eventReachedController, animated: true, completion: nil)
    }
    
    
}
