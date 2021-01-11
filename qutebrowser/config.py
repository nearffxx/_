c.auto_save.session = True
c.url.default_page = 'https://www.google.com/ncr'
c.url.searchengines = {'DEFAULT': 'https://www.google.com/search?hl=en&q={}'}
c.url.start_pages = 'https://www.google.com/ncr'
c.input.insert_mode.leave_on_load = False
config.bind('<Shift-M>', 'hint links spawn mpv {hint-url}')
config.bind('<M>', 'spawn mpv {url}')
