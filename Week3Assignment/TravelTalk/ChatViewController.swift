//
//  ChatViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/18/25.
//

import UIKit
import IQKeyboardManagerSwift

class ChatViewController: UIViewController, Identifying {

    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var inputContainerView: UIView!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var inputTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var inputButton: UIButton!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var inputConatainverViewBottomConstraint: NSLayoutConstraint!
    
    private var textViewMaxHeight: CGFloat = 0
    private let textViewPlaceholderText = "메세지를\u{00A0}입력하세요."
    private var initialBottomConstraintConstant: CGFloat = 0
    
    private let chatRoom: ChatRoom
    private let me = ChatList.me
    
    init(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
        super.init()
    }
    
    init?(coder: NSCoder, chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureInputTextView()
        configureTableView()
        configureNavigationItemTitle()
        
        configureNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        chatTableView.layer.addBorder([.top], color: .lightGray, width: 0.5)
        scrollToLastRow()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureInputTextView() {
        inputTextView.delegate = self
        inputTextView.text = textViewPlaceholderText
        inputContainerView.layer.cornerRadius = 12
        
        setTextViewMaxHeight()
        initialBottomConstraintConstant = inputConatainverViewBottomConstraint.constant
    }
    
    private func configureTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.separatorStyle = .none
        
        let recievedCellXib = UINib(nibName: ReceivedMessageTableViewCell.identifier, bundle: nil)
        chatTableView.register(recievedCellXib, forCellReuseIdentifier: ReceivedMessageTableViewCell.identifier)
        let sendCellXib = UINib(nibName: SendMessageTableViewCell.identifier, bundle: nil)
        chatTableView.register(sendCellXib, forCellReuseIdentifier: SendMessageTableViewCell.identifier)
    }
    
    private func configureNavigationItemTitle() {
        navigationItem.title = chatRoom.chatroomName
    }

    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Notification Handlers
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        let safeOffset = keyboardHeight - tabBarHeight
        
        
        updateBottomConstraint(with: safeOffset, animationDuration: animationDuration)
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        updateBottomConstraint(animationDuration: animationDuration)
    }
    
    private func updateBottomConstraint(with constant: CGFloat = 0.0, animationDuration: TimeInterval) {
        inputConatainverViewBottomConstraint.constant = initialBottomConstraintConstant + constant
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: TextView
extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = inputTextView.sizeThatFits(CGSize(width: inputTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        inputTextViewHeightConstraint.constant = min(size.height, textViewMaxHeight)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceholderText
            textView.textColor = .systemGray
        }
    }
    
    private func setTextViewMaxHeight() {
        let maxLines = 3
        let attributedText = NSAttributedString(string: String(repeating: "\n", count: maxLines), attributes: [.font: inputTextView.font ?? UIFont.systemFont(ofSize: 12)])
        let boundingRect = attributedText.boundingRect(with: CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        textViewMaxHeight = ceil(boundingRect.height)
    }
}

// MARK: TableView
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoom.chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = chatRoom.chatList[indexPath.row]
        if row.user == me {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SendMessageTableViewCell.self)
            cell.configureData(with: row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ReceivedMessageTableViewCell.self)
            cell.configureData(with: row)
            return cell
        }
    }
    
    private func scrollToLastRow() {
        let index = IndexPath(row: chatRoom.chatList.count - 1, section: 0)
        chatTableView.scrollToRow(at: index, at: .bottom, animated: false)
    }
}
