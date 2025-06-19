# frozen_string_literal: true

module Api
  module V1
    class JobSerializer < ActiveModel::Serializer
      attributes :id, :name, :status, :hired_candidates, :rejected_candidates, :ongoing_applications

      delegate :id, to: :object

      def name
        object.title
      end

      delegate :status, to: :object

      def hired_candidates
        object.hired_count
      end

      def rejected_candidates
        object.rejected_count
      end

      def ongoing_applications
        object.ongoing_count
      end
    end
  end
end
