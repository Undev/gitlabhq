class Project
  constructor: ->
    $('.project-edit-container').on 'ajax:before', =>
      $('.project-edit-container').hide()
      $('.save-project-loader').show()

    @initEvents()


  initEvents: ->
    disableButtonIfEmptyField '#project_name', '.project-submit'

    # Issues
    $('#project_issues_enabled').change ->
      if ($(this).is(':checked') == true)
        $('#project_issues_tracker').removeAttr('disabled')
      else
        $('#project_issues_tracker').attr('disabled', 'disabled')

      $('#project_issues_tracker').change()

    $('#project_issues_tracker').change ->
      if ($(this).val() == "gitlab" || $(this).is(':disabled'))
        $('#project_issues_tracker_id').attr('disabled', 'disabled')
      else
        $('#project_issues_tracker_id').removeAttr('disabled')

    # Wiki
    $('#project_wiki_enabled').change ->
      if ($(this).is(':checked') == true)
        $('#project_wiki_engine').removeAttr('disabled')
      else
        $('#project_wiki_engine').attr('disabled', 'disabled')

      $('#project_wiki_engine').change()

    $('#project_wiki_engine').change ->
      if ($(this).val() == "gitlab" || $(this).is(':disabled'))
        $('#project_wiki_external_id').attr('disabled', 'disabled')
      else
        $('#project_wiki_external_id').removeAttr('disabled')

    $('form#new_project #project_name').on 'keyup', ->
      slug = $.friendly_id $(this).val()
      if slug != $(this).val().trim()
        $('#auto_slug').show()
        $('#name_parametrized').val(slug + '.git')
      else
        $('#auto_slug').hide()

@Project = Project

$ ->
  # Git clone panel switcher
  scope = $ '.git-clone-holder'
  if scope.length > 0
    $('a, button', scope).click ->
      $('a, button', scope).removeClass 'active'
      $(@).addClass 'active'
      $('#project_clone', scope).val $(@).data 'clone'
      $(".clone").text("").append $(@).data 'clone'

  # Ref switcher
  $('.project-refs-select').on 'change', ->
    $(@).parents('form').submit()

  $('.hide-no-ssh-message').on 'click', (e) ->
    path = '/'
    $.cookie('hide_no_ssh_message', 'false', { path: path })
    $(@).parents('.no-ssh-key-message').hide()
    e.preventDefault()
