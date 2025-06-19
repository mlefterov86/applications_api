# frozen_string_literal: true

# spec/models/application_spec.rb

require 'rails_helper'

RSpec.describe Application, type: :model do
  let(:application) { create(:application) }

  describe 'associations' do
    it { is_expected.to belong_to(:job) }
    it { is_expected.to have_many(:events).class_name('Application::Event').dependent(:destroy) }
  end

  describe 'scopes' do
    # creates other application in different state
    let!(:hired_application) { create(:application_event_hired).application }
    let!(:rejected_application) { create(:application_event_rejected).application }
    let!(:interviewing_application) { create(:application_event_interview).application }

    context 'when searching for hired applications' do
      let!(:hired_event) { create(:application_event_hired, application: application, created_at: 1.day.from_now) }

      before do
        # creates multiple events for the same application
        create(:application_event_rejected, application: application)
        create(:application_event_interview, application: application)
      end

      it 'returns hired applications by latest event' do
        expect(described_class.hired).to eq [hired_application, hired_event.application]
      end
    end

    context 'when searching for rejected applications' do
      let!(:rejected_event) do
        create(:application_event_rejected, application: application, created_at: 1.day.from_now)
      end

      before do
        # creates multiple events for the same application
        create(:application_event_hired, application: application)
        create(:application_event_interview, application: application)
      end

      it 'returns rejected applications by latest event' do
        expect(described_class.rejected).to eq [rejected_application, rejected_event.application]
      end
    end

    context 'when searching for interviewing applications' do
      let!(:interview_event) do
        create(:application_event_interview, application: application, created_at: 1.day.from_now)
      end

      before do
        # creates multiple events for the same application
        create(:application_event_hired, application: application)
        create(:application_event_rejected, application: application)
      end

      it 'returns interviewing applications by latest event' do
        expect(described_class.interviewing).to eq [interviewing_application, interview_event.application]
      end
    end
  end

  describe '#status' do
    subject(:status) { application.status }

    context 'when the last event is an interview' do
      before do
        create(:application_event_interview, application: application, created_at: 1.day.from_now)
        create(:application_event_rejected, application: application)
      end

      it 'returns interview' do
        expect(status).to eq('interview')
      end
    end

    context 'when the last event is hired' do
      before do
        create(:application_event_hired, application: application, created_at: 1.day.from_now)
        create(:application_event_rejected, application: application)
      end

      it 'returns hired' do
        expect(status).to eq('hired')
      end
    end

    context 'when the last event is rejected' do
      before do
        create(:application_event_rejected, application: application, created_at: 1.day.from_now)
        create(:application_event_interview, application: application)
      end

      it 'returns rejected' do
        expect(status).to eq('rejected')
      end
    end

    context 'when there are no events' do
      it 'returns applied' do
        expect(status).to eq('applied')
      end
    end
  end
end

# == Schema Information
#
# Table name: applications
#
#  id             :integer          not null, primary key
#  candidate_name :string
#  job_id         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
