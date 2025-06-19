# frozen_string_literal: true

module Api
  module V1
    class ApplicationSerializer < ActiveModel::Serializer
      attributes :id, :job_name, :candidate_name, :status, :notes, :last_interviewed_at

      def job_name
        object.job.title
      end

      def notes
        object&.notes_count
      end

      delegate :candidate_name, to: :object
      delegate :status, to: :object
      delegate :last_interviewed_at, to: :object
    end
  end
end
