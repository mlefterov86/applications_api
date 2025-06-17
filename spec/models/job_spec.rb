# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:events).class_name('Job::Event').dependent(:destroy) }
    it { is_expected.to have_many(:applications).dependent(:destroy) }
  end

  describe 'scopes' do
    context 'when searching for active jobs' do
      let!(:activated_event) {  create(:job_event_activated, created_at: 1.day.from_now) }

      before { create(:job_event_deactivated) }

      it 'returns active jobs by latest created_at event' do
        expect(described_class.active).to eq [activated_event.job]
      end
    end

    context 'when searching for deactivated jobs' do
      let!(:deactivated_event) { create(:job_event_deactivated, created_at: 1.day.from_now) }

      before { create(:job_event_activated) }

      it 'returns deactivated jobs by latest created_at event' do
        expect(described_class.deactivated).to eq [deactivated_event.job]
      end
    end
  end

  describe '#status' do
    subject(:status) { job.status }

    let(:job) { create(:job) }

    context 'when the last event is activated' do
      before do
        create(:job_event_deactivated, job: job)
        create(:job_event_activated, job: job)
      end

      it 'returns activated' do
        expect(status).to eq('activated')
      end
    end

    context 'when the last event is deactivated' do
      before do
        create(:job_event_activated, job: job)
        create(:job_event_deactivated, job: job)
      end

      it 'returns deactivated' do
        expect(status).to eq('deactivated')
      end
    end

    context 'when there are no events' do
      it 'returns deactivated' do
        expect(status).to eq('deactivated')
      end
    end
  end

  describe '#last_interview_date' do
    let(:job) { create(:job) }

    let!(:latest_interview) do
      create(:application_event_interview, application: create(:application, job: job), created_at: 1.day.ago)
    end

    before do
      # creates multiple interviews for the same job
      create(:application_event_interview, application: create(:application, job: job), created_at: 2.days.ago)
    end

    it 'returns the last interview date' do
      expect(job.last_interview_date).to eq(latest_interview.created_at)
    end
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
