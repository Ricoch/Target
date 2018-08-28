# encoding: utf-8

module Api
  module V1
    class ApiController < ApplicationController
      include Api::Concerns::ActAsApiRequest
      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_user!, except: :status

      layout false
      respond_to :json

      rescue_from Exception,                           with: :render_error
      rescue_from ArgumentError,                       with: :render_argument_error
      rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
      rescue_from ActionController::RoutingError,      with: :render_not_found
      rescue_from AbstractController::ActionNotFound,  with: :render_not_found
      rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing

      def status
        render json: { online: true }
      end

      private

      def render_error(exception)
        raise exception if Rails.env.test?

        # To properly handle RecordNotFound errors in views
        if exception.cause.is_a?(ActiveRecord::RecordNotFound)
          return render_not_found(exception)
        end

        logger.error(exception) # Report to your error managment tool here
        render json: { error: I18n.t('api.errors.server') }, status: 500 unless performed?
      end

      def render_not_found(exception)
        logger.info(exception) # for logging
        render json: { error: I18n.t('api.errors.not_found') }, status: :not_found
      end

      def render_record_invalid(exception)
        logger.info(exception) # for logging
        render json: { errors: exception.record.errors.as_json }, status: :bad_request
      end

      def render_parameter_missing(exception)
        logger.info(exception) # for logging
        render json: { error: I18n.t('api.errors.missing_param') }, status: :unprocessable_entity
      end

      def render_argument_error(exception)
        logger.info(exception) # for logging
        render json: { error: I18n.t('api.errors.argument_error') }, status: :bad_request
      end
    end
  end
end
