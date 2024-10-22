
import UIKit

class GrassGraphViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var studySessions: [StudySession] = []
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupStudySessions()
        collectionView.reloadData()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .color1
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GrassCell.self, forCellWithReuseIdentifier: "grassCell")
        
        view.addSubview(collectionView)
    }

    func setupStudySessions() {
        let calendar = Calendar.current
        for dayOffset in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) {
                let duration = Int.random(in: 0...120) // 0~120분 랜덤 시간
                studySessions.append(StudySession(date: date, duration: duration))
            }
        }
    }

    // UICollectionViewDataSource 메서드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return studySessions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "grassCell", for: indexPath) as! GrassCell
        
        let studySession = studySessions[indexPath.item]
        
        // 공부한 양에 따라 셀 배경색 설정
        let color: UIColor
        switch studySession.duration {
        case 0:
            color = .lightGray
        case 1...30:
            color = UIColor(named: "color6") ?? .color6
        case 31...60:
            color = UIColor(named: "color7") ?? .color7
        case 61...:
            color = UIColor(named: "color8") ?? .color8
        default:
            color = .color8
        }
        cell.backgroundColor = color
        
        // 셀에 날짜 라벨 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        cell.dateLabel.text = dateFormatter.string(from: studySession.date)
        
        return cell
    }
}

// 커스텀 셀 클래스
class GrassCell: UICollectionViewCell {
    let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 날짜 레이블 설정
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .black
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GrassGraphViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 셀 크기 설정: 컬렉션 뷰의 전체 너비에서 7등분
        let width = collectionView.bounds.width / 7
        return CGSize(width: width, height: 30) // 세로 크기는 30
    }
}
