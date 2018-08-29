# encoding: utf-8

module Api
  module V1
    class TargetsController < Api::V1::ApiController
      def create
        @target = current_user.targets.create! target_params
      end

      def index
        @targets = current_user.targets
      end

      def show
        @target = current_user.targets.find(params[:id])
      end

      private

      def target_params
        params.require(:target).permit(:radius, :title, :topic, :latitude, :longitude)
      end
    end
  end
end
