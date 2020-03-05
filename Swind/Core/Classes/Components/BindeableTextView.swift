//
//  BindeableTextView.swift
//  Swind
//
//  Created by Vladimir Pomsztein on 3/4/20.
//

import UIKit

public class BindeableTextView: UITextView, UITextViewDelegate {

    public var onTextChange: ((String) -> Void)? = nil
    public var bindeeSelector: Selector?
    public var bindee: NSObject?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    public func bind(_ bindee: NSObject, _ bindeeSelector: Selector) {
        self.bindee = bindee
        self.bindeeSelector = bindeeSelector
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.onTextChange?(textView.text)
        self.bindee?.perform(self.bindeeSelector, with: textView.text ?? "")
    }

}
