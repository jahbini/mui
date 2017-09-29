m = require 'mithril'
s = require 'mss-js'
u = require '../src/utils.coffee'
style = require '../src/style.coffee'


arrowRight = require 'mmsvg/google/msvg/hardware/keyboard-arrow-right'
arrowDown = require 'mmsvg/google/msvg/hardware/keyboard-arrow-down'

class Collapse
    constructor: ({
        @titleArray                # [String]
    ,   @widgetArray               # [mithril widget]
    ,   @autoCollapse = false      # Boolean
    ,   @expandedIndexArray = []   # [Int]
    ,   @onExpand   = u.noOp       # Int -> a
    ,   @onCollapse = u.noOp       # Int -> a
    }) ->
        @showWidget = false # Boolean

    onFoldInternal: (e) =>
        i = parseInt (u.getCurrentTargetData e, 'index')
        if @autoCollapse
            if (j = @expandedIndexArray[0])?
                @onCollapse j
            @expandedIndexArray = [i]
            @onExpand i

        else if i in @expandedIndexArray
            u.removeFromArray @expandedIndexArray, i
            @onCollapse i
        else
            @expandedIndexArray.push i
            @onExpand i

    view: ->
        self = @
        m '.Collapse',
            for title, i in @titleArray
                expanded = i in @expandedIndexArray
                [
                    m '.CollapseTitle'
                    ,
                        key: 'title' + i
                        'data-index': i.toString()
                        onclick: @onFoldInternal
                    ,
                        if expanded then u.svg arrowDown else u.svg arrowRight
                        m 'span', title

                    m '.CollapseBody'
                    ,
                        className: if expanded then 'Current' else ''
                        key: 'body' + i
                        onclick: @onFoldInternal
                    ,    if expanded then @widgetArray[i].view()
                ]

Collapse.mss =
    Collapse:
        CollapseTitle: s.LineSize('2em', '1em')
            color: style.text[8]
            background: style.main[4]
            border: '1px solid ' + style.main[4]
            padding: '0 0.4em'
            $hover:
                cursor: 'pointer'
            svg:
                fill: style.text[8]
                height: '1.4em'
                width: '1.4em'
                padding: '0.3em'
                verticalAlign: 'middle'
            span:
                verticalAlign: 'middle'

        CollapseBody:
            border: '1px solid ' + style.border[4]
            borderTop: 'none'

module.exports = Collapse
