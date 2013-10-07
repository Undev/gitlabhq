class Admin::Services::KeysController < Admin::Services::ApplicationController
  def index
    @enabled_keys = @service.service_keys.all
    @available_keys = available_keys - @enabled_keys
  end

  def show
    @key = @service.service_keys.find(params[:id])
  end

  def new
    @key = @service.service_keys.new

    respond_with(@key)
  end

  def create
    @key = ServiceKey.new(params[:service_key])

    if @key.valid? && @service.service_keys << @key
      redirect_to service_service_keys_path(@service)
    else
      render "new"
    end
  end

  def destroy
    @key = @service.service_keys.find(params[:id])
    @key.destroy

    respond_to do |format|
      format.html { redirect_to service_service_keys_url }
      format.js { render nothing: true }
    end
  end

  def enable
    service.service_keys << available_keys.find(params[:id])

    redirect_to service_service_keys_path(@service)
  end

  def disable
    @service.service_keys_services.where(service_key_id: params[:id]).last.destroy

    redirect_to service_service_keys_path(@service)
  end

  protected

  def available_keys
    @available_keys ||= ServiceKey.scoped
  end
end
