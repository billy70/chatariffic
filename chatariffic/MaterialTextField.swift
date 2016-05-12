//
//  MaterialTextField.swift
//  chatariffic
//
//  Created by William L. Marr III on 5/12/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
    }
    
    // For the placeholder text.
    // The default position for the text is right up against the left side
    // of the text box - this will push the text to the right by 10 points.
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    // For the editable text.
    // Push the text 10 points to the right.
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
}
