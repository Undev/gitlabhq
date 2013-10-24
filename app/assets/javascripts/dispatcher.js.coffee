$ ->
  new Dispatcher()

class Dispatcher
  constructor: () ->
    @initSearch()
    @initPageScripts()

  initPageScripts: ->
    page = $('body').attr('data-page')
    project_id = $('body').attr('data-project-id')

    unless page
      return false

    path = page.split(':')

    switch page
      when 'projects:issues:index'
        Issues.init()
      when 'projects:issues:new', 'projects:merge_requests:new'
        GitLab.GfmAutoComplete.setup()
      when 'dashboard:show'
        new Dashboard()
        new Activities()
      when 'projects:commit:show'
        new Commit()
      when 'groups:show'
        new Activities()
        new SidebarFilter()
        new SidebarTabs('groups')
      when 'projects:show'
        new Activities()
        new SidebarFilter()
        new SidebarTabs('projects')
      when 'teams:show'
        new Activities()
        new SidebarFilter()
        new SidebarTabs('teams')
      when 'projects:new', 'projects:edit'
        new Project()
      when 'projects:walls:show'
        new Wall(project_id)
      when 'projects:teams:members:index'
        new TeamMembers()
      when 'groups:members'
        new GroupMembers()
      when 'projects:tree:show'
        new TreeView()
      when 'projects:blob:show'
        new BlobView()
      when 'users:show'
        new SidebarFilter()
        new SidebarTabs('users')

    switch path.first()
      when 'admin' then new Admin()
      when 'projects'
        new Wikis() if path[1] == 'wikis'


  initSearch: ->
    autocomplete_json = $('.search-autocomplete-json').data('autocomplete-opts')
    new SearchAutocomplete(autocomplete_json)
