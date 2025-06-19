# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:events).class_name('Job::Event').dependent(:destroy) }
    it { is_expected.to have_many(:applications).dependent(:destroy) }
  end

  describe 'scopes' do
    describe '.active' do
      let!(:activated_event) { create(:job_event_activated, created_at: 1.day.from_now) }

      before { create(:job_event_deactivated) }

      it 'returns active jobs by latest created_at event' do
        expect(described_class.active).to eq [activated_event.job]
      end
    end

    describe '.deactivated' do
      let!(:deactivated_event) { create(:job_event_deactivated, created_at: 1.day.from_now) }

      before { create(:job_event_activated) }

      it 'returns deactivated jobs by latest created_at event' do
        expect(described_class.deactivated).to eq [deactivated_event.job]
      end
    end

    describe '.with_recent_application_events' do
      subject(:with_recent_application_events) { described_class.with_recent_application_events }

      let!(:job_with_hired_event) do
        create(:application_event_hired, created_at: 1.day.ago).application.job
      end

      let!(:job_with_rejected_event) do
        create(:application_event_rejected, created_at: 2.days.ago).application.job
      end

      let!(:job_with_ongoing_event) do
        create(:application_event_interview, created_at: 3.days.ago).application.job
      end

      let!(:job_with_note_event) do
        create(:application_event_note, created_at: 4.days.ago).application.job
      end

      it 'returns jobs with recent application events excluding notes' do
        expect(with_recent_application_events).to include(job_with_hired_event, job_with_rejected_event,
                                                          job_with_ongoing_event)
      end

      it 'retuns jobs excluding notes' do
        expect(with_recent_application_events).not_to include(job_with_note_event)
      end

      it 'calculates hired counts correctly' do
        expect(with_recent_application_events.first.hired_count).to eq(1)
      end

      it 'calculates rejected counts correctly' do
        expect(with_recent_application_events.first.rejected_count).to eq(1)
      end

      it 'calculates ongoing counts correctly' do
        expect(with_recent_application_events.first.ongoing_count).to eq(1)
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
