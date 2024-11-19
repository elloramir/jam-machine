-- author: claude AI 2024
-- revised by: Elloramir 2024

local LinkedList = {}
LinkedList.__index = LinkedList

function LinkedList.new()
    local self = setmetatable({}, LinkedList)
    self.head = nil
    self.tail = nil
    self.size = 0
    return self
end

function LinkedList:push_front(value)
    local node = {value = value, next = self.head, prev = nil}
    
    if self.head then
        self.head.prev = node
    else
        self.tail = node
    end
    
    self.head = node
    self.size = self.size + 1
    return self
end

function LinkedList:push_back(value)
    local node = {value = value, next = nil, prev = self.tail}
    
    if self.tail then
        self.tail.next = node
    else
        self.head = node
    end
    
    self.tail = node
    self.size = self.size + 1
    return self
end

function LinkedList:remove(value)
    local current = self.head
    
    while current do
        if current.value == value then
            -- Adjust previous node's next
            if current.prev then
                current.prev.next = current.next
            else
                self.head = current.next
            end
            
            -- Adjust next node's previous
            if current.next then
                current.next.prev = current.prev
            else
                self.tail = current.prev
            end
            
            self.size = self.size - 1
            return true
        end
        current = current.next
    end
    
    return false
end

function LinkedList:iterator()
    return LinkedList.stateless_iter, self, nil
end

function LinkedList.stateless_iter(state, var)
    if not state then return nil end
    
    local current = var and var.next or state.head
    
    if not current then return nil end
    
    return current, current.value
end

function LinkedList:__call(_, value)
    return self:push_front(value)
end

function LinkedList:first()
    return self.head and self.head.value or nil
end

-- Usage example
-- local list = LinkedList.new()
-- list(10)(20)(30)  -- Pushing values

-- Stateless iteration
-- for node, value in list:iterator() do
--     print(value)  -- Prints 30, 20, 10
-- end

return LinkedList