//
//  ViewController.swift
//  comodoroTimer
//
//  Created by 손겸 on 10/11/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var sessionTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    
    var dropTimer: Timer?
    var studySessionTimer: Timer?
    var sessionStartTime: Date?
    var totalStudyTime: TimeInterval = 0 // 총 공부 시간
    var elapsedTime: TimeInterval = 0 // 현재 세션의 경과 시간

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if sessionTimeLabel == nil {
            print("sessionTimeLabel is nil")
        } else {
            sessionTimeLabel.text = formatTime(0)
        }

        if totalTimeLabel == nil {
            print("totalTimeLabel is nil")
        } else {
            totalTimeLabel.text = formatTime(totalStudyTime)
        }
    }


    // 타이머 시작
    func startTimer() {
        sessionStartTime = Date() // 현재 세션의 시작 시간 기록

        // 타이머를 1초마다 업데이트
        studySessionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSessionTimer), userInfo: nil, repeats: true)
        
        // 픽셀 떨어지는 애니메이션
        dropTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(dropPixel), userInfo: nil, repeats: true)
    }
    
    // 타이머 정지
    func stopTimer() {
        if let startTime = sessionStartTime {
            // 세션 경과 시간을 총 공부 시간에 더함
            totalStudyTime += Date().timeIntervalSince(startTime)
        }
        sessionStartTime = nil
        studySessionTimer?.invalidate()
        dropTimer?.invalidate()
        studySessionTimer = nil
        dropTimer = nil
    }

    // 현재 세션 타이머 업데이트
    @objc func updateSessionTimer() {
        if let startTime = sessionStartTime {
            // 세션의 경과 시간 계산
            elapsedTime = Date().timeIntervalSince(startTime)
            sessionTimeLabel.text = formatTime(elapsedTime)
            totalTimeLabel.text = formatTime(totalStudyTime + elapsedTime) // 총 공부 시간 갱신
        }
    }

    // 타이머 형식 (시:분:초)으로 변환
    func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // 랜덤으로 픽셀 생성
    @objc func dropPixel() {
        let pixelSize: CGFloat = 15
        let pixel = UIView(frame: CGRect(x: CGFloat.random(in: 0..<view.frame.width - pixelSize), y: 10, width: pixelSize, height: pixelSize))
        pixel.backgroundColor = .color8 // 픽셀 색상은 필요에 맞게 수정
        view.addSubview(pixel)

        // 애니메이션으로 아래로 떨어지는 코드
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            pixel.frame.origin.y = self.view.frame.height - pixelSize
        }, completion: { _ in
            pixel.removeFromSuperview()
        })
    }

    @IBAction func didTapButton(_ sender: Any) {
        if studySessionTimer != nil {
            stopTimer() // 타이머 정지
            UIView.animate(withDuration: 0.3) {
                self.tapButton.alpha = 1
            }
        } else {
            view.backgroundColor = UIColor.color6
            UIView.animate(withDuration: 0.3, animations: {
                self.tapButton.alpha = 0.3
            }, completion: { _ in
                self.startTimer() // 타이머 시작
            })
        }
    }
}



