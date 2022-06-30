//
//  ViewController.swift
//  HSDC
//
//  Created by hsudev on 2022/06/17.
//

import UIKit

class ViewController: UIViewController {
    
    /* UI Components */
    private lazy var scrollView = UIScrollView() // 위 아래 스크롤 뷰
    private lazy var contentView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var profileImageView = UIImageView()
    private lazy var weekStackView = UIStackView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    /* Calendar property*/
    private let calendar = Calendar.current // Calendar 구조체를 사용하기 위해 사용자의 현재 달력으로 초기화 해놓은 프로퍼티
    private let dateFormatter = DateFormatter() // 2022년 01월 과 같은 형태로 타이틀 만들기 위한 DateFormatter
    private var calendarDate = Date() // 달력에 표시될 날짜 저장
    private var days = [String]() // 달력에 날짜 표시하기 위한 String 배열 ex) 1일이 화요일 부터 시작 된다면 ["","","1","2"...]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.configure()
    }
    
    /* UI Components Method */
    private func configure(){
        
        self.configureScrollView()
        self.configureContentView()
        self.configureTitleLabel()
        self.configureWeekStackView()
        self.configureWeekLabel()
        self.configureCollectionView()
        self.configureCalendar()
        self.configureProfileImageView()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action:#selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.contentView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.contentView.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer){
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            
            switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.left:
                    plusMonth()
                    break
                case UISwipeGestureRecognizer.Direction.right:
                    minusMonth()
                    break
                default:
                    break
            }
        }
    }
    private func configureScrollView(){
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    
    private func configureContentView(){
        self.scrollView.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    private func configureProfileImageView() {
  
    }
    
    
    
    private func configureTitleLabel(){
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.text = "2022년 1월"
        self.titleLabel.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:25),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant:80)
        ])
        
    }
    
    private func configureWeekStackView(){
        self.contentView.addSubview(self.weekStackView)
        self.weekStackView.distribution = .fillEqually
        self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.weekStackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant:40),
            self.weekStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant:5),
            self.weekStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -5)
        ])
    }
    
    private func configureWeekLabel(){
        let dayOfTheWeek = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            label.textAlignment = .center
            label.font = .monospacedSystemFont(ofSize: 12, weight: .bold)
            self.weekStackView.addArrangedSubview(label)
            
            if i == 0 {
                label.textColor = .systemRed
            }
        }
    }
    
    private func configureCollectionView(){
        self.contentView.addSubview(self.collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant:10),
            self.collectionView.leadingAnchor.constraint(equalTo: self.weekStackView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.weekStackView.trailingAnchor),
            self.collectionView.heightAnchor.constraint(equalTo: self.collectionView.widthAnchor, multiplier: 1.5), //이거 잘 모르겠다
            self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    /* Calendar Method */
    private func configureCalendar(){ // 달력을 표시해 주기 위해 calendarDate와 dateFormmatter 초기화
        
        let components = self.calendar.dateComponents([.year, .month], from:Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.updateCalendar()
    }
    
    private func startDayOfTheWeek()->Int{ //calendarDate가 해당하는 달의 1일이 시작되는 요일을 리턴
        return self.calendar.component(.weekday, from: self.calendarDate) - 1
    }
    
    private func endDate() -> Int { // calendarDate가 해당하는 달의 날짜 개수 리턴
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int() // calendarDate가 해당하는 달의 날짜가 며칠까지 있는지 계산하여 반환
    }
    
    private func updateTitle(){ // titleLabel에 년,월 업데이트
        let date = self.dateFormatter.string(from: self.calendarDate) // dateFormmater를 이용하여 calendarDate를 설정해놓은 포맷으로 만들어준 후 타이틀에 적용시킴
        self.titleLabel.text = date
    }
    
    private func updateDays() { // startDayOfTheWeek()과 endDate()를 이용하여 days에 String 배열 만들어 넣기
        self.days.removeAll() // 이전 데이터 삭제
        let startDayOfTheWeek = self.startDayOfTheWeek() // 요일의 시작 인덱스 저장
        let totalDays = startDayOfTheWeek + self.endDate() // 시작 인덱스 + 날짜 개수
        
        for day in Int()..<totalDays {
            if day < startDayOfTheWeek {
                self.days.append(" ")
                continue
            }
            self.days.append("\(day - startDayOfTheWeek + 1)")
        }
        self.collectionView.reloadData()
    }
    
    private func updateCalendar() { // 달력을 처음 띄우거나 달을 이동할 때 마다 updateTitle(), updateDate() 호출
        self.updateTitle()
        self.updateDays()
    }
    
    private func minusMonth() { // calendarDate의 달을 이전 달로 변경
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month:-1), to: self.calendarDate) ?? Date()
        self.updateCalendar()
    }
    
    private func plusMonth() { // calendarDate의 달을 다음 달로 변경
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: 1), to: self.calendarDate) ?? Date()
        self.updateCalendar()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.update(day: self.days[indexPath.item])
        cell.layer.addBorder([.top], color: UIColor.lightGray, width: 1.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.weekStackView.frame.width / 7
        return CGSize(width:width,height:width*1.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    
}


