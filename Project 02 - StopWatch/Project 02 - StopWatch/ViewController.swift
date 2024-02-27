//
//  ViewController.swift
//  Project 02 - StopWatch
//
//  Created by murat akalan on 27.02.2024.
//
/*

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var timerCounting:Bool = false
    var startTime:Date?
    var stopTime:Date?
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
    var scheduledTimer: Timer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        
        if timerCounting
        {
            startTimer()
        }
        else
        {
            stopTimer()
            if let start = startTime
            {
                if let stop = stopTime
                {
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimeLabel(Int(diff))
                }
            }
        }
    }

    @IBAction func startStopAction(_ sender: Any)
    {
        if timerCounting
        {
            setStopTime(date: Date())
            stopTimer()
        }
        else
        {
            if let stop = stopTime
            {
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            }
            else
            {
                setStartTime(date: Date())
            }
            
            startTimer()
        }
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date
    {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    func startTimer()
    {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
        startStopButton.setTitle("STOP", for: .normal)
        startStopButton.setTitleColor(UIColor.red, for: .normal)
    }
    
    @objc func refreshValue()
    {
        if let start = startTime
        {
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
        }
        else
        {
            stopTimer()
            setTimeLabel(0)
        }
    }
    
    func setTimeLabel(_ val: Int)
    {
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        timeLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int)
    {
        let hour = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    func stopTimer()
    {
        if scheduledTimer != nil
        {
            scheduledTimer.invalidate()
        }
        setTimerCounting(false)
        startStopButton.setTitle("START", for: .normal)
        startStopButton.setTitleColor(UIColor.systemGreen, for: .normal)
    }
    
    @IBAction func resetAction(_ sender: Any)
    {
        setStopTime(date: nil)
        setStartTime(date: nil)
        timeLabel.text = makeTimeString(hour: 0, min: 0, sec: 0)
        stopTimer()
    }
    
    func setStartTime(date: Date?)
    {
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?)
    {
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool)
    {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
}
*/
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    private var timer: Timer?
    private var isTimerRunning = false
    private var startTime: Date?
    private var elapsedTime: TimeInterval = 0
    
    private let userDefaults = UserDefaults.standard
    private let startTimeKey = "StartTime"
    private let elapsedTimeKey = "ElapsedTime"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedData()
        updateTimeLabel()
    }
    
    private func loadSavedData() {
        startTime = userDefaults.object(forKey: startTimeKey) as? Date
        elapsedTime = userDefaults.double(forKey: elapsedTimeKey)
        isTimerRunning = startTime != nil
    }
    
    private func updateTimeLabel() {
        let timeString = makeTimeString(from: Int(elapsedTime))
        timeLabel.text = timeString
    }
    
    private func makeTimeString(from seconds: Int) -> String {
        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    @IBAction func startStopAction(_ sender: Any) {
        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        startTime = Date()
        userDefaults.set(startTime, forKey: startTimeKey)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.elapsedTime += 0.1
            self?.updateTimeLabel()
        }
        
        startStopButton.setTitle("STOP", for: .normal)
        isTimerRunning = true
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        userDefaults.removeObject(forKey: startTimeKey)
        userDefaults.set(elapsedTime, forKey: elapsedTimeKey)
        
        startStopButton.setTitle("START", for: .normal)
        isTimerRunning = false
    }
    
    @IBAction func resetAction(_ sender: Any) {
        stopTimer()
        startTime = nil
        elapsedTime = 0
        updateTimeLabel()
    }
}

