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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextView.delegate = self
        inputContainerView.layer.cornerRadius = 12
        
        setTextViewMaxHeight()
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
