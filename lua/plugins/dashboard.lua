return {
  'nvimdev/dashboard-nvim',
  lazy = false,
  priority = 90,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local dashboard = require 'dashboard'
    local telescope = require 'telescope.builtin'

    local dashboard_cache_dir = vim.fs.joinpath(vim.fn.stdpath 'cache', 'dashboard')
    local dashboard_conf = vim.fs.joinpath(dashboard_cache_dir, 'conf')
    local dashboard_project_cache = vim.fs.joinpath(dashboard_cache_dir, 'cache')
    local saved_projects_file = vim.fs.joinpath(vim.fn.stdpath 'state', 'dashboard-sessions.json')

    local function normalize(path)
      return vim.fs.normalize(vim.fn.fnamemodify(path, ':p'))
    end

    local function read_saved_projects()
      local ok, lines = pcall(vim.fn.readfile, saved_projects_file)
      if not ok or not lines or #lines == 0 then
        return {}
      end

      local ok_decode, data = pcall(vim.json.decode, table.concat(lines, '\n'))
      if not ok_decode or type(data) ~= 'table' then
        return {}
      end

      local projects = {}
      local seen = {}
      for _, project in ipairs(data) do
        if type(project) == 'string' then
          local fullpath = normalize(project)
          if vim.fn.isdirectory(fullpath) == 1 and not seen[fullpath] then
            seen[fullpath] = true
            table.insert(projects, fullpath)
          end
        end
      end

      return projects
    end

    local function write_saved_projects(projects)
      vim.fn.mkdir(vim.fn.fnamemodify(saved_projects_file, ':h'), 'p')
      vim.fn.writefile({ vim.json.encode(projects) }, saved_projects_file)
    end

    local function write_dashboard_project_cache()
      vim.fn.mkdir(dashboard_cache_dir, 'p')

      local lines = { 'return {' }
      for _, project in ipairs(read_saved_projects()) do
        table.insert(lines, string.format('  %q,', project))
      end
      table.insert(lines, '}')

      vim.fn.writefile(lines, dashboard_project_cache)
    end

    local function add_saved_project(path)
      local project = normalize(path)
      if vim.fn.isdirectory(project) == 0 then
        vim.notify('Project not found: ' .. project, vim.log.levels.WARN, { title = 'Dashboard' })
        return nil
      end

      local projects = read_saved_projects()
      local next_projects = {}
      for _, existing in ipairs(projects) do
        if existing ~= project then
          table.insert(next_projects, existing)
        end
      end

      table.insert(next_projects, project)
      write_saved_projects(next_projects)
      write_dashboard_project_cache()
      return project
    end

    local function delete_session_file(project)
      local ok_config, session_config = pcall(require, 'session_manager.config')
      local ok_utils, session_utils = pcall(require, 'session_manager.utils')
      if not ok_config or not ok_utils then
        return
      end

      local session_file = session_config.dir_to_session_filename(project)
      if session_file and session_file.exists and session_file:exists() then
        session_utils.delete_session(session_file.filename)
      end
    end

    local function remove_saved_project(project)
      project = normalize(project)
      local next_projects = {}
      for _, existing in ipairs(read_saved_projects()) do
        if existing ~= project then
          table.insert(next_projects, existing)
        end
      end

      write_saved_projects(next_projects)
      write_dashboard_project_cache()
      delete_session_file(project)
      vim.notify('Deleted session: ' .. project, vim.log.levels.INFO, { title = 'Dashboard' })
    end

    local function refresh_dashboard()
      write_dashboard_project_cache()
    end

    local function save_session(path)
      local project = add_saved_project(path ~= '' and path or vim.fn.getcwd())
      if not project then
        return
      end

      local current_dir = vim.fn.getcwd()
      if normalize(current_dir) ~= project then
        vim.cmd.cd(vim.fn.fnameescape(project))
      end

      local ok, session_manager = pcall(require, 'session_manager')
      if ok and type(session_manager.save_current_session) == 'function' then
        session_manager.save_current_session()
      else
        vim.cmd('mksession! ' .. vim.fn.fnameescape(vim.fs.joinpath(project, 'Session.vim')))
      end

      if normalize(current_dir) ~= project then
        vim.cmd.cd(vim.fn.fnameescape(current_dir))
      end

      vim.notify('Saved session: ' .. project, vim.log.levels.INFO, { title = 'Dashboard' })
    end

    local function delete_session(path)
      if path and path ~= '' then
        remove_saved_project(path)
        return
      end

      local projects = read_saved_projects()
      if #projects == 0 then
        vim.notify('No saved sessions', vim.log.levels.INFO, { title = 'Dashboard' })
        return
      end

      vim.ui.select(projects, {
        prompt = 'Delete session',
        format_item = function(item)
          return vim.fn.fnamemodify(item, ':~')
        end,
      }, function(choice)
        if choice then
          remove_saved_project(choice)
        end
      end)
    end

    local function open_project(path)
      local project = normalize(path)
      local ok, neovim_project = pcall(require, 'neovim-project.project')
      if ok and type(neovim_project.switch_project) == 'function' then
        neovim_project.switch_project(project)
        return
      end

      vim.cmd.cd(vim.fn.fnameescape(project))
      telescope.find_files { cwd = project, hidden = true }
    end

    local function open_folder()
      local dir = vim.trim(vim.fn.input('Open folder: ', vim.fn.getcwd(), 'dir'))
      if dir == '' then
        return
      end

      dir = normalize(dir)
      if vim.fn.isdirectory(dir) == 0 then
        vim.notify('Folder not found: ' .. dir, vim.log.levels.WARN, { title = 'Dashboard' })
        return
      end

      vim.cmd.cd(vim.fn.fnameescape(dir))
      telescope.find_files { cwd = dir, hidden = true }
    end

    _G.NeovideDashboard = {
      open_folder = open_folder,
      find_files = function()
        telescope.find_files { hidden = true }
      end,
      project_history = function()
        vim.cmd 'NeovimProjectHistory'
      end,
      open_project = open_project,
      save_session = save_session,
      delete_session = delete_session,
      refresh = refresh_dashboard,
    }

    vim.api.nvim_create_user_command('SaveSession', function(args)
      save_session(args.args)
    end, {
      nargs = '?',
      complete = 'dir',
      desc = 'Save the current project session and show it on the dashboard',
    })

    vim.api.nvim_create_user_command('DeleteSession', function(args)
      delete_session(args.args)
    end, {
      nargs = '?',
      complete = function()
        return read_saved_projects()
      end,
      desc = 'Delete a saved dashboard session',
    })

    vim.keymap.set('c', '<CR>', function()
      local command = vim.fn.getcmdline()
      if vim.fn.getcmdtype() == ':' then
        if command:match '^save%-session%s*' then
          return '<C-u>SaveSession' .. command:sub(#'save-session' + 1) .. '<CR>'
        end
        if command:match '^delete%-session%s*' then
          return '<C-u>DeleteSession' .. command:sub(#'delete-session' + 1) .. '<CR>'
        end
      end
      return '<CR>'
    end, { expr = true, desc = 'Dashboard session command aliases' })

    refresh_dashboard()
    pcall(vim.fn.delete, dashboard_conf)

    dashboard.setup {
      theme = 'hyper',
      shortcut_type = 'number',
      config = {
        header = {
          '',
          '',
          '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗██████╗ ███████╗',
          '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║██╔══██╗██╔════╝',
          '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██║  ██║█████╗  ',
          '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║  ██║██╔══╝  ',
          '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██████╔╝███████╗',
          '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═════╝ ╚══════╝',
          '',
          'Saved sessions and a clean launchpad.',
          '',
        },
        shortcut = {
          {
            icon = ' ',
            desc = 'Open Folder',
            group = 'Label',
            action = "_G.NeovideDashboard.open_folder()",
            key = 'o',
          },
          {
            icon = ' ',
            desc = 'Find Files',
            group = 'Label',
            action = "_G.NeovideDashboard.find_files()",
            key = 'f',
          },
          {
            icon = ' ',
            desc = 'Save Session',
            group = 'Label',
            action = "_G.NeovideDashboard.save_session('')",
            key = 's',
          },
          {
            icon = ' ',
            desc = 'Delete Session',
            group = 'Label',
            action = "_G.NeovideDashboard.delete_session('')",
            key = 'd',
          },
          {
            icon = ' ',
            desc = 'Project History',
            group = 'Label',
            action = "_G.NeovideDashboard.project_history()",
            key = 'p',
          },
          {
            icon = ' ',
            desc = 'Quit',
            group = 'Label',
            action = 'qa',
            key = 'q',
          },
        },
        project = {
          enable = true,
          limit = 8,
          icon = ' ',
          label = ' Saved Sessions:',
          action = "_G.NeovideDashboard.open_project(...)",
        },
        mru = {
          enable = false,
        },
        footer = {
          '',
          'Use :save-session to add the current project. Use :delete-session to remove one.',
        },
      },
      hide = {
        statusline = false,
        tabline = false,
        winbar = false,
      },
    }

    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('dashboard-startup', { clear = true }),
      callback = function()
        refresh_dashboard()
        if vim.fn.argc() ~= 0 or vim.fn.line2byte '$' ~= -1 then
          return
        end
        vim.cmd 'Dashboard'
      end,
    })
  end,
}
