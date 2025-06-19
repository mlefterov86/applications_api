# frozen_string_literal: true

module Api
  module V1
    class ApplicationsController < ApplicationController
      def index
        render json: applications_list, each_serializer: Api::V1::ApplicationSerializer
      end

      private

      def applications_list
        Application
          .with_notes_count
          .with_last_interviewed_at
          .includes(:job, :events)
          .joins(:job)
          .merge(Job.active)
          .left_joins(:events)
          .group('applications.id, jobs.title')
      end
    end
  end
end
