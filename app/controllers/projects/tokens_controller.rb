class Projects::TokensController < Projects::ApplicationController
  include ExtractsPath
  skip_before_filter :assign_ref_vars, only: [:index, :destroy]

  def index
    @tokens = FileToken.where(project_id: @project)
  end

  def show
  end

  def destroy
    token = FileToken.find(params[:id])
    token.destroy
    redirect_to project_tokens_path(@project)
  end

  def create
    file_token = FileToken.new(project_id: @project.id, user_id: current_user.id, file: @path, source_ref: @ref)
    file_token.generate_token!

    if file_token.save
      redirect_to project_raw_path(@project.path_with_namespace, @id, file_auth_token: file_token.token)
    else
      redirect_to project_raw_path(@project.path_with_namespace, @id)
    end
  end
end
