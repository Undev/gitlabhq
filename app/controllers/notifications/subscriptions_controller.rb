class Notifications::SubscriptionsController < Notifications::ApplicationController
  before_filter :load_entity, only: [:create, :destroy]

  def create
    SubscriptionService.subscribe(@current_user, :all, @entity, :all) if @entity
    SubscriptionService.subscribe(@current_user, :all, params[:category], :new) if @category.blank? && params[:category].present?

    respond_to do |format|
      format.json { head :created }
      format.html { redirect_to profile_subscriptions_path }
    end
  end

  def on_all
    SubscriptionService.subscribe_on_all(@current_user, params[:category], :all, :all) if params[:category]
    redirect_to profile_subscriptions_path
  end

  def from_all
    SubscriptionService.unsubscribe_from_all(@current_user, params[:category], :all, :all) if params[:category]
    redirect_to profile_subscriptions_path
  end

  def on_own_changes
    @current_user.notification_setting.own_changes = true

    @current_user.notification_setting.save

    respond_to do |format|
      format.json { head :created }
      format.html { redirect_to profile_subscriptions_path }
    end
  end

  def from_own_changes
    @current_user.notification_setting.own_changes = false

    @current_user.notification_setting.save

    respond_to do |format|
      format.json { head :no_content }
      format.html { redirect_to profile_subscriptions_path }
    end
  end

  def destroy
    SubscriptionService.unsubscribe(@current_user, :all, @entity, :all) if @entity
    SubscriptionService.unsubscribe(@current_user, :all, params[:category], :new) if @category

    respond_to do |format|
      format.json { head :no_content }
      format.html { redirect_to profile_subscriptions_path }
    end
  end

  protected

  def load_entity
    if params[:entity]
      @entity ||= params[:entity][:type].camelize.constantize.find params[:entity][:id]
    end

    if params[:category]
      @category ||= Event::Subscription.by_user(@current_user).by_target_category(params[:category])
    end
  end
end