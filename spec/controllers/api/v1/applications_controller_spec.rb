# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ApplicationsController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers

  describe 'GET #index' do
    let!(:active_job) { create(:job_event_activated).job }
    let!(:deactivated_job) { create(:job_event_deactivated).job }
    let!(:application) { create(:application, job: active_job) }
    let(:parsed_response) {  JSON.parse(get(:index).body) }

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'does not return applications for deactivated jobs' do
      expect(parsed_response).not_to include(
        a_hash_including('job_title' => deactivated_job.title)
      )
    end

    it 'returns the list of applications for active jobs' do
      expect(parsed_response).to be_an(Array)
      expect(parsed_response.size).to eq(1)
    end

    it 'includes the job title in the response' do
      expect(parsed_response.first['job_name']).to eq(active_job.title)
    end

    it 'includes the candidate name in the response' do
      expect(parsed_response.first['candidate_name']).to eq(application.candidate_name)
    end

    it 'includes the status in the response' do
      expect(parsed_response.first['status']).to eq(application.status)
    end

    it 'includes the notes count in the response' do
      create_list(:application_event_note, 2, application: application)
      expect(parsed_response.first['notes']).to eq(2)
    end

    it 'includes the last interviewed at date in the response' do
      freeze_time do
        last_interviewed_at = 1.day.ago.utc
        create(:application_event_interview, application: application, created_at: 2.days.ago.utc)
        create(:application_event_interview, application: application, created_at: last_interviewed_at)

        expect(parsed_response.first['last_interviewed_at']).to eq(last_interviewed_at.strftime('%Y-%m-%d %H:%M:%S'))
      end
    end
  end
end
