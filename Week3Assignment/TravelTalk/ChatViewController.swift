//
//  ChatViewController.swift
//  Week3Assignment
//
//  Created by 김영훈 on 7/18/25.
//

import UIKit

class ChatViewController: UIViewController, Identifying {

    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var inputContainerView: UIView!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var inputTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var inputButton: UIButton!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    private var textViewMaxHeight: CGFloat = 0
    
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

        inputTextView.delegate = self
        inputContainerView.layer.cornerRadius = 12
        
        setTextViewMaxHeight()
        configureTableView()
        configureNavigationItemTitle()
    }
    
    override func viewDidLayoutSubviews() {
        chatTableView.layer.addBorder([.top], color: .lightGray, width: 0.5)
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

    private func setTextViewMaxHeight() {
        let maxLines = 3
        let attributedText = NSAttributedString(string: String(repeating: "\n", count: maxLines), attributes: [.font: inputTextView.font ?? UIFont.systemFont(ofSize: 12)])
        let boundingRect = attributedText.boundingRect(with: CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        textViewMaxHeight = ceil(boundingRect.height)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = inputTextView.sizeThatFits(CGSize(width: inputTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        inputTextViewHeightConstraint.constant = min(size.height, textViewMaxHeight)
    }
}

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
}
