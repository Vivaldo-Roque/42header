local M = {}

local asciiart = {
    "        :::      ::::::::",
    "      :+:      :+:    :+:",
    "    +:+ +:+         +:+  ",
    "  +#+  +:+       +#+     ",
    "+#+#+#+#+#+   +#+        ",
    "     #+#    #+#          ",
    "    ###   ########.fr    "
}

local start = '/*'
local end_ = '*/'
local fill = '*'
local length = 80
local margin = 5

local types = {
    ['(%.c|%.h|%.cc|%.hh|%.cpp|%.hpp|%.tpp|%.ipp|%.cxx|%.go|%.rs|%.php|%.java|%.kt|%.kts)$'] = {'/*', '*/', '*'},
    ['(%.htm|%.html|%.xml)$'] = {'<!--', '-->', '*'},
    ['(%.js|%.ts)$'] = {'//', '//', '*'},
    ['(%.tex)$'] = {'%', '%', '*'},
    ['(%.ml|%.mli|%.mll|%.mly)$'] = {'(*', '*)', '*'},
    ['(%.vim|vimrc)$'] = {'"', '"', '*'},
    ['(%.el|emacs|%.asm)$'] = {';', ';', '*'},
    ['(%.f90|%.f95|%.f03|%.f|%.for)$'] = {'!', '!', '/'},
    ['(%.lua)$'] = {'', '', '*'},
    ['(%.py)$'] = {'#', '#', '*'}
}

local function filetype()
    local f = vim.fn.expand('%:t')
    start = '/*'
    end_ = '*/'
    fill = '*'
    for pattern, vals in pairs(types) do
        if f:match(pattern) then
            start = vals[1]
            end_ = vals[2]
            fill = vals[3]
            break
        end
    end
end

local function ascii(n)
    return asciiart[n - 2]  -- adjust index since lua is 1-based, but n starts from 3?
end

local function textline(left, right)
    left = left:sub(1, length - margin * 2 - #right)
    local spaces = length - margin * 2 - #left - #right
    if spaces < 0 then spaces = 0 end
    return start .. string.rep(' ', margin - #start) .. left .. string.rep(' ', spaces) .. right .. string.rep(' ', margin - #end_) .. end_
end

local function date()
    return os.date("%Y/%m/%d %H:%M:%S")
end

local function user()
    if vim.g.user42 then
        return vim.g.user42
    end
    local u = vim.env.USER or "marvin"
    return u
end

local function mail()
    if vim.g.mail42 then
        return vim.g.mail42
    end
    local m = vim.env.MAIL or "marvin@42.fr"
    return m
end

local function filename()
    local f = vim.fn.expand('%:t')
    if #f == 0 then
        return "< new >"
    end
    return f
end

local function line(n)
    if n == 1 or n == 11 then
        return start .. ' ' .. string.rep(fill, length - #start - #end_ - 2) .. ' ' .. end_
    elseif n == 2 or n == 10 then
        return textline('', '')
    elseif n == 3 or n == 5 or n == 7 then
        return textline('', ascii(n))
    elseif n == 4 then
        return textline(filename(), ascii(n))
    elseif n == 6 then
        return textline("By: " .. user() .. " <" .. mail() .. ">", ascii(n))
    elseif n == 8 then
        return textline("Created: " .. date() .. " by " .. user(), ascii(n))
    elseif n == 9 then
        return textline("Updated: " .. date() .. " by " .. user(), ascii(n))
    end
end

local function insert()
    vim.api.nvim_buf_set_lines(0, 0, 0, false, {""})
    for i = 11, 1, -1 do
        vim.api.nvim_buf_set_lines(0, 0, 0, false, {line(i)})
    end
end

local function not_rebasing()
    local cmd = "ls `git rev-parse --git-dir 2>/dev/null` 2>/dev/null | grep -c rebase"
    local result = vim.fn.system(cmd):gsub("%s+", "")
    return result == "0"
end

local function update()
    filetype()
    if not vim.fn.getline(1):match('^' .. vim.pesc(start)) then
        return true
    end
    if vim.fn.line('$') < 9 then return true end
    local check = start .. string.rep(' ', margin - #start) .. "Updated: "
    if vim.fn.getline(9):match(vim.pesc(check)) then
        if vim.bo.modified then
            if not_rebasing() then
                vim.fn.setline(9, line(9))
            end
        end
        if not_rebasing() then
            vim.fn.setline(4, line(4))
        end
        return false
    end
    return true
end

local function stdheader()
    if update() then
        insert()
    end
end

local function fix_merge_conflict()
    filetype()
    if vim.fn.line('$') < 13 then return end
    local checkline = start .. string.rep(' ', margin - #start) .. "Updated: "
    if vim.fn.getline(9):match("<<<<<<<") and vim.fn.getline(11):match("=======") and vim.fn.getline(13):match(">>>>>>>") and vim.fn.getline(10):match(vim.pesc(checkline)) then
        for i = 9, 11 do
            vim.fn.setline(i, line(i))
        end
        print("42header conflicts automatically resolved!")
        vim.cmd("12,15d")
    elseif vim.fn.line('$') >= 14 and vim.fn.getline(8):match("<<<<<<<") and vim.fn.getline(11):match("=======") and vim.fn.getline(14):match(">>>>>>>") and vim.fn.getline(10):match(vim.pesc(checkline)) then
        for i = 8, 11 do
            vim.fn.setline(i, line(i))
        end
        print("42header conflicts automatically resolved!")
        vim.cmd("12,16d")
    end
end

function M.setup()
    vim.api.nvim_create_user_command('Stdheader', stdheader, {})
    vim.api.nvim_set_keymap('n', '<F1>', ':Stdheader<CR>', {noremap = true})
    vim.api.nvim_create_autocmd('BufWritePre', {callback = function() update() end})
    vim.api.nvim_create_autocmd('BufReadPost', {callback = fix_merge_conflict})
end

return M
