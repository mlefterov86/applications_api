# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :controller do
  describe 'GET #index' do
    let!(:active_job) { create(:job_event_activated).job }
    let!(:deactivated_job) { create(:job_event_deactivated).job }
    let(:parsed_response) {  JSON.parse(get(:index).body) }

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the list of all jobs' do
      expect(parsed_response.size).to eq(2)
      expect(parsed_response.first['id']).to eq(active_job.id)
      expect(parsed_response.second['id']).to eq(deactivated_job.id)
    end

    it 'returns hired applications count' do
      active_job_applications = create_list(:application, 2, job: active_job)
      active_job_applications.each do |app|
        create(:application_event_hired, application: app)
      end

      expect(parsed_response.first['hired_candidates']).to eq(2)
      expect(parsed_response.last['hired_candidates']).to eq(0)
    end

    it 'returns rejected applications count' do
      active_job_applications = create_list(:application, 2, job: active_job)
      active_job_applications.each do |app|
        create(:application_event_rejected, application: app)
      end

      expect(parsed_response.first['rejected_candidates']).to eq(2)
      expect(parsed_response.second['rejected_candidates']).to eq(0)
    end

    it 'returns ongoing applications count' do
      active_job_applications = create_list(:application, 2, job: active_job)
      active_job_applications.each do |app|
        create(:application_event_interview, application: app)
      end

      expect(parsed_response.first['ongoing_applications']).to eq(2)
      expect(parsed_response.second['ongoing_applications']).to eq(0)
    end
  end
end
