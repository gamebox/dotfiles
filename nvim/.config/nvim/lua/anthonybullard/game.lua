local popup = require("plenary.popup")

local M = {
    config = {
        width = nil,
        height = nil,
        borderchars = nil,
    },
}

---@class TicTacToe
---@field buf integer
---@field win integer
---@field opts table
---@field board string[][]
---@field player string
---@field winner boolean
local TicTacToe = setmetatable({}, M)

---@type TicTacToe|nil
local g = nil
local sep_line = "-----"
local winningPlays = {
    -- Horizontal
    { { 1, 1 }, { 1, 2 }, { 1, 3 } },
    { { 2, 1 }, { 2, 2 }, { 2, 3 } },
    { { 3, 1 }, { 3, 2 }, { 3, 3 } },
    -- Vertical
    { { 1, 1 }, { 2, 1 }, { 3, 1 } },
    { { 1, 2 }, { 2, 2 }, { 3, 2 } },
    { { 1, 3 }, { 2, 3 }, { 3, 3 } },
    -- Diagonal
    { { 1, 1 }, { 2, 2 }, { 3, 3 } },
    { { 3, 1 }, { 2, 2 }, { 1, 3 } },
}

local function new_board()
    return {
        { " ", " ", " " },
        { " ", " ", " " },
        { " ", " ", " " },
    }
end

---Create a new game
---@return TicTacToe
function TicTacToe:new()
    local newTicTacToe = {}
    self.__index = self
    newTicTacToe.board = new_board()
    newTicTacToe.player = "X"
    newTicTacToe.winner = false
    return setmetatable(newTicTacToe, self)
end

function TicTacToe:moveLeft()
    local pos = vim.api.nvim_win_get_cursor(self.win)
    local col = pos[2] + 1
    local newCol = col
    if col == 5 then
        newCol = 3
    elseif col <= 3 then
        newCol = 1
    end
    vim.api.nvim_win_set_cursor(self.win, { pos[1], newCol - 1 })
end

function TicTacToe:moveRight()
    local pos = vim.api.nvim_win_get_cursor(self.win)
    local col = pos[2] + 1
    local newCol = col
    if col == 1 then
        newCol = 3
    elseif col >= 3 then
        newCol = 5
    end
    vim.api.nvim_win_set_cursor(self.win, { pos[1], newCol - 1 })
end

function TicTacToe:moveDown()
    local pos = vim.api.nvim_win_get_cursor(self.win)
    local line = pos[1]
    local newLine = line
    if line == 1 then
        newLine = 3
    elseif line >= 3 then
        newLine = 5
    end
    vim.api.nvim_win_set_cursor(self.win, { newLine, pos[2] })
end

function TicTacToe:moveUp()
    local pos = vim.api.nvim_win_get_cursor(self.win)
    local line = pos[1]
    local newLine = line
    if line == 5 then
        newLine = 3
    elseif line <= 3 then
        newLine = 1
    end
    vim.api.nvim_win_set_cursor(self.win, { newLine, pos[2] })
end

function TicTacToe:setupTicTacToeCommands()
    vim.api.nvim_buf_create_user_command(self.buf, "TicTacToePlay", function()
        if g then
            g:play()
        end
    end, {})
    vim.api.nvim_buf_create_user_command(self.buf, "TicTacToeMoveDown", function()
        if g then
            g:moveDown()
        end
    end, {})
    vim.api.nvim_buf_create_user_command(self.buf, "TicTacToeMoveUp", function()
        if g then
            g:moveUp()
        end
    end, {})
    vim.api.nvim_buf_create_user_command(self.buf, "TicTacToeMoveRight", function()
        if g then
            g:moveRight()
        end
    end, {})
    vim.api.nvim_buf_create_user_command(self.buf, "TicTacToeMoveLeft", function()
        if g then
            g:moveLeft()
        end
    end, {})
    vim.api.nvim_buf_create_user_command(self.buf, "TicTacToeEnd", function()
        if g then
            g:End()
        end
        g = nil
    end, { force = true })
    vim.api.nvim_buf_set_keymap(self.buf, "n", "i", "<Cmd>TicTacToePlay<CR>", {})
    vim.api.nvim_buf_set_keymap(self.buf, "n", "q", "<Cmd>TicTacToeEnd<CR>", {})
    vim.api.nvim_buf_set_keymap(self.buf, "n", "h", "<Cmd>TicTacToeMoveLeft<CR>", {})
    vim.api.nvim_buf_set_keymap(self.buf, "n", "j", "<Cmd>TicTacToeMoveDown<CR>", {})
    vim.api.nvim_buf_set_keymap(self.buf, "n", "k", "<Cmd>TicTacToeMoveUp<CR>", {})
    vim.api.nvim_buf_set_keymap(self.buf, "n", "l", "<Cmd>TicTacToeMoveRight<CR>", {})
end

function TicTacToe:removeTicTacToeCommands()
    vim.api.nvim_buf_del_user_command(self.buf, "TicTacToePlay")
    vim.api.nvim_buf_del_user_command(self.buf, "TicTacToeEnd")
    vim.api.nvim_buf_del_user_command(self.buf, "TicTacToeMoveLeft")
    vim.api.nvim_buf_del_user_command(self.buf, "TicTacToeMoveDown")
    vim.api.nvim_buf_del_user_command(self.buf, "TicTacToeMoveUp")
    vim.api.nvim_buf_del_user_command(self.buf, "TicTacToeMoveRight")
    vim.api.nvim_buf_del_keymap(self.buf, "n", "i")
    vim.api.nvim_buf_del_keymap(self.buf, "n", "q")
    vim.api.nvim_buf_del_keymap(self.buf, "n", "h")
    vim.api.nvim_buf_del_keymap(self.buf, "n", "j")
    vim.api.nvim_buf_del_keymap(self.buf, "n", "k")
    vim.api.nvim_buf_del_keymap(self.buf, "n", "l")
