module Projects::ServicesActions
  private

  def create_service_action(role = :user)
    service_params = params
    service_type = service_params.delete(:service_type)
    service_configuration_params = service_params.delete(:configuration)

    if role == :admin
      service_params.delete(:state_event)
    else
      service_params.delete(:active_state_event)
      service_params.delete(:public_state_event)
    end

    service = Service.build_by_type(service_type, params)

    if service.save
      service.create_configuration(service_configuration_params) if service.respond_to(:configuration)
    end

    service
  end

  def update_service_action(service)
    service_params = params
    service_configuration_params = service_params.delete(:configuration)

    if role == :admin
      service_params.delete(:state_event)
    else
      service_params.delete(:active_state_event)
      service_params.delete(:publish_state_event)
    end

    if service.update(service_params)
      service.configuration.update(service_configuration_params) if service.respond_to?(:configuration)
    end

    service
  end

end
