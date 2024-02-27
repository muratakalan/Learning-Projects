//
//  ViewController.swift
//  Project 02 - StopWatch
//
//  Created by murat akalan on 27.02.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var timerCounting: Bool = false
    var startTime: Date?
    var stopTime: Date?
    
    static let START_TIME_KEY = "startTime"
    static let STOP_TIME_KEY = "stopTime"
    static let COUNTING_KEY = "countingKey"
    
    let userDefaults = UserDefaults.standard
    
    var scheduledTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTime = userDefaults.object(forKey: ViewController.START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: ViewController.STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: ViewController.COUNTING_KEY)
        
        if timerCounting {
            startTimer()
        } else {
            stopTimer()
            if let start = startTime, let stop = stopTime {
                let time = calcRestartTime(start: start, stop: stop)
                let diff = Date().timeIntervalSince(time)
                setTimeLabel(Int(diff))
            }
        }
    }

    @IBAction func startStopAction(_ sender: Any) {
        guard let startTime = startTime else {
            setStartTime(date: Date())
            startTimer()
            return
        }

        setStopTime(date: Date())
        stopTimer()
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    func startTimer() {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
        startStopButton.setTitle(NSLocalizedString("STOP", comment: ""), for: .normal)
        startStopButton.setTitleColor(UIColor.red, for: .normal)
    }
    
    @objc func refreshValue() {
        guard let start = startTime else {
            stopTimer()
            setTimeLabel(0)
            return
        }
        let diff = Date().timeIntervalSince(start)
        setTimeLabel(Int(diff))
    }
    
    func setTimeLabel(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        timeLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int) {
        let hour = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        return String(format: "%02d:%02d:%02d", hour, min, sec)
    }
    
    func stopTimer() {
        scheduledTimer?.invalidate()
        setTimerCounting(false)
        startStopButton.setTitle(NSLocalizedString("START", comment: ""), for: .normal)
        startStopButton.setTitleColor(UIColor.systemGreen, for: .normal)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        setStopTime(date: nil)
        setStartTime(date: nil)
        timeLabel.text = makeTimeString(hour: 0, min: 0, sec: 0)
        stopTimer()
    }
    
    func setStartTime(date: Date?) {
        startTime = date
        userDefaults.set(startTime, forKey: ViewController.START_TIME_KEY)
    }
    
    func setStopTime(date: Date?) {
        stopTime = date
        userDefaults.set(stopTime, forKey: ViewController.STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool) {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: ViewController.COUNTING_KEY)
    }
}