end

function TicTacToe:setupBannerCommands()
    vim.api.nvim_buf_create_user_command(self.buf, "TicTacToeEnd", function()
        if g then
            g:End()
        end
        g = nil
    end, { force = true })
    vim.api.nvim_buf_create_user_command(self.buf, "TicTacToeStartOver", function()
        self:startOver()
    end, {})
    vim.api.nvim_buf_set_keymap(self.buf, "n", "r", "<Cmd>TicTacToeStartOver<CR>", {})
    vim.api.nvim_buf_set_keymap(self.buf, "n", "q", "<Cmd>TicTacToeEnd<CR>", {})
end

function TicTacToe:removeBannerCommands()
    vim.api.nvim_buf_del_user_command(self.buf, "TicTacToeEnd")
    vim.api.nvim_buf_del_user_command(self.buf, "TicTacToeStartOver")
    vim.api.nvim_buf_del_keymap(self.buf, "n", "q")
    vim.api.nvim_buf_del_keymap(self.buf, "n", "r")
end

function TicTacToe:show()
    local width = M.config.width or 5
    local height = M.config.height or 6
    local borderchars = M.config.borderchars or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    self.buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(self.buf, "game-popup")

    local win_id, _ = popup.create(self.buf, {
        title = "TicTacToe",
        highlight = "TicTacToeWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })
    self.win = win_id
    vim.api.nvim_win_set_buf(self.win, self.buf)
    vim.api.nvim_win_set_option(self.win, "number", false)
    vim.api.nvim_win_set_option(self.win, "relativenumber", false)
    vim.api.nvim_buf_set_option(self.buf, "filetype", "game")
    vim.api.nvim_buf_set_option(self.buf, "buftype", "acwrite")
    vim.api.nvim_buf_set_option(self.buf, "bufhidden", "delete")
    self:setupTicTacToeCommands()
    self:render()
end

function TicTacToe:startOver()
    self.board = new_board()
    self.player = "X"
    self.winner = false
    self:removeBannerCommands()
    self:setupTicTacToeCommands()
    self:render()
end

function TicTacToe:render()
    vim.api.nvim_buf_set_lines(self.buf, 0, -1, true, {})
    vim.api.nvim_buf_set_lines(self.buf, 0, 5, false, self:get_lines())
end

function TicTacToe:show_banner()
    vim.api.nvim_buf_set_lines(self.buf, 0, -1, true, {})
    vim.api.nvim_buf_set_lines(self.buf, 0, 1, false, {
        "  " .. self.player .. "  ",
        " WINS",
        "",
        " <R> ",
        "PLAY ",
        "AGAIN",
    })
    self:setupBannerCommands()
end

function TicTacToe:determine_is_winner()
    for _, play in pairs(winningPlays) do
        for i, spot in pairs(play) do
            local line = spot[1]
            local col = spot[2]
            if self.board[line][col] ~= self.player then
                break
            end
            if i == #play then
                self.winner = true
                return
            end
        end
    end
    self.winner = false
end

---@param pos integer
---@return boolean
local function on_separator(pos)
    return pos == 2 or pos == 4
end

---@param pos integer
---@return integer
local function shift_to_board_pos(pos)
    if pos == 3 then
        return 2
    elseif pos == 5 then
        return 3
    end
    return pos
end

function TicTacToe:switch_player()
    if self.player == "X" then
        self.player = "O"
    else
        self.player = "X"
    end
end

function TicTacToe:play()
    if self.winner then
        return
    end
    local pos = vim.api.nvim_win_get_cursor(self.win)
    local line = pos[1]
    local col = pos[2] + 1

    if on_separator(line) or on_separator(col) then
        return
    end

    line = shift_to_board_pos(line)
    col = shift_to_board_pos(col)

    if line > 3 or col > 3 then
        return
    end

    if self.board[line][col] ~= " " then
        return
    end

    self.board[line][col] = self.player

    self:determine_is_winner()

    if self.winner then
        self:show_banner()
        return
    end

    self:switch_player()
    self:render()
end

---Creates the lines to render from the game board
---@return string[]
function TicTacToe:get_lines()
    local lines = {}
    assert(self.board, "No board")
    for i = 1, 3, 1 do
        lines[i] = self.board[i][1] .. "|" .. self.board[i][2] .. "|" .. self.board[i][3]
    end
    table.insert(lines, 2, sep_line)
    table.insert(lines, 4, sep_line)
    table.insert(lines, " <" .. self.player .. "> ")
    return lines
end

---Cleans up the game resources
function TicTacToe:End()
    if vim.api.nvim_win_is_valid(self.win) then
        vim.api.nvim_win_close(self.win, true)
    end
end

---Configures the game and adds the game user command
---@param opts table
local function setup(opts)
    M.opts = opts
    vim.api.nvim_create_user_command("TicTacToeStart", function()
        g = TicTacToe:new()
        assert(g ~= nil, "No game...")
        g:show()
    end, { force = true })
end

return {
    setup = setup,
}
