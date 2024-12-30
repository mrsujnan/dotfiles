config.source("themes/qute-city-lights/city-lights-theme.py")

# Enable dark mode for the browser UI
# c.qt.args = ["--force-dark-mode"]

config.set("colors.webpage.darkmode.enabled", True)

# config.set("content.user_stylesheets", ["~/.config/qutebrowser/darkmode.css"])

config.bind("<Ctrl-d>", "config-cycle colors.webpage.darkmode.enabled")
config.bind('jk', 'mode-leave', mode='normal')
config.bind('jk', 'leave-mode', mode='insert')
config.bind('jk', 'leave-mode', mode='command')

config.load_autoconfig()
