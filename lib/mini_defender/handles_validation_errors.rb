# frozen_string_literal: true

module MiniDefender::HandlesValidationErrors
  extend ActiveSupport::Concern

  included do
    rescue_from MiniDefender::ValidationError, with: :handle_validation_error
  end

  private

  def handle_validation_error(error)
    unless self.respond_to?(:respond_to)
      return render json: { message: error.message, errors: error.errors }, status: :unprocessable_entity
    end

    respond_to do |format|
      format.html do
        flash[:error] = error.message
        flash[:validation_errors] = error.errors
        flash[:old_values] = safe_values

        redirect_back fallback_location: '/'
      end

      format.json do
        render json: { message: error.message, errors: error.errors }, status: :unprocessable_entity
      end
    end
  end

  def safe_values
    forbidden_keys = %w[password password_confirmation]

    params.to_unsafe_h
      .deep_stringify_keys
      .reject { |k, _| forbidden_keys.include?(k) }
  end
end
