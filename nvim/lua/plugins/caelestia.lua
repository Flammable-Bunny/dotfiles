return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = function(_, opts)
      opts.flavour = "mocha" -- Standard Catppuccin base
      opts.transparent_background = true -- Matches Caelestia's typical look

      -- 1. Find the generated Caelestia JSON file
      local function get_caelestia_data()
        -- Find the newest folder in ~/.cache/caelestia/schemes/
        local handle = io.popen('ls -td ~/.cache/caelestia/schemes/*/ 2>/dev/null | head -1')
        local latest_dir = handle:read("*a"):gsub("\n", "")
        handle:close()

        if latest_dir == "" then return nil end

        -- Read the vibrant/dark.json file inside that folder
        local file_path = latest_dir .. "vibrant/dark.json"
        local file = io.open(file_path, "r")
        if not file then return nil end

        local content = file:read("*a")
        file:close()

        -- Decode the JSON
        local ok, data = pcall(vim.json.decode, content)
        if not ok then return nil end
        return data
      end

      -- 2. Apply the colors if found
      local c = get_caelestia_data()
      if c then
        -- Helper to add '#' to the hex codes
        local function h(hex) return "#" .. (hex or "000000") end

        opts.color_overrides = {
          mocha = {
            -- Backgrounds
            base = h(c.base),
            mantle = h(c.mantle),
            crust = h(c.crust),
            
            -- UI Text
            text = h(c.text),
            subtext1 = h(c.subtext1),
            subtext0 = h(c.subtext0),
            
            -- Syntax Colors (The "Vibrant" part)
            blue = h(c.blue),
            mauve = h(c.mauve),
            pink = h(c.pink),
            red = h(c.red),
            peach = h(c.peach),
            yellow = h(c.yellow),
            green = h(c.green),
            teal = h(c.teal),
          },
        }
      end
    end,
  },
  
  -- Ensure LazyVim knows to load it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
