//
//  SwiftyMarkdown+macOS.swift
//  SwiftyMarkdown
//
//  Created by Simon Fairbairn on 17/12/2019.
//  Copyright © 2019 Voyage Travel Apps. All rights reserved.
//

import Foundation
#if os(macOS)
import AppKit

extension SwiftyMarkdown {
	
	func font( for line : SwiftyLine, characterOverride : CharacterStyle? = nil ) -> NSFont {
        font(for: line, characterOverrides: characterOverride == nil ? [] : [characterOverride!])
    }

    func font( for line : SwiftyLine, characterOverrides : [CharacterStyle]) -> NSFont {
		var fontName : String?
		var fontSize : CGFloat?
		
		var globalBold = false
		var globalItalic = false
        var globalUnderline = false
		
		let style : FontProperties
		// What type are we and is there a font name set?
		switch line.lineStyle as! MarkdownLineStyle {
		case .h1:
			style = self.h1
		case .h2:
			style = self.h2
		case .h3:
			style = self.h3
		case .h4:
			style = self.h4
		case .h5:
			style = self.h5
		case .h6:
			style = self.h6
		case .codeblock:
			style = self.code
		case .blockquote:
			style = self.blockquotes
		default:
			style = self.body
		}
		
		fontName = style.fontName
		fontSize = style.fontSize
		switch style.fontStyle {
		case .bold:
			globalBold = true
		case .italic:
			globalItalic = true
        case .underline:
            globalUnderline = true
		case .boldItalic:
			globalItalic = true
			globalBold = true
		case .normal:
			break
		}

		if fontName == nil {
			fontName = body.fontName
		}
		
        for characterOverride in characterOverrides {
			switch characterOverride {
			case .code:
				fontName = code.fontName ?? fontName
				fontSize = code.fontSize
			case .link:
				fontName = link.fontName ?? fontName
				fontSize = link.fontSize
			case .bold:
				fontName = bold.fontName ?? fontName
				fontSize = bold.fontSize
				globalBold = true
			case .italic:
				fontName = italic.fontName ?? fontName
				fontSize = italic.fontSize
				globalItalic = true
            case .underline:
                fontName = underline.fontName ?? fontName
                fontSize = underline.fontSize
                globalUnderline = true
			default:
				break
			}
		}
		
		fontSize = fontSize == 0.0 ? nil : fontSize
		let finalSize : CGFloat
		if let existentFontSize = fontSize {
			finalSize = existentFontSize
		} else {
			finalSize = NSFont.systemFontSize
		}
		var font : NSFont
		if let existentFontName = fontName {
			if let customFont = NSFont(name: existentFontName, size: finalSize)  {
				font = customFont
			} else {
				font = NSFont.systemFont(ofSize: finalSize)
			}
		} else {
			font = NSFont.systemFont(ofSize: finalSize)
		}
		
        if globalItalic, globalBold {
            let boldItalicDescriptor = font.fontDescriptor.withSymbolicTraits([.italic, .bold])
            font = NSFont(descriptor: boldItalicDescriptor, size: 0) ?? font
        } else if globalBold {
            let boldDescriptor = font.fontDescriptor.withSymbolicTraits(.bold)
            font = NSFont(descriptor: boldDescriptor, size: 0) ?? font
        } else if globalItalic {
            let italicDescriptor = font.fontDescriptor.withSymbolicTraits(.italic)
            font = NSFont(descriptor: italicDescriptor, size: 0) ?? font
        }
		
		return font
		
	}
	
	func color( for line : SwiftyLine ) -> NSColor {
		// What type are we and is there a font name set?
		switch line.lineStyle as! MarkdownLineStyle {
		case .h1, .previousH1:
			return h1.color
		case .h2, .previousH2:
			return h2.color
		case .h3:
			return h3.color
		case .h4:
			return h4.color
		case .h5:
			return h5.color
		case .h6:
			return h6.color
		case .body:
			return body.color
		case .codeblock:
			return code.color
		case .blockquote:
			return blockquotes.color
		case .unorderedList, .unorderedListIndentFirstOrder, .unorderedListIndentSecondOrder, .orderedList, .orderedListIndentFirstOrder, .orderedListIndentSecondOrder:
			return body.color
		case .yaml:
			return body.color
		case .referencedLink:
			return body.color
		}
	}
	
}
#endif
