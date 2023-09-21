//
//  GiftDueSelectViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/12.
//

import Combine
import UIKit

import CombineCocoa
import FSCalendar
import SnapKit

final class GiftDueSelectViewController: UIViewController {
    enum Constants {
        static let basicInset: CGFloat = 16
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "선물 예정일 설정"
        label.textAlignment = .center
        label.textColor = .gray800
        label.font = .subtitle16Sbd
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 11
        return stackView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray300
        button.layer.cornerRadius = 8
        let title = NSAttributedString(
            string: "닫기",
            attributes: [
            .font: UIFont.subtitle16Sbd,
            .foregroundColor: UIColor.white
        ])
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.attributedTitle = .init("설정 완료", attributes: .init([
            .font: UIFont.subtitle16Sbd,
            .foregroundColor: UIColor.white
        ]))
        button.configuration = config
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .disabled:
                button.configuration?.background.backgroundColor = .gray300
            default:
                button.configuration?.background.backgroundColor = .blue500
            }
        }
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Calendar Related
    
    private let calendarHeaderView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let calendarLeftButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "calendar_left")
        var config = UIButton.Configuration.plain()
        config.image = image
        button.configuration = config
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .disabled:
                button.configuration?.baseForegroundColor = .gray300
            default:
                button.configuration?.baseForegroundColor = .gray700
            }
        }
        button.isEnabled = false
        return button
    }()
    
    private let calendarRightButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "calendar_right")
        var config = UIButton.Configuration.plain()
        config.image = image
        button.configuration = config
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .disabled:
                button.configuration?.baseForegroundColor = .gray300
            default:
                button.configuration?.baseForegroundColor = .gray700
            }
        }
        return button
    }()
    
    private let calendarHeaderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년 9월"
        label.textAlignment = .center
        label.textColor = .gray800
        label.font = .subtitle16Sbd
        return label
    }()
    
    private let calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.scrollEnabled = false
        calendar.placeholderType = .none
        calendar.headerHeight = 0
        // 요일 UI 설정
        calendar.appearance.weekdayFont = .body13Md
        calendar.appearance.weekdayTextColor = .gray500
        // 날짜 UI 설정
        calendar.appearance.titleTodayColor = .blue600
        calendar.appearance.titleDefaultColor = .gray800
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.selectionColor = .blue500
        calendar.appearance.titlePlaceholderColor = .gray400
        calendar.appearance.titleFont = .body13Md
        calendar.appearance.todayColor = .white
        return calendar
    }()
    
    private lazy var titleDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월"
        return dateFormatter
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "dd"
        return dateFormatter
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCalendarHeaderLayout()
        configureLayout()
        configureBinding()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        calendarView.dataSource = self
        calendarView.delegate = self
    }
    
    private func configureLayout() {
        
        // MARK: -
        
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
            make.height.equalTo(460)
        }
        
        // MARK: -
        
        [cancelButton, confirmButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        // MARK: -
        
        let calendarContainerView = UIView()
        calendarContainerView.addSubview(calendarView)
        
        calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalToSuperview().inset(30)
        }
        
        // MARK: -
        
        [titleLabel, separator, calendarHeaderView, calendarContainerView, buttonStackView].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(62)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        calendarHeaderView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.height.equalTo(75)
            make.centerX.equalToSuperview()
        }
        
        calendarContainerView.snp.makeConstraints { make in
            make.top.equalTo(calendarHeaderView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview().inset(Constants.basicInset)
            make.height.equalTo(50)
        }
    }
    
    private func configureCalendarHeaderLayout() {
        [calendarLeftButton, calendarHeaderTitleLabel, calendarRightButton].forEach {
            calendarHeaderView.addArrangedSubview($0)
        }
        
        calendarLeftButton.snp.makeConstraints { make in
            make.width.height.equalTo(12)
        }
        
        calendarRightButton.snp.makeConstraints { make in
            make.width.height.equalTo(12)
        }
        
        calendarHeaderTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
    }
    
    private func configureBinding() {
        calendarLeftButton.tapPublisher
            .sink { [weak self] in
                self?.setCurrentPage(increase: false)
            }
            .store(in: &cancellables)
        
        calendarRightButton.tapPublisher
            .sink { [weak self] in
                self?.setCurrentPage(increase: true)
            }
            .store(in: &cancellables)
        
        cancelButton.tapPublisher
            .sink { [weak self] in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - FSCalendar

extension GiftDueSelectViewController: FSCalendarDataSource, FSCalendarDelegate {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    private func setCurrentPage(increase: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = increase ? 1 : -1
        guard let dateChanged = calendar.date(byAdding: dateComponents, to: calendarView.currentPage) else { return }
        calendarView.setCurrentPage(dateChanged, animated: true)
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarHeaderTitleLabel.text = titleDateFormatter.string(from: calendar.currentPage)
        
        let c = Calendar.current
        let currentMonth = c.component(.month, from: Date())
        let calendarMonth = c.component(.month, from: calendar.currentPage)
        calendarLeftButton.isEnabled = currentMonth != calendarMonth
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("💀", dateFormatter.string(from: date))
    }
}
