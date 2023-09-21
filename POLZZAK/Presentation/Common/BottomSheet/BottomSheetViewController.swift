//
//  BottomSheetViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/16.
//

import UIKit

class BottomSheetViewController: UIViewController, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate {
    private var initialDragHandlePosition: CGFloat = 0
    private let statusBarHeight = UIApplication.shared.statusBarHeight
    private lazy var initialState: BottomSheetState = .short(height: initialHeight)
    
    var initialHeight: CGFloat {
        return self.view.frame.height / 4
    }
    
    private let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let dragHandleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let dragHandle: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(dragHandleView)
        
        dragHandleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(124)
            $0.height.equalTo(28)
        }
        
        dragHandleView.addSubview(dragHandle)
        
        dragHandle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
        }

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        dragHandleView.addGestureRecognizer(gesture)
    }

    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting, initialState: initialState)
    }

    func changeState(to endPosition: CGFloat) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            switch endPosition {
            case ...(self.initialState.position - 100):
                self.view.frame.origin.y = BottomSheetState.full.position
                self.view.frame.size.height = BottomSheetState.full.height
            case (self.initialState.position - 100)...(self.initialState.position + 100):
                self.view.frame.origin.y = self.initialState.position
                self.view.frame.size.height = self.initialState.height
            case (self.initialState.position + 100)...:
                dismiss(animated: true)
            default:
                return
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            initialDragHandlePosition = view.frame.minY
        case .changed:
            initialDragHandlePosition += translation.y
            view.frame.size.height -= translation.y
            view.frame.origin.y = initialDragHandlePosition
        case .ended:
            let endPosition = view.frame.minY
            changeState(to: endPosition)
        default:
            break
        }
        gesture.setTranslation(.zero, in: view)
    }
}
