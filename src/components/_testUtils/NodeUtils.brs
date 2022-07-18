' @import /components/_testUtils/getProperty.brs

' Node utils.
' @class
function NodeUtils() as Object
prototype = {}

' Checks if nodes are the same by checking their reference.
' @param {Node} node1
' @param {Node} node2
' @returns {Boolean}
prototype.areNodesTheSame = function (node1 as Object, node2 as Object) as Boolean
    if (node1 <> Invalid)
    return node1.isSameNode(node2)
    end if

    return (node2 = Invalid)
end function

' Finds child of a node by id.
' Warning:
' Preferred way of referencing child node is to use native findNode method.
' Unfortunatelly Node and ContentNode can't be referenced by native method (roku bug in RokuOS 9.1 and earlier).
' The only possible way is to iterate through children and find correct node.
' More details https://forums.roku.com/viewtopic.php?f=34&t=104187&sid=c734efdb811d220cd0716ca191f79e35
' @param {Node} node
' @param {String} id
' @returns {Dynamic} - Returns Invalid when node is not found.
prototype.findChildById = function (node as Object, id as String) as Dynamic
    return m.findChildByProperty(node, "id", id)
end function

' Finds child node by given property value.
' @example
' ' Given node = <Node><Node user="{ isAdmin: true }"></Node></Node>
' NodeUtils().findChildByProperty(node, "user.isAdmin", true) ' Returns the first child
' @param {Node} node
' @param {String} propertyPath - It can be nested object.
' @param {Dynamic} value - The value that should match the searched value.
' @returns {Dynamic} - Returns Invalid when node is not found.
prototype.findChildByProperty = function (node as Object, propertyPath as String, value as Dynamic) as Dynamic
    childIndex = m.findChildIndexByProperty(node, propertyPath, value)

    if (childIndex = Invalid)
    return Invalid
    end if

    return node.getChild(childIndex)
end function

' Finds child node index by given property value.
' @example
' ' Given node = <Node><Node user="{ isAdmin: true }"></Node></Node>
' NodeUtils().findChildIndexByProperty(node, "user.isAdmin", true) ' Returns index 0
' @param {Node} node
' @param {String} propertyPath - It can be nested object.
' @param {Dynamic} value - The value that should match the searched value.
' @returns {Dynamic} - Returns Invalid when node is not found.
prototype.findChildIndexByProperty = function (node as Object, propertyPath as String, value as Dynamic) as Dynamic
    indexVector = m.findChildIndexVectorByProperty(node, propertyPath, value)
    if (indexVector <> Invalid)
    return indexVector[0]
    end if

    return Invalid
end function

' Finds child node vector by given property value.
' @example
' ' Given
' ' <Node>
' '  <Node>
' '   <Node></Node>
' '   <Node user="{ isAdmin: true }"></Node>
' '  </Node>
' ' </Node>
' NodeUtils().findChildIndexVectorByProperty(node, "user.isAdmin", true, 2) ' Returns [0][1]
' @param {Node} node
' @param {String} propertyPath - It can be nested object.
' @param {Dynamic} value - The value that should match the searched value.
' @param {Integer} [depth=1] - How deep the function should search.
' @returns {Dynamic} - Returns Invalid when node is not found.
prototype.findChildIndexVectorByProperty = function (node as Object, propertyPath as String, value as Dynamic, depth = 1 as Integer) as Dynamic
    nodeLength = node.getChildCount()
    if (nodeLength = 0)
    return Invalid
    end if

    for i = 0 to nodeLength - 1
    child = node.getChild(i)
    if (depth = 1)
        if (getProperty(child, propertyPath) = value)
        return [i]
        end if
    else
        deeperIndex = m.findChildIndexVectorByProperty(child, propertyPath, value, depth - 1)
        if (deeperIndex <> Invalid)
        index = [i]
        index.append(deeperIndex)

        return index
        end if
    end if
    end for

    return Invalid
end function

return prototype
end function
  