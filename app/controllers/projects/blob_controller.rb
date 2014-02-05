# Controller for viewing a file's blame
class Projects::BlobController < Projects::ApplicationController
  include ExtractsPath

  # Authorize
  before_filter :authorize_read_project!
  before_filter :authorize_code_access!
  before_filter :require_non_empty_project

  before_filter :blob

  def show
  end

  def destroy
    result = ProjectsService.new(current_user, @project, params).repository.create_file(@ref, @path)

    if result[:status] == :success
      flash[:notice] = "Your changes have been successfully committed"
      redirect_to project_tree_path(@project, @ref)
    else
      flash[:alert] = result[:error]
      render :show
    end
  end

  private

  def blob
    @blob ||= @repository.blob_at(@commit.id, @path)

    return not_found! unless @blob

    @file_token = FileToken.for_project(@project).find_by_file(@path)
    @blob
  end
end
