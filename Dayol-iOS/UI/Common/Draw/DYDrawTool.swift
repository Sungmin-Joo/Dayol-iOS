//
//  DYDrawTool.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/28.
//

import PencilKit

private enum Design {
    static let defaultPenWidth: CGFloat = 6
}

protocol DYCanvasTool {
    var pkTool: PKTool { get }
}

protocol DYDrawTool: DYCanvasTool {
    var color: UIColor { get }
    var width: CGFloat { get }
}

struct DYPenTool: DYDrawTool {
    let color: UIColor
    let width: CGFloat

    var pkTool: PKTool {
        if #available(iOS 14.0, *) {
            let ink = PKInk(.pen, color: color)
            return PKInkingTool(ink: ink, width: width)
        } else {
            return PKInkingTool(.pen, color: color, width: width)
        }
    }
}

struct DYMarkerTool: DYDrawTool {
    let color: UIColor
    let width: CGFloat

    var pkTool: PKTool {
        if #available(iOS 14.0, *) {
            let ink = PKInk(.marker, color: color)
            return PKInkingTool(ink: ink, width: width)
        } else {
            return PKInkingTool(.marker, color: color, width: width)
        }
    }
}

struct DYPencilTool: DYDrawTool {
    let color: UIColor
    let width: CGFloat

    var pkTool: PKTool {
        if #available(iOS 14.0, *) {
            let ink = PKInk(.pencil, color: color)
            return PKInkingTool(ink: ink, width: width)
        } else {
            return PKInkingTool(.pencil, color: color, width: width)
        }
    }
}

struct DYEraseTool: DYCanvasTool {
    let isObjectErase: Bool

    var pkTool: PKTool {
        let eraseType: PKEraserTool.EraserType = isObjectErase ? .vector : .bitmap
        return PKEraserTool(eraseType)
    }

}

struct DYLassoTool: DYCanvasTool {
    var pkTool: PKTool {
        return PKLassoTool()
    }
}

struct DYCanvasTools {
    enum ToolType {
        case pen, marker, pencil, erase, lasso
    }
    var pen = DYPenTool(color: .black, width: Design.defaultPenWidth)
    var marker = DYMarkerTool(color: .black, width: Design.defaultPenWidth)
    var pencil = DYPencilTool(color: .black, width: Design.defaultPenWidth)
    var erase = DYEraseTool(isObjectErase: false)
    var lasso = DYLassoTool()

    private(set) var selectedTool: DYCanvasTool

    init() {
        self.selectedTool = pen
    }

    mutating func select(tool: ToolType) {
        switch tool {
        case .pen:
            selectedTool = pen
        case .marker:
            selectedTool = marker
        case .pencil:
            selectedTool = pencil
        case .erase:
            selectedTool = erase
        case .lasso:
            selectedTool = lasso
        }
    }
}
