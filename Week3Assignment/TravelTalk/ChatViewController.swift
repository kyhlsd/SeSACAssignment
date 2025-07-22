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
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var inputConatainverViewBottomConstraint: NSLayoutConstraint!
    
    private lazy var textViewMaxHeight: CGFloat = getTextViewMaxHeight(maxLines: 3)
    private let textViewPlaceholderText = "메세지를\u{00A0}입력하세요."
    private lazy var initialBottomConstraintConstant: CGFloat = inputConatainverViewBottomConstraint.constant
    
    private let chatRoomId: Int
    private var chatListManager: ChatListManager
    private let me = ChatList.me
    
    init(chatRoomId: Int) {
        self.chatRoomId = chatRoomId
        self.chatListManager = ChatListManager(chatRoomId: chatRoomId)
        super.init()
    }
    
    init?(coder: NSCoder, chatRoomId: Int) {
        self.chatRoomId = chatRoomId
        self.chatListManager = ChatListManager(chatRoomId: chatRoomId)
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
    }
    
    private func configureTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.separatorStyle = .none
        
        chatTableView.register(cellType: ReceivedMessageTableViewCell.self)
        chatTableView.register(cellType: SendMessageTableViewCell.self)
        chatTableView.register(cellType: NewDateReceivedMessageTableViewCell.self)
        chatTableView.register(cellType: NewDateSendMessageTableViewCell.self)
    }
    
    private func configureNavigationItemTitle() {
        if let index = ChatList.list.firstIndex(where: { chatRoom in
            chatRoom.chatroomId == chatRoomId
        }) {
            navigationItem.title = ChatList.list[index].chatroomName
        }
    }

    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if inputTextView.text != textViewPlaceholderText, !inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let date = DateStringFormatter.yyyyMMddHHmmDashFormatter.string(from: Date())
            let chat = Chat(user: me, date: date, message: inputTextView.text)
            
            chatListManager.chatList.append(chat)
            chatTableView.reloadData()
            inputTextView.text = ""
        }
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
    
    private func getTextViewMaxHeight(maxLines: Int) -> CGFloat {
        let attributedText = NSAttributedString(string: String(repeating: "\n", count: maxLines), attributes: [.font: inputTextView.font ?? UIFont.systemFont(ofSize: 12)])
        let boundingRect = attributedText.boundingRect(with: CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(boundingRect.height)
    }
}

// MARK: TableView
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListManager.chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = chatListManager.chatList[indexPath.row]
       
        if row.user == me { // 내가 보낸 메세지
            if isNewDate(index: indexPath.row) { // 날짜가 바뀌었을 때
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NewDateSendMessageTableViewCell.self)
                cell.configureData(with: row)
                return cell
            } else { // 날짜가 그대로일 때
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SendMessageTableViewCell.self)
                cell.configureData(with: row)
                return cell
            }
        } else { // 다른 사람이 보낸 메세지
            if isNewDate(index: indexPath.row) { // 날짜가 바뀌었을 때
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NewDateReceivedMessageTableViewCell.self)
                cell.configureData(with: row)
                return cell
            } else { // 날짜가 그대로일 때
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ReceivedMessageTableViewCell.self)
                cell.configureData(with: row)
                return cell
            }
        }
    }
    
    private func isNewDate(index: Int) -> Bool {
        if index == 0 { return true }
        
        let formatter = DateStringFormatter.yyyyMMddHHmmDashFormatter
        let prevDate = formatter.date(from: chatListManager.chatList[index - 1].date)
        let nowDate = formatter.date(from: chatListManager.chatList[index].date)
        
        guard let prevDate, let nowDate else { return false }
        
        let calendar = Calendar.current
        return !calendar.isDate(prevDate, inSameDayAs: nowDate)
    }
    
    private func scrollToLastRow() {
        if !chatListManager.chatList.isEmpty {
            let index = IndexPath(row: chatListManager.chatList.count - 1, section: 0)
            chatTableView.scrollToRow(at: index, at: .bottom, animated: false)
        }
    }
}

// MARK: Update Bottom Constraint when Keyboard Shows/Hides
extension ChatViewController: UpdateBottomConstraintProtocol {
    // MARK: Notification Handlers
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        let safeOffset = keyboardHeight - tabBarHeight
        
        
        updateBottomConstraint(with: safeOffset, animationDuration: animationDuration)
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        updateBottomConstraint(animationDuration: animationDuration)
    }
    
    func updateBottomConstraint(with constant: CGFloat = 0.0, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            self.inputConatainverViewBottomConstraint.constant = self.initialBottomConstraintConstant + constant
        }
    }
}
