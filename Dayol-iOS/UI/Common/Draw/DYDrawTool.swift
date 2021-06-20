//
//  DYDrawTool.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/28.
//

import PencilKit

// 여기를 다 개별 struct로 변경하고
// pkTool 리턴하도록

protocol DYDrawTool {
    var pkTool: PKTool { get }
}

struct DYPencilTool: DYDrawTool {
    let color: UIColor
    let isHighlighter: Bool

    var pkTool: PKTool {
        let inkingType: PKInkingTool.InkType = isHighlighter ? .marker : .pen
        return PKInkingTool(inkingType, color: color, width: 3.0)
    }

}

struct DYEraseTool: DYDrawTool {
    let isObjectErase: Bool

    var pkTool: PKTool {
        let eraseType: PKEraserTool.EraserType = isObjectErase ? .vector : .bitmap
        return PKEraserTool(eraseType)
    }

}

struct DYLassoTool: DYDrawTool {
    var pkTool: PKTool {
        return PKLassoTool()
    }
}
