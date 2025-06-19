# frozen_string_literal: true

module Api
  module V1
    class JobsController < ApplicationController
      def index
        render json: list_jobs, each_serializer: Api::V1::JobSerializer
      end

      private

      def list_jobs
        Job.includes(:events)
           .left_outer_joins(applications: :events)
           .select('jobs.*')
           .with_recent_application_events
           .group('jobs.id')
           .order('jobs.id ASC')
      end
    end
  end
end
